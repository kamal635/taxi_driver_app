package com.yourcompany.taxi_driver.taxi_driver_app

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.location.LocationManager
import android.media.AudioAttributes
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
    private var isLoopRunning = false

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

    // Periodic location loop.
    private val backgroundTickRunnable = object : Runnable {
        override fun run() {
             Log.d(TAG, "BACKGROUND_TICK_FIRED -> isLoopRunning=$isLoopRunning")
            if (!isLoopRunning) return

            requestCurrentLocation()
            serviceHandler.postDelayed(this, LOCATION_TICK_INTERVAL_MS)
        }
    }

    // -------------------------------------------------------------------------
    // Lifecycle
    // -------------------------------------------------------------------------

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
        Log.d(TAG, "Service onStartCommand")

        return when (intent?.action) {
            ACTION_START -> {
                if (intent == null) {
                    Log.w(TAG, "Start action received with null intent")
                    START_NOT_STICKY
                } else {
                    handleStart(intent)
                    START_STICKY
                }
            }

            ACTION_STOP -> {
                handleStop()
                START_NOT_STICKY
            }

            else -> {
                Log.w(TAG, "Unknown service action: ${intent?.action}")
                START_NOT_STICKY
            }
        }
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d(TAG, "Service onTaskRemoved")
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        Log.d(TAG, "Service onDestroy")

        stopBackgroundLoop()
        offerSocketManager.stop()

        isSendingLocation.set(false)
        isStoppingService.set(false)
        consecutiveSendFailures.set(0)
        nextAllowedSendAtMs.set(0L)

        networkExecutor.shutdownNow()
        isRunning = false

        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    // -------------------------------------------------------------------------
    // Start / Stop
    // -------------------------------------------------------------------------

    // Start the foreground service runtime.
    private fun handleStart(intent: Intent) {
        currentToken = intent.getStringExtra(EXTRA_TOKEN)
        currentDriverId = intent.getStringExtra(EXTRA_DRIVER_ID)

        isSendingLocation.set(false)
        isStoppingService.set(false)
        consecutiveSendFailures.set(0)
        nextAllowedSendAtMs.set(0L)

        Log.d(TAG, "handleStart -> token exists: ${!currentToken.isNullOrBlank()}")
        Log.d(TAG, "handleStart -> driverId: $currentDriverId")

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

        startBackgroundLoop()

        if (!currentToken.isNullOrBlank() && !currentDriverId.isNullOrBlank()) {
            offerSocketManager.start(
                token = currentToken!!,
                driverId = currentDriverId!!,
                onOfferReceived = ::handleOfferReceived
            )
        }
    }

    // Stop the service safely.
    private fun handleStop() {
        if (!isStoppingService.compareAndSet(false, true)) {
            Log.d(TAG, "handleStop ignored: service is already stopping")
            return
        }

        Log.d(TAG, "handleStop")

        stopBackgroundLoop()
        offerSocketManager.stop()

        currentToken = null
        currentDriverId = null
        isSendingLocation.set(false)
        consecutiveSendFailures.set(0)
        nextAllowedSendAtMs.set(0L)

        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    // Stop the service when auth becomes invalid.
    private fun stopServiceDueToUnauthorized() {
        Log.e(TAG, "Unauthorized token detected. Stopping driver background service.")

        MainActivity.notifyFlutterServiceStopped("unauthorized")

        serviceHandler.post {
            handleStop()
        }
    }

    // Stop the service when location requirements are no longer valid.
    private fun stopServiceDueToLocationIssue(reason: String) {
        Log.w(TAG, "Stopping driver background service due to location issue: $reason")

        MainActivity.notifyFlutterServiceStopped(reason)

        serviceHandler.post {
            handleStop()
        }
    }

    // -------------------------------------------------------------------------
    // Background loop
    // -------------------------------------------------------------------------

    // Start the periodic location loop.
    private fun startBackgroundLoop() {
        if (isLoopRunning) {
            Log.d(TAG, "Background loop already running")
            return
        }

        isLoopRunning = true
        serviceHandler.post(backgroundTickRunnable)
        Log.d(TAG, "Background loop started")
    }

    // Stop the periodic location loop.
    private fun stopBackgroundLoop() {
        if (!isLoopRunning) return

        isLoopRunning = false
        serviceHandler.removeCallbacks(backgroundTickRunnable)
        Log.d(TAG, "Background loop stopped")
    }

    // -------------------------------------------------------------------------
    // Offer handling
    // -------------------------------------------------------------------------

    // Handle an offer received from the native socket runtime.
    private fun handleOfferReceived(payload: DriverOfferPayload) {
        Log.d(TAG, "Offer received in service")

        showOfferNotification(payload)

        MainActivity.notifyFlutterOfferReceived(
            payloadJson = payload.payloadJson
        )
    }

    // Show a local notification for a new offer.
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
            offerId = offerIdForLaunch
        )

        notificationManager.notify(notificationId, notification)

        Log.d(TAG, "Offer notification shown -> id=$notificationId")
    }

    // -------------------------------------------------------------------------
    // Location sending
    // -------------------------------------------------------------------------

    // Request the current device location once.
    private fun requestCurrentLocation() {
            Log.d(TAG, "REQUEST_CURRENT_LOCATION_START")
        if (!hasLocationPermission()) {
            Log.w(TAG, "Location permission is missing")
            stopServiceDueToLocationIssue("location_permission_missing")
            return
        }

        if (!isLocationServiceEnabled()) {
            Log.w(TAG, "Location service is disabled")
            stopServiceDueToLocationIssue("location_service_disabled")
            return
        }

        fusedLocationClient
            .getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null)
            .addOnSuccessListener { location ->
                if (location == null) {
                    Log.w(TAG, "Current location is null")

                    if (!hasLocationPermission()) {
                        stopServiceDueToLocationIssue("location_permission_missing")
                        return@addOnSuccessListener
                    }

                    if (!isLocationServiceEnabled()) {
                        stopServiceDueToLocationIssue("location_service_disabled")
                        return@addOnSuccessListener
                    }

                    return@addOnSuccessListener
                }

                val token = currentToken
                val driverId = currentDriverId

                Log.d(
                    TAG,
                    "location tick -> driverId=$driverId, lat=${location.latitude}, lon=${location.longitude}"
                )

                if (token.isNullOrBlank() || driverId.isNullOrBlank()) {
                    Log.w(TAG, "Skipping location send: token or driverId is missing")
                    return@addOnSuccessListener
                }

                val now = SystemClock.elapsedRealtime()
                val nextAllowedAt = nextAllowedSendAtMs.get()

                if (now < nextAllowedAt) {
                    val remainingMs = nextAllowedAt - now
                    Log.d(
                        TAG,
                        "Skipping location send: backoff active, remainingMs=$remainingMs"
                    )
                    return@addOnSuccessListener
                }

                if (!isSendingLocation.compareAndSet(false, true)) {
                    Log.d(TAG, "Skipping location send: previous request is still running")
                    return@addOnSuccessListener
                }

                sendLocationToBackend(
                    token = token,
                    driverId = driverId,
                    latitude = location.latitude,
                    longitude = location.longitude
                )
            }
            .addOnFailureListener { error ->
                Log.e(TAG, "Failed to get current location", error)

                if (!hasLocationPermission()) {
                    stopServiceDueToLocationIssue("location_permission_missing")
                    return@addOnFailureListener
                }

                if (!isLocationServiceEnabled()) {
                    stopServiceDueToLocationIssue("location_service_disabled")
                    return@addOnFailureListener
                }
            }
    }

    // Send the current location to backend.
    private fun sendLocationToBackend(
        token: String,
        driverId: String,
        latitude: Double,
        longitude: Double
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
                    put("lat", latitude)
                    put("lon", longitude)
                }

                BufferedWriter(OutputStreamWriter(connection.outputStream)).use { writer ->
                    writer.write(body.toString())
                    writer.flush()
                }

                val responseCode = connection.responseCode

                if (responseCode in 200..299) {
                    consecutiveSendFailures.set(0)
                    nextAllowedSendAtMs.set(0L)

                    Log.d(
                        TAG,
                        "Location sent successfully -> code=$responseCode, driverId=$driverId, lat=$latitude, lon=$longitude"
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

    // Schedule the next retry window after a failed send.
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

    // Calculate exponential-like retry backoff.
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

    // -------------------------------------------------------------------------
    // Permissions
    // -------------------------------------------------------------------------

    // Check whether location permission is granted.
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

    // Check whether the device location service is enabled.
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

    // -------------------------------------------------------------------------
    // Notifications
    // -------------------------------------------------------------------------

    // Build the persistent foreground service notification.
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

    // Build the notification shown for a new trip offer.
    private fun buildOfferNotification(
        title: String,
        body: String,
        offerId: String?
    ): Notification {
        val launchIntent = packageManager
            .getLaunchIntentForPackage(packageName)
            ?.apply {
                putExtra(EXTRA_LAUNCH_SOURCE, LAUNCH_SOURCE_OFFER_NOTIFICATION)

                if (!offerId.isNullOrBlank()) {
                    putExtra(EXTRA_LAUNCHED_OFFER_ID, offerId)
                }
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

    // Create notification channels for service and offers.
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

        val offersChannel = NotificationChannel(
            OFFERS_CHANNEL_ID,
            "Driver offers",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Shows incoming trip offers"
            setShowBadge(true)
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 300, 200, 300)

            setSound(
                Settings.System.DEFAULT_NOTIFICATION_URI,
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .build()
            )
        }

        manager.createNotificationChannel(serviceChannel)
        manager.createNotificationChannel(offersChannel)
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    // Return immutable flag only where supported.
    private fun immutableFlag(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE
        } else {
            0
        }
    }

    companion object {
        private const val TAG = "DriverService"

        const val CHANNEL_ID = "driver_background_service_v2"
        const val OFFERS_CHANNEL_ID = "driver_offers_channel_v3"

        const val NOTIFICATION_ID = 1001

        const val ACTION_START = "driver_background_service.action.START"
        const val ACTION_STOP = "driver_background_service.action.STOP"

        const val EXTRA_TOKEN = "extra_token"
        const val EXTRA_DRIVER_ID = "extra_driver_id"

        const val EXTRA_LAUNCH_SOURCE = "extra_launch_source"
        const val EXTRA_LAUNCHED_OFFER_ID = "extra_launched_offer_id"

        const val LAUNCH_SOURCE_OFFER_NOTIFICATION = "offer_notification"

        private const val OFFER_NOTIFICATION_DEFAULT_ID = 2001

        private const val LOCATION_TICK_INTERVAL_MS = 15_000L
        private const val INITIAL_RETRY_BACKOFF_MS = 15_000L
        private const val MAX_RETRY_BACKOFF_MS = 60_000L

        
            private const val LOCATION_UPDATE_URL =
    "https://taxi-backend.laithroom.com/api/admin/drivers/location"

        @Volatile
        var isRunning: Boolean = false
    }
}