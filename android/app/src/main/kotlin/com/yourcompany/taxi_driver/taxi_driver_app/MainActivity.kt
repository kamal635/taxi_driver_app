package com.yourcompany.taxi_driver.taxi_driver_app

import android.os.Handler
import android.os.Looper
import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "driver_background_service"
    private val notificationPermissionRequestCode = 3001

    private var pendingNotificationPermissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(
                    flutterEngine.dartExecutor.binaryMessenger,
                    channelName
                )

            serviceMethodChannel = channel

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "ensureNotificationPermission" -> {
                    ensureNotificationPermission(result)
                }

                "areNotificationsEnabled" -> {
                    result.success(
                        NotificationManagerCompat.from(this).areNotificationsEnabled()
                    )
                }

                "startService" -> {
                    Log.d("DriverService", "MainActivity -> startService called")

                    val token = call.argument<String>("token")
                    val driverId = call.argument<String>("driverId")

                    if (token.isNullOrBlank() || driverId.isNullOrBlank()) {
                        result.error(
                            "invalid_args",
                            "Missing token or driverId for service start.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    val intent = Intent(this, DriverForegroundService::class.java).apply {
                        action = DriverForegroundService.ACTION_START
                        putExtra(DriverForegroundService.EXTRA_TOKEN, token)
                        putExtra(DriverForegroundService.EXTRA_DRIVER_ID, driverId)
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }

                    result.success(true)
                }

                "stopService" -> {
                    Log.d("DriverService", "MainActivity -> stopService called")

                    if (!DriverForegroundService.isRunning) {
                        Log.d("DriverService", "stopService ignored: service is not running")
                        result.success(true)
                        return@setMethodCallHandler
                    }

                    val intent = Intent(this, DriverForegroundService::class.java).apply {
                        action = DriverForegroundService.ACTION_STOP
                    }

                    startService(intent)
                    result.success(true)
                    }

                "isServiceRunning" -> {
                    result.success(DriverForegroundService.isRunning)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun ensureNotificationPermission(result: MethodChannel.Result) {
        // Android 12 and below: no runtime notification permission.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(true)
            return
        }

        // Already granted.
        if (
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            result.success(true)
            return
        }

        // Avoid duplicate requests.
        if (pendingNotificationPermissionResult != null) {
            result.error(
                "permission_request_in_progress",
                "Notification permission request is already in progress.",
                null
            )
            return
        }

        pendingNotificationPermissionResult = result

        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            notificationPermissionRequestCode
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        if (requestCode == notificationPermissionRequestCode) {
            val granted = grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED

            pendingNotificationPermissionResult?.success(granted)
            pendingNotificationPermissionResult = null
            return
        }

        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    companion object {
    private var serviceMethodChannel: MethodChannel? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    fun notifyFlutterServiceStopped(reason: String) {
        mainHandler.post {
            serviceMethodChannel?.invokeMethod(
                "serviceStopped",
                mapOf("reason" to reason)
            )
        }
    }
}
}