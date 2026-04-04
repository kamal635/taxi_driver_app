package com.yourcompany.taxi_driver.taxi_driver_app

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.location.Location as AndroidLocation
import android.location.LocationManager
import android.media.AudioAttributes
import android.media.AudioManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.SystemClock
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.LocationAvailability
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import org.json.JSONException
import org.json.JSONObject
import java.io.BufferedWriter
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicInteger
import java.util.concurrent.atomic.AtomicLong
import kotlin.math.min

class DriverForegroundService : Service() {

    private val serviceHandler = Handler(Looper.getMainLooper())

    private var currentToken: String? = null
    private var currentDriverId: String? = null

    private val isStoppingService = AtomicBoolean(false)
    private val isSendingLocation = AtomicBoolean(false)
    private val consecutiveSendFailures = AtomicInteger(0)
    private val nextAllowedSendAtMs = AtomicLong(0L)

    private val offerSocketManager = DriverOfferSocketManager()

    private val networkExecutor: ExecutorService by lazy {
        Executors.newSingleThreadExecutor()
    }

    private val fusedLocationClient by lazy {
        LocationServices.getFusedLocationProviderClient(this)
    }

    private val prefs: SharedPreferences by lazy {
        getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
    }

    private val lastSentLocationLock = Any()
    private var lastSentLatitude: Double? = null
    private var lastSentLongitude: Double? = null

    private val locationRequest by lazy {
        LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY,
            LOCATION_TICK_INTERVAL_MS
        )
            .setMinUpdateIntervalMillis(10_000L)
            .setMinUpdateDistanceMeters(MIN_LOCATION_UPDATE_DISTANCE_METERS)
            .setWaitForAccurateLocation(false)
            .build()
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service onCreate")
        isRunning = true
        createNotificationChannels()
    }

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int
    ): Int {
        Log.d(TAG, "Service onStartCommand -> action=${intent?.action}")

        return when (intent?.action) {
            ACTION_START -> {
                handleStart(intent)
                START_STICKY
            }

            ACTION_STOP -> {
                handleStop()
                START_NOT_STICKY
            }

            ACTION_LOCATION_UPDATE -> {
                handleLocationUpdateIntent(intent)
                START_STICKY
            }

            else -> {
                if (intent == null) {
                    Log.w(TAG, "Service restarted with null intent")
                    restoreRuntimeStateIfNeeded()
                } else {
                    Log.w(TAG, "Unknown service action: ${intent.action}")
                }
                START_STICKY
            }
        }
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d(TAG, "Service onTaskRemoved")
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        Log.d(TAG, "Service onDestroy")

        stopLocationUpdates()
        offerSocketManager.stop()

        clearLastSentLocation()

        isSendingLocation.set(false)
        isStoppingService.set(false)
        consecutiveSendFailures.set(0)
        nextAllowedSendAtMs.set(0L)

        networkExecutor.shutdownNow()
        isRunning = false

        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun handleStart(intent: Intent) {
        currentToken = intent.getStringExtra(EXTRA_TOKEN) ?: currentToken
        currentDriverId = intent.getStringExtra(EXTRA_DRIVER_ID) ?: currentDriverId

        restoreRuntimeStateIfNeeded()

        if (currentToken.isNullOrBlank() || currentDriverId.isNullOrBlank()) {
            Log.e(TAG, "handleStart aborted: token or driverId is missing")
            stopSelf()
            return
        }

        saveRuntimeState(
            token = currentToken!!,
            driverId = currentDriverId!!
        )

        clearLastSentLocation()

        isSendingLocation.set(false)
        isStoppingService.set(false)
        consecutiveSendFailures.set(0)
        nextAllowedSendAtMs.set(0L)

        Log.d(TAG, "handleStart -> driverId=$currentDriverId")

        val notification = buildServiceNotification()

        val foregroundType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
        } else {
            0
        }

        ServiceCompat.startForeground(
            this,
            NOTIFICATION_ID,
            notification,
            foregroundType
        )

        Log.d(TAG, "Service moved to foreground")

        startLocationUpdates()

        offerSocketManager.stop()
        offerSocketManager.start(
            token = currentToken!!,
            driverId = currentDriverId!!,
            onOfferReceived = ::handleOfferReceived
        )
    }

    private fun handleStop() {
        if (!isStoppingService.compareAndSet(false, true)) {
            Log.d(TAG, "handleStop ignored: service is already stopping")
            return
        }

        Log.d(TAG, "handleStop")

        stopLocationUpdates()
        offerSocketManager.stop()

        currentToken = null
        currentDriverId = null
        clearRuntimeState()
        clearLastSentLocation()

        isSendingLocation.set(false)
        consecutiveSendFailures.set(0)
        nextAllowedSendAtMs.set(0L)

        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun stopServiceDueToUnauthorized() {
        Log.e(TAG, "Unauthorized token detected. Stopping service.")
        MainActivity.notifyFlutterServiceStopped("unauthorized")

        serviceHandler.post {
            handleStop()
        }
    }

    private fun stopServiceDueToLocationIssue(reason: String) {
        Log.w(TAG, "Stopping service due to location issue: $reason")
        MainActivity.notifyFlutterServiceStopped(reason)

        serviceHandler.post {
            handleStop()
        }
    }

    private fun startLocationUpdates() {
        if (!hasLocationPermission()) {
            Log.w(TAG, "Cannot start location updates: permission missing")
            stopServiceDueToLocationIssue("location_permission_missing")
            return
        }

        if (!isLocationServiceEnabled()) {
            Log.w(TAG, "Cannot start location updates: location service disabled")
            stopServiceDueToLocationIssue("location_service_disabled")
            return
        }

        try {
            fusedLocationClient
                .requestLocationUpdates(
                    locationRequest,
                    locationUpdatePendingIntent()
                )
                .addOnSuccessListener {
                    Log.d(TAG, "Location updates registered")
                }
                .addOnFailureListener { error ->
                    Log.e(TAG, "Failed to register location updates", error)
                }
        } catch (error: SecurityException) {
            Log.e(TAG, "SecurityException while registering location updates", error)
            stopServiceDueToLocationIssue("location_permission_missing")
        }
    }

    private fun stopLocationUpdates() {
        fusedLocationClient
            .removeLocationUpdates(locationUpdatePendingIntent())
            .addOnSuccessListener {
                Log.d(TAG, "Location updates removed")
            }
            .addOnFailureListener { error ->
                Log.e(TAG, "Failed to remove location updates", error)
            }
    }

    private fun handleLocationUpdateIntent(intent: Intent?) {
        restoreRuntimeStateIfNeeded()

        if (intent == null) {
            Log.w(TAG, "Location update intent is null")
            return
        }

        val availability = LocationAvailability.extractLocationAvailability(intent)
        val result = LocationResult.extractResult(intent)
        val location = result?.lastLocation

        if (location == null) {
            Log.d(
                TAG,
                "Location update received but location is null. available=${availability?.isLocationAvailable}"
            )

            if (!hasLocationPermission()) {
                stopServiceDueToLocationIssue("location_permission_missing")
                return
            }

            if (!isLocationServiceEnabled()) {
                stopServiceDueToLocationIssue("location_service_disabled")
                return
            }

            return
        }

        val token = currentToken
        val driverId = currentDriverId

        if (token.isNullOrBlank() || driverId.isNullOrBlank()) {
            Log.w(TAG, "Skipping location send: token or driverId is missing")
            return
        }

        if (!shouldSendLocationToBackend(location)) {
            return
        }

        val now = SystemClock.elapsedRealtime()
        val nextAllowedAt = nextAllowedSendAtMs.get()

        if (now < nextAllowedAt) {
            val remainingMs = nextAllowedAt - now
            Log.d(TAG, "Skipping location send: backoff active, remainingMs=$remainingMs")
            return
        }

        if (!isSendingLocation.compareAndSet(false, true)) {
            Log.d(TAG, "Skipping location send: previous request is still running")
            return
        }

        sendLocationToBackend(
            token = token,
            driverId = driverId,
            location = location
        )
    }

    private fun handleOfferReceived(payload: DriverOfferPayload) {
        Log.d(TAG, "Offer received in service")

        showOfferNotification(payload)

        MainActivity.notifyFlutterOfferReceived(
            payloadJson = payload.payloadJson
        )
    }

    private fun showOfferNotification(payload: DriverOfferPayload) {
        val notificationManager = NotificationManagerCompat.from(this)
        val payloadJson = payload.payloadJson

        var title: String
        var body: String
        var notificationId: Int
        var offerIdForLaunch: String?

        try {
            val json = JSONObject(payloadJson)

            val offerId = json.optString("offerId", "")
                .ifBlank { json.optString("id", "") }

            val pickup = json.optString("pickup", "")
                .ifBlank { json.optString("pickup_address", "") }

            val price = json.optString("price", "")

            title = "New trip offer"
            body = buildString {
                if (pickup.isNotBlank()) {
                    append("Pickup: ")
                    append(pickup)
                } else {
                    append("You received a new offer.")
                }

                if (price.isNotBlank()) {
                    append(" • Price: ")
                    append(price)
                }
            }

            notificationId = if (offerId.isNotBlank()) {
                offerId.hashCode()
            } else {
                OFFER_NOTIFICATION_DEFAULT_ID
            }

            offerIdForLaunch = offerId.ifBlank { null }
        } catch (_: JSONException) {
            title = "New trip offer"
            body = "You received a new offer."
            notificationId = OFFER_NOTIFICATION_DEFAULT_ID
            offerIdForLaunch = null
        }

        val notification = buildOfferNotification(
            title = title,
            body = body,
            offerId = offerIdForLaunch,
            payloadJson = payload.payloadJson
        )

        notificationManager.notify(notificationId, notification)
        Log.d(TAG, "Offer notification shown -> id=$notificationId")
    }

    private fun sendLocationToBackend(
        token: String,
        driverId: String,
        location: AndroidLocation
    ) {
        networkExecutor.execute {
            var connection: HttpURLConnection? = null

            try {
                val url = URL(LOCATION_UPDATE_URL)
                connection = (url.openConnection() as HttpURLConnection).apply {
                    requestMethod = "PUT"
                    connectTimeout = 15_000
                    readTimeout = 15_000
                    doInput = true
                    doOutput = true
                    setRequestProperty("Content-Type", "application/json")
                    setRequestProperty("Accept", "application/json")
                    setRequestProperty("Authorization", "Bearer $token")
                }

                val body = JSONObject().apply {
                    put("lat", location.latitude)
                    put("lon", location.longitude)
                }

                BufferedWriter(OutputStreamWriter(connection.outputStream)).use { writer ->
                    writer.write(body.toString())
                    writer.flush()
                }

                val responseCode = connection.responseCode

                if (responseCode in 200..299) {
                    consecutiveSendFailures.set(0)
                    nextAllowedSendAtMs.set(0L)

                    markLocationAsSent(location)

                    Log.d(
                        TAG,
                        "Location sent successfully -> code=$responseCode, driverId=$driverId"
                    )
                } else {
                    val errorBody = try {
                        connection.errorStream?.bufferedReader()?.use { it.readText() }
                    } catch (_: Exception) {
                        null
                    }

                    if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                        Log.e(
                            TAG,
                            "Location send unauthorized -> code=$responseCode, body=$errorBody"
                        )

                        consecutiveSendFailures.set(0)
                        nextAllowedSendAtMs.set(0L)

                        stopServiceDueToUnauthorized()
                    } else {
                        scheduleNextRetry()
                        Log.e(
                            TAG,
                            "Location send failed -> code=$responseCode, body=$errorBody"
                        )
                    }
                }
            } catch (error: Exception) {
                scheduleNextRetry()
                Log.e(TAG, "Failed to send location to backend", error)
            } finally {
                connection?.disconnect()
                isSendingLocation.set(false)
            }
        }
    }

    private fun shouldSendLocationToBackend(location: AndroidLocation): Boolean {
        synchronized(lastSentLocationLock) {
            if (location.hasAccuracy() &&
                location.accuracy > MAX_ACCEPTABLE_ACCURACY_METERS
            ) {
                Log.d(
                    TAG,
                    "Skipping location send: poor accuracy -> ${location.accuracy}m"
                )
                return false
            }

            val lastLat = lastSentLatitude
            val lastLon = lastSentLongitude

            if (lastLat == null || lastLon == null) {
                return true
            }

            val distanceResult = FloatArray(1)
            AndroidLocation.distanceBetween(
                lastLat,
                lastLon,
                location.latitude,
                location.longitude,
                distanceResult
            )

            val movedDistance = distanceResult[0]

            if (movedDistance < MIN_LOCATION_SEND_DISTANCE_METERS) {
                Log.d(
                    TAG,
                    "Skipping location send: movement too small -> ${movedDistance}m"
                )
                return false
            }

            return true
        }
    }

    private fun markLocationAsSent(location: AndroidLocation) {
        synchronized(lastSentLocationLock) {
            lastSentLatitude = location.latitude
            lastSentLongitude = location.longitude
        }
    }

    private fun clearLastSentLocation() {
        synchronized(lastSentLocationLock) {
            lastSentLatitude = null
            lastSentLongitude = null
        }
    }

    private fun scheduleNextRetry() {
        val failureCount = consecutiveSendFailures.incrementAndGet()
        val backoffMs = calculateBackoffMs(failureCount)
        val nextAllowedAt = SystemClock.elapsedRealtime() + backoffMs

        nextAllowedSendAtMs.set(nextAllowedAt)

        Log.w(
            TAG,
            "Location retry scheduled -> failures=$failureCount, backoffMs=$backoffMs"
        )
    }

    private fun calculateBackoffMs(failureCount: Int): Long {
        val multiplier = when (failureCount) {
            1 -> 1L
            2 -> 2L
            else -> 4L
        }

        return min(
            INITIAL_RETRY_BACKOFF_MS * multiplier,
            MAX_RETRY_BACKOFF_MS
        )
    }

    private fun hasLocationPermission(): Boolean {
        val fineGranted = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        val coarseGranted = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        return fineGranted || coarseGranted
    }

    private fun isLocationServiceEnabled(): Boolean {
        val locationManager = getSystemService(LocationManager::class.java)

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            locationManager?.isLocationEnabled == true
        } else {
            try {
                Settings.Secure.getInt(
                    contentResolver,
                    Settings.Secure.LOCATION_MODE
                ) != Settings.Secure.LOCATION_MODE_OFF
            } catch (_: Exception) {
                false
            }
        }
    }

    private fun buildServiceNotification(): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag()
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Driver mode is active")
            .setContentText("Background location and incoming offers are running.")
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()
    }

    private fun buildOfferNotification(
        title: String,
        body: String,
        offerId: String?,
        payloadJson: String
    ): Notification {
        val launchIntent = packageManager
            .getLaunchIntentForPackage(packageName)
            ?.apply {
                putExtra(EXTRA_LAUNCH_SOURCE, LAUNCH_SOURCE_OFFER_NOTIFICATION)

                if (!offerId.isNullOrBlank()) {
                    putExtra(EXTRA_LAUNCHED_OFFER_ID, offerId)
                }

                putExtra(EXTRA_LAUNCHED_OFFER_PAYLOAD, payloadJson)
            }

        val pendingIntent = PendingIntent.getActivity(
            this,
            offerId?.hashCode() ?: 1,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag()
        )

        return NotificationCompat.Builder(this, OFFERS_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setOnlyAlertOnce(false)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .setVibrate(longArrayOf(0, 300, 200, 300))
            .build()
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = getSystemService(NotificationManager::class.java)

        val serviceChannel = NotificationChannel(
            CHANNEL_ID,
            "Driver background service",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = "Keeps driver mode active in the background"
            setShowBadge(false)
            enableVibration(false)
        }

        val soundUri = Uri.parse(
            "android.resource://$packageName/raw/offer_alert"
        )

        val offersChannel = NotificationChannel(
            OFFERS_CHANNEL_ID,
            "Driver offers",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Shows incoming trip offers"
            setShowBadge(true)
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 500, 250, 500, 250, 700)

            setSound(
                soundUri,
                AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setLegacyStreamType(AudioManager.STREAM_RING)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                    .build()
            )
        }

        manager.createNotificationChannel(serviceChannel)
        manager.createNotificationChannel(offersChannel)
    }

    private fun locationUpdatePendingIntent(): PendingIntent {
        val intent = Intent(this, DriverForegroundService::class.java).apply {
            action = ACTION_LOCATION_UPDATE
        }

        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_MUTABLE
            } else {
                0
            }

        return PendingIntent.getService(
            this,
            LOCATION_PENDING_INTENT_REQUEST_CODE,
            intent,
            flags
        )
    }

    private fun immutableFlag(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE
        } else {
            0
        }
    }

    private fun saveRuntimeState(token: String, driverId: String) {
        prefs.edit()
            .putString(PREF_TOKEN, token)
            .putString(PREF_DRIVER_ID, driverId)
            .apply()
    }

    private fun restoreRuntimeStateIfNeeded() {
        if (!currentToken.isNullOrBlank() && !currentDriverId.isNullOrBlank()) {
            return
        }

        currentToken = currentToken ?: prefs.getString(PREF_TOKEN, null)
        currentDriverId = currentDriverId ?: prefs.getString(PREF_DRIVER_ID, null)
    }

    private fun clearRuntimeState() {
        prefs.edit()
            .remove(PREF_TOKEN)
            .remove(PREF_DRIVER_ID)
            .apply()
    }

    companion object {
        private const val TAG = "DriverService"

        private const val PREFS_NAME = "driver_background_service_prefs"
        private const val PREF_TOKEN = "pref_token"
        private const val PREF_DRIVER_ID = "pref_driver_id"

        const val CHANNEL_ID = "driver_background_service_v3"
        const val OFFERS_CHANNEL_ID = "driver_offers_channel_v4"

        const val NOTIFICATION_ID = 1001

        const val ACTION_START = "driver_background_service.action.START"
        const val ACTION_STOP = "driver_background_service.action.STOP"
        const val ACTION_LOCATION_UPDATE = "driver_background_service.action.LOCATION_UPDATE"

        private const val LOCATION_PENDING_INTENT_REQUEST_CODE = 1002

        const val EXTRA_TOKEN = "extra_token"
        const val EXTRA_DRIVER_ID = "extra_driver_id"

        const val EXTRA_LAUNCH_SOURCE = "extra_launch_source"
        const val EXTRA_LAUNCHED_OFFER_ID = "extra_launched_offer_id"
        const val EXTRA_LAUNCHED_OFFER_PAYLOAD = "extra_launched_offer_payload"

        const val LAUNCH_SOURCE_OFFER_NOTIFICATION = "offer_notification"

        private const val OFFER_NOTIFICATION_DEFAULT_ID = 2001

        private const val LOCATION_TICK_INTERVAL_MS = 15_000L
        private const val INITIAL_RETRY_BACKOFF_MS = 15_000L
        private const val MAX_RETRY_BACKOFF_MS = 60_000L
        private const val MIN_LOCATION_UPDATE_DISTANCE_METERS = 10f
        private const val MIN_LOCATION_SEND_DISTANCE_METERS = 15f
        private const val MAX_ACCEPTABLE_ACCURACY_METERS = 20f

        private const val LOCATION_UPDATE_URL =
            "https://taxi-backend.laithroom.com/api/admin/drivers/location"

        @Volatile
        var isRunning: Boolean = false
    }
}