package com.yourcompany.taxi_driver.taxi_driver_app

import android.os.SystemClock
import java.util.concurrent.atomic.AtomicInteger
import java.util.concurrent.atomic.AtomicLong
import kotlin.math.min
import java.util.concurrent.atomic.AtomicBoolean
import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import org.json.JSONObject
import java.io.BufferedWriter
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class DriverForegroundService : Service() {

    private val serviceHandler = Handler(Looper.getMainLooper())
    

    private var currentToken: String? = null
    private var currentDriverId: String? = null
    private var isLoopRunning = false

    private val isSendingLocation = AtomicBoolean(false)
    private val consecutiveSendFailures = AtomicInteger(0)
    private val nextAllowedSendAtMs = AtomicLong(0L)
    
    private val networkExecutor: ExecutorService by lazy {
        Executors.newSingleThreadExecutor()
    }

    private val fusedLocationClient by lazy {
        LocationServices.getFusedLocationProviderClient(this)
    }

    private val backgroundTickRunnable = object : Runnable {
        override fun run() {
            if (!isLoopRunning) return

            requestCurrentLocation()

            serviceHandler.postDelayed(this, LOCATION_TICK_INTERVAL_MS)
        }
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service onCreate")
        isRunning = true
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service onStartCommand")

        val action = intent?.action

        return when (action) {
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
                Log.w(TAG, "Unknown service action: $action")
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
        isSendingLocation.set(false)
        consecutiveSendFailures.set(0)
        nextAllowedSendAtMs.set(0L)
        networkExecutor.shutdownNow()
        isRunning = false
        super.onDestroy()
        
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun handleStart(intent: Intent) {
        currentToken = intent.getStringExtra(EXTRA_TOKEN)
        currentDriverId = intent.getStringExtra(EXTRA_DRIVER_ID)

        Log.d(TAG, "handleStart -> token exists: ${!currentToken.isNullOrBlank()}")
        Log.d(TAG, "handleStart -> driverId: $currentDriverId")

        val notification = buildNotification()

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
    }

    private fun handleStop() {
        Log.d(TAG, "handleStop")

        stopBackgroundLoop()
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun startBackgroundLoop() {
        if (isLoopRunning) {
            Log.d(TAG, "Background loop already running")
            return
        }

        isLoopRunning = true
        serviceHandler.post(backgroundTickRunnable)
        Log.d(TAG, "Background loop started")
    }

    private fun stopBackgroundLoop() {
        if (!isLoopRunning) return

        isLoopRunning = false
        serviceHandler.removeCallbacks(backgroundTickRunnable)
        Log.d(TAG, "Background loop stopped")
    }

    private fun requestCurrentLocation() {
        if (!hasLocationPermission()) {
            Log.w(TAG, "Location permission is missing")
            return
        }

        fusedLocationClient
            .getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null)
                        .addOnSuccessListener { location ->
                    if (location == null) {
                        Log.w(TAG, "Current location is null")
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

                scheduleNextRetry()

                Log.e(
                    TAG,
                    "Location send failed -> code=$responseCode, body=$errorBody"
                )
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

    private fun buildNotification(): Notification {
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

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = getSystemService(NotificationManager::class.java)

        val channel = NotificationChannel(
            CHANNEL_ID,
            "Driver background service",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = "Keeps driver mode active in the background"
            setShowBadge(false)
            enableVibration(false)
        }

        manager.createNotificationChannel(channel)
    }

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
        const val NOTIFICATION_ID = 1001

        const val ACTION_START = "driver_background_service.action.START"
        const val ACTION_STOP = "driver_background_service.action.STOP"

        const val EXTRA_TOKEN = "extra_token"
        const val EXTRA_DRIVER_ID = "extra_driver_id"

        private const val LOCATION_TICK_INTERVAL_MS = 15_000L

        
        private const val LOCATION_UPDATE_URL =
            "http://10.0.2.2:3000/api/admin/drivers/location"

        private const val INITIAL_RETRY_BACKOFF_MS = 15_000L
        private const val MAX_RETRY_BACKOFF_MS = 60_000L

        @Volatile
        var isRunning: Boolean = false
    }
}