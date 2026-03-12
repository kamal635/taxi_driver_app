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

class DriverForegroundService : Service() {

    private val serviceHandler = Handler(Looper.getMainLooper())

    private var currentToken: String? = null
    private var currentDriverId: String? = null
    private var isLoopRunning = false

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
        isRunning = false
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    // Start service runtime with incoming auth/session data.
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

    // Stop the service and clear runtime work.
    private fun handleStop() {
        Log.d(TAG, "handleStop")

        stopBackgroundLoop()
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    // Start the periodic background loop.
    private fun startBackgroundLoop() {
        if (isLoopRunning) {
            Log.d(TAG, "Background loop already running")
            return
        }

        isLoopRunning = true
        serviceHandler.post(backgroundTickRunnable)
        Log.d(TAG, "Background loop started")
    }

    // Stop the periodic background loop.
    private fun stopBackgroundLoop() {
        if (!isLoopRunning) return

        isLoopRunning = false
        serviceHandler.removeCallbacks(backgroundTickRunnable)
        Log.d(TAG, "Background loop stopped")
    }

    // Fetch current location once and log it.
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

                Log.d(
                    TAG,
                    "location tick -> driverId=$currentDriverId, lat=${location.latitude}, lon=${location.longitude}"
                )

                // Later:
                // - send location to backend using currentToken
            }
            .addOnFailureListener { error ->
                Log.e(TAG, "Failed to get current location", error)
            }
    }

    // Check whether location permission is available.
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

        @Volatile
        var isRunning: Boolean = false
    }
}