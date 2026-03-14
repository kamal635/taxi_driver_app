package com.yourcompany.taxi_driver.taxi_driver_app

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
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

    // -------------------------------------------------------------------------
    // Flutter engine
    // -------------------------------------------------------------------------

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        )

        serviceMethodChannel = channel
        notifyFlutterIfLaunchedFromOffer(intent)

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
                    Log.d(TAG, "MainActivity -> startService called")

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
                    Log.d(TAG, "MainActivity -> stopService called")

                    if (!DriverForegroundService.isRunning) {
                        Log.d(TAG, "stopService ignored: service is not running")
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

                "emitTestOffer" -> {
                    Log.d(TAG, "MainActivity -> emitTestOffer called")

                    notifyFlutterOfferReceived(
                        payloadJson = """
                            {
                              "id": "test-offer-001",
                              "pickup_address": "Airport Terminal 1",
                              "title": "Test background offer"
                            }
                        """.trimIndent()
                    )

                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    // -------------------------------------------------------------------------
    // Launch intents
    // -------------------------------------------------------------------------

    // Notify Flutter if the app was opened from an offer notification.
    private fun notifyFlutterIfLaunchedFromOffer(intent: Intent?) {
        val launchSource = intent?.getStringExtra(
            DriverForegroundService.EXTRA_LAUNCH_SOURCE
        ) ?: return

        if (launchSource != DriverForegroundService.LAUNCH_SOURCE_OFFER_NOTIFICATION) {
            return
        }

        val offerId = intent.getStringExtra(
            DriverForegroundService.EXTRA_LAUNCHED_OFFER_ID
        )

        notifyFlutterOfferNotificationOpened(offerId)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        notifyFlutterIfLaunchedFromOffer(intent)
    }

    // -------------------------------------------------------------------------
    // Notification permission
    // -------------------------------------------------------------------------

    // Request notification permission on Android 13+.
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

    // -------------------------------------------------------------------------
    // Flutter callbacks
    // -------------------------------------------------------------------------

    companion object {
        private const val TAG = "DriverService"

        private var serviceMethodChannel: MethodChannel? = null
        private val mainHandler = Handler(Looper.getMainLooper())

        // Notify Flutter that the background service stopped.
        fun notifyFlutterServiceStopped(reason: String) {
            mainHandler.post {
                serviceMethodChannel?.invokeMethod(
                    "serviceStopped",
                    mapOf("reason" to reason)
                )
            }
        }

        // Notify Flutter that a new offer payload was received.
        fun notifyFlutterOfferReceived(payloadJson: String) {
            mainHandler.post {
                serviceMethodChannel?.invokeMethod(
                    "offerReceived",
                    mapOf("payloadJson" to payloadJson)
                )
            }
        }

        // Notify Flutter that the app was opened from an offer notification.
        fun notifyFlutterOfferNotificationOpened(offerId: String?) {
            mainHandler.post {
                serviceMethodChannel?.invokeMethod(
                    "offerNotificationOpened",
                    mapOf("offerId" to offerId)
                )
            }
        }
    }
}