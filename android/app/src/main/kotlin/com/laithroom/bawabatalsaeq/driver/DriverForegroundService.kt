package com.bawabatalsaeq.driver

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
import android.graphics.Color
import android.location.Location as AndroidLocation
import android.location.LocationManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.SystemClock
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.LocationAvailability
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.CancellationTokenSource
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
    private var currentLocationCts: CancellationTokenSource? = null

    private val isStoppingService = AtomicBoolean(false)
    private val isSendingLocation = AtomicBoolean(false)
    private val consecutiveSendFailures = AtomicInteger(0)
    private val nextAllowedSendAtMs = AtomicLong(0L)

    private val offerSocketManager = DriverOfferSocketManager()
    private val offerAlertManager by lazy { OfferAlertManager(this) }

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
        Log.d(TAG, "Service onStartCommand -> action=")

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

            ACTION_STOP_OFFER_ALERT -> {
                handleStopOfferAlert(intent)
                START_STICKY
            }

            ACTION_DISMISS_OFFER_NOTIFICATION -> {
                handleDismissOfferNotification()
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

        if (!isStoppingService.compareAndSet(false, true)) {
            Log.d(TAG, "onTaskRemoved ignored: service is already stopping")
            super.onTaskRemoved(rootIntent)
            return
        }

        restoreRuntimeStateIfNeeded()
        val token = currentToken

        // نوقف كل ما يخص الرن تايم المحلي لكن نحافظ مؤقتًا على التوكن
        // حتى نستطيع إرسال offline إلى الباك قبل تنظيف الـ prefs.
        stopActiveRuntimePreservingAuth()

        if (token.isNullOrBlank()) {
            Log.w(TAG, "Task removed -> token missing, stopping locally only")
        } else {
            val offlineSent = sendDriverStatusOfflineBlocking(token)

            if (offlineSent) {
                Log.d(TAG, "Task removed -> offline status sent successfully")
            } else {
                Log.e(TAG, "Task removed -> offline status was not sent successfully")
            }
        }

        MainActivity.notifyFlutterServiceStopped("task_removed")
        finishLocalStopAfterTaskRemoval()

        super.onTaskRemoved(rootIntent)
    }

    private fun sendDriverStatusOfflineBlocking(token: String): Boolean {
        val result = AtomicBoolean(false)

        val worker = Thread {
            result.set(sendDriverStatusOfflineToBackend(token))
        }.apply {
            name = "driver-task-removed-offline"
        }

        worker.start()

        return try {
            worker.join(TASK_REMOVED_OFFLINE_WAIT_MS)

            if (worker.isAlive) {
                Log.e(TAG, "Task removed -> offline request timed out")
                worker.interrupt()
                false
            } else {
                result.get()
            }
        } catch (error: InterruptedException) {
            Log.e(TAG, "Task removed -> join interrupted", error)
            Thread.currentThread().interrupt()
            false
        }
    }

    private fun sendDriverStatusOfflineToBackend(token: String): Boolean {
        var connection: HttpURLConnection? = null

        return try {
            val url = URL(DRIVER_STATUS_UPDATE_URL)
            connection = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "PUT"
                connectTimeout = 5_000
                readTimeout = 5_000
                doInput = true
                doOutput = true
                useCaches = false
                instanceFollowRedirects = false
                setRequestProperty("Content-Type", "application/json; charset=UTF-8")
                setRequestProperty("Accept", "application/json")
                setRequestProperty("Authorization", "Bearer $token")
                setRequestProperty("Connection", "close")
            }

            val body = JSONObject().apply {
                put("status", "OFFLINE")
            }

            BufferedWriter(OutputStreamWriter(connection.outputStream, "UTF-8")).use { writer ->
                writer.write(body.toString())
                writer.flush()
            }

            val responseCode = connection.responseCode

            if (responseCode in 200..299) {
                Log.d(TAG, "Driver status set to offline after task removal -> code=$responseCode")
                true
            } else {
                val errorBody = try {
                    connection.errorStream?.bufferedReader()?.use { it.readText() }
                } catch (_: Exception) {
                    null
                }

                Log.e(
                    TAG,
                    "Failed to set driver offline after task removal -> code=$responseCode, body=$errorBody"
                )
                false
            }
        } catch (error: Exception) {
            Log.e(TAG, "Failed to send offline status after task removal", error)
            false
        } finally {
            connection?.disconnect()
        }
    }

    override fun onDestroy() {
        Log.d(TAG, "Service onDestroy")

        currentLocationCts?.cancel()
        currentLocationCts = null

        stopLocationUpdates()
        offerSocketManager.stop()
        offerAlertManager.stopAlerting(cancelNotification = true)

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

    // -------------------------------------------------------------------------
    // Start / Stop
    // -------------------------------------------------------------------------

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

        val foregroundType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
        } else {
            0
        }

        ServiceCompat.startForeground(
            this,
            NOTIFICATION_ID,
            buildServiceNotification(),
            foregroundType
        )

        Log.d(TAG, "Service moved to foreground")

        requestCurrentLocationOnce()
        startLocationUpdates()

        offerSocketManager.stop()
        offerSocketManager.start(
            token = currentToken!!,
            driverId = currentDriverId!!,
            onOfferReceived = ::handleOfferReceived,
            onForceLogout = ::handleForceLogout,
        )
    }

    private fun handleStop() {
        if (!isStoppingService.compareAndSet(false, true)) {
            Log.d(TAG, "handleStop ignored: service is already stopping")
            return
        }

        Log.d(TAG, "handleStop")
        performFullLocalStop()
    }

    private fun performFullLocalStop() {
        stopActiveRuntimePreservingAuth()

        currentToken = null
        currentDriverId = null

        clearRuntimeState()

        ServiceCompat.stopForeground(
        this,
        ServiceCompat.STOP_FOREGROUND_REMOVE
    )
        stopSelf()
    }

    private fun finishLocalStopAfterTaskRemoval() {
        currentToken = null
        currentDriverId = null

        clearRuntimeState()

        ServiceCompat.stopForeground(
        this,
        ServiceCompat.STOP_FOREGROUND_REMOVE
    )
        stopSelf()
    }

    private fun stopActiveRuntimePreservingAuth() {
        currentLocationCts?.cancel()
        currentLocationCts = null

        stopLocationUpdates()
        offerSocketManager.stop()
        offerAlertManager.stopAlerting(cancelNotification = true)

        clearLastSentLocation()

        isSendingLocation.set(false)
        consecutiveSendFailures.set(0)
        nextAllowedSendAtMs.set(0L)
    }

    private fun handleStopOfferAlert(intent: Intent?) {
        val cancelNotification = intent?.getBooleanExtra(
            EXTRA_CANCEL_OFFER_NOTIFICATION,
            true
        ) ?: true

        offerAlertManager.stopAlerting(cancelNotification = cancelNotification)
    }

    private fun handleDismissOfferNotification() {
        offerAlertManager.stopAlerting(cancelNotification = false)
    }

    private fun stopServiceDueToUnauthorized() {
           Log.e(TAG, "Unauthorized token detected. Forcing app logout.")

            handleForceLogout(
            DriverForceLogoutPayload(
               reason = "unauthorized",
              payloadJson = """{"reason":"unauthorized"}""",
          )
       )
    }

    private fun stopServiceDueToLocationIssue(reason: String) {
        Log.w(TAG, "Stopping service due to location issue: $reason")
        MainActivity.notifyFlutterServiceStopped(reason)

        serviceHandler.post {
            handleStop()
        }
    }

    // -------------------------------------------------------------------------
    // Location
    // -------------------------------------------------------------------------

    private fun requestCurrentLocationOnce() {
        if (!hasLocationPermission()) {
            Log.w(TAG, "Cannot get current location: permission missing")
            stopServiceDueToLocationIssue("location_permission_missing")
            return
        }

        if (!isLocationServiceEnabled()) {
            Log.w(TAG, "Cannot get current location: location service disabled")
            stopServiceDueToLocationIssue("location_service_disabled")
            return
        }

        val token = currentToken
        val driverId = currentDriverId

        if (token.isNullOrBlank() || driverId.isNullOrBlank()) {
            Log.w(TAG, "Skipping current location request: token or driverId is missing")
            return
        }

        currentLocationCts?.cancel()
        currentLocationCts = CancellationTokenSource()

        try {
            fusedLocationClient
                .getCurrentLocation(
                    Priority.PRIORITY_HIGH_ACCURACY,
                    currentLocationCts!!.token
                )
                .addOnSuccessListener { location ->
                    currentLocationCts = null

                    if (location == null) {
                        Log.w(TAG, "Current location returned null")
                        return@addOnSuccessListener
                    }

                    Log.d(
                        TAG,
                        "Current location acquired -> lat=${location.latitude}, lon=${location.longitude}"
                    )

                    trySendLocationToBackend(
                        token = token,
                        driverId = driverId,
                        location = location
                    )
                }
                .addOnFailureListener { error ->
                    currentLocationCts = null
                    Log.e(TAG, "Failed to get current location", error)
                }
        } catch (error: SecurityException) {
            currentLocationCts = null
            Log.e(TAG, "SecurityException while getting current location", error)
            stopServiceDueToLocationIssue("location_permission_missing")
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

        trySendLocationToBackend(
            token = token,
            driverId = driverId,
            location = location
        )
    }

    private fun trySendLocationToBackend(
        token: String,
        driverId: String,
        location: AndroidLocation
    ) {
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

    private fun shouldSendLocationToBackend(location: AndroidLocation): Boolean {
        synchronized(lastSentLocationLock) {
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

    // -------------------------------------------------------------------------
    // Offers / Notifications
    // -------------------------------------------------------------------------
    private fun buildServiceNotification(): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag()
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("وضع السائق يعمل")
            .setContentText("التطبيق يرسل الموقع ويستقبل العروض في الخلفية")
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()
    }
    

    private fun handleForceLogout(payload: DriverForceLogoutPayload) {
    Log.w(TAG, "Force logout received in service -> reason=${payload.reason}")

    MainActivity.notifyFlutterForceLogout(
        reason = payload.reason,
        payloadJson = payload.payloadJson,
    )

    serviceHandler.post {
        if (!isStoppingService.compareAndSet(false, true)) {
            Log.d(TAG, "handleForceLogout ignored: service is already stopping")
            return@post
        }

        performFullLocalStop()
      }
    }


    private fun handleOfferReceived(payload: DriverOfferPayload) {
        Log.d(TAG, "Offer received in service")

        offerAlertManager.showOfferAlert(payload.payloadJson)

        MainActivity.notifyFlutterOfferReceived(
            payloadJson = payload.payloadJson
        )
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = getSystemService(NotificationManager::class.java)

        val serviceChannel = NotificationChannel(
            CHANNEL_ID,
            "تشغيل السائق في الخلفية",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "يبقي وضع السائق نشطًا أثناء العمل"
            setShowBadge(false)
            enableVibration(false)
            setSound(null, null)
        }

        val offersChannel = NotificationChannel(
            OFFERS_CHANNEL_ID,
            "عروض الرحلات",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "تنبيه عند وصول عرض رحلة جديد"
            setShowBadge(true)
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 250, 150, 250)
            enableLights(true)
            lightColor = Color.parseColor("#0EA5E9")
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            setSound(null, null)
        }

        manager.createNotificationChannel(serviceChannel)
        manager.createNotificationChannel(offersChannel)
    }

    // -------------------------------------------------------------------------
    // Pending intents / Runtime state
    // -------------------------------------------------------------------------

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

        const val CHANNEL_ID = "driver_background_service_v4"
        const val OFFERS_CHANNEL_ID = "driver_offers_channel_v15"

        const val NOTIFICATION_ID = 1001

        const val ACTION_START = "driver_background_service.action.START"
        const val ACTION_STOP = "driver_background_service.action.STOP"
        const val ACTION_LOCATION_UPDATE =
            "driver_background_service.action.LOCATION_UPDATE"
        const val ACTION_STOP_OFFER_ALERT =
            "driver_background_service.action.STOP_OFFER_ALERT"
        const val ACTION_DISMISS_OFFER_NOTIFICATION =
            "driver_background_service.action.DISMISS_OFFER_NOTIFICATION"

        private const val LOCATION_PENDING_INTENT_REQUEST_CODE = 1002

        const val EXTRA_TOKEN = "extra_token"
        const val EXTRA_DRIVER_ID = "extra_driver_id"

        const val EXTRA_LAUNCH_SOURCE = "extra_launch_source"
        const val EXTRA_LAUNCHED_OFFER_ID = "extra_launched_offer_id"
        const val EXTRA_LAUNCHED_OFFER_PAYLOAD = "extra_launched_offer_payload"

        const val LAUNCH_SOURCE_OFFER_NOTIFICATION = "offer_notification"
        const val EXTRA_CANCEL_OFFER_NOTIFICATION = "extra_cancel_offer_notification"

        const val OFFER_NOTIFICATION_ID = 1101

        private const val DRIVER_STATUS_UPDATE_URL =
            "https://taxi-backend.laithroom.com/api/admin/drivers/status"
        private const val LOCATION_TICK_INTERVAL_MS = 15_000L
        private const val INITIAL_RETRY_BACKOFF_MS = 15_000L
        private const val MAX_RETRY_BACKOFF_MS = 60_000L
        private const val MIN_LOCATION_UPDATE_DISTANCE_METERS = 10f
        private const val MIN_LOCATION_SEND_DISTANCE_METERS = 15f
        private const val TASK_REMOVED_OFFLINE_WAIT_MS = 8_000L

        private const val LOCATION_UPDATE_URL =
            "https://taxi-backend.laithroom.com/api/admin/drivers/location"

        @Volatile
        var isRunning: Boolean = false
    }
}
