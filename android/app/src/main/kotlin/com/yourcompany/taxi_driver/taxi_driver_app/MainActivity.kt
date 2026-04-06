package com.yourcompany.taxi_driver.taxi_driver_app

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.IntentSender
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.Priority
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val channelName = "driver_background_service"
    private val notificationPermissionRequestCode = 3001

    private var pendingNotificationPermissionResult: MethodChannel.Result? = null
    private var pendingLocationSettingsResult: MethodChannel.Result? = null

    private val locationSettingsLauncher = registerForActivityResult(
        ActivityResultContracts.StartIntentSenderForResult()
    ) { result ->
        val granted = result.resultCode == Activity.RESULT_OK
        pendingLocationSettingsResult?.success(granted)
        pendingLocationSettingsResult = null
    }

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
                "ensureNotificationPermission" -> ensureNotificationPermission(result)
                "areNotificationsEnabled" -> {
                    result.success(NotificationManagerCompat.from(this).areNotificationsEnabled())
                }
                "ensureLocationSettings" -> ensureLocationSettings(result)
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
                "stopOfferAlert" -> {
                    val cancelNotification = call.argument<Boolean>("cancelNotification") ?: true

                    if (!DriverForegroundService.isRunning) {
                        result.success(true)
                        return@setMethodCallHandler
                    }

                    val intent = Intent(this, DriverForegroundService::class.java).apply {
                        action = DriverForegroundService.ACTION_STOP_OFFER_ALERT
                        putExtra(
                            DriverForegroundService.EXTRA_CANCEL_OFFER_NOTIFICATION,
                            cancelNotification
                        )
                    }

                    startService(intent)
                    result.success(true)
                }
                "consumePendingOfferNotificationOpen" -> {
                    result.success(consumePendingOfferNotificationOpen())
                }
                "isServiceRunning" -> result.success(DriverForegroundService.isRunning)
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

        val payloadJson = intent.getStringExtra(
            DriverForegroundService.EXTRA_LAUNCHED_OFFER_PAYLOAD
        )

        pendingOfferNotificationOpen = mapOf(
            "offerId" to offerId,
            "payloadJson" to payloadJson
        )

        notifyFlutterOfferNotificationOpened(
            offerId = offerId,
            payloadJson = payloadJson
        )
    }

    private fun consumePendingOfferNotificationOpen(): Map<String, String?>? {
        val pending = pendingOfferNotificationOpen
        pendingOfferNotificationOpen = null
        return pending
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        notifyFlutterIfLaunchedFromOffer(intent)
    }

    private fun ensureNotificationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(true)
            return
        }

        if (
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            result.success(true)
            return
        }

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

    private fun ensureLocationSettings(result: MethodChannel.Result) {
        if (pendingLocationSettingsResult != null) {
            result.error(
                "location_settings_request_in_progress",
                "Location settings request is already in progress.",
                null
            )
            return
        }

        val locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY,
            15_000L
        )
            .setMinUpdateIntervalMillis(10_000L)
            .setWaitForAccurateLocation(false)
            .build()

        val settingsRequest = LocationSettingsRequest.Builder()
            .addLocationRequest(locationRequest)
            .setAlwaysShow(true)
            .build()

        val client = LocationServices.getSettingsClient(this)
        val task = client.checkLocationSettings(settingsRequest)

        task.addOnSuccessListener {
            result.success(true)
        }

        task.addOnFailureListener { exception ->
            if (exception is ResolvableApiException) {
                try {
                    pendingLocationSettingsResult = result

                    val intentSenderRequest = IntentSenderRequest.Builder(
                        exception.resolution
                    ).build()

                    locationSettingsLauncher.launch(intentSenderRequest)
                } catch (sendEx: IntentSender.SendIntentException) {
                    pendingLocationSettingsResult = null
                    result.error(
                        "location_settings_launch_failed",
                        sendEx.message,
                        null
                    )
                }
            } else {
                result.success(false)
            }
        }
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
        private const val TAG = "DriverService"

        private var serviceMethodChannel: MethodChannel? = null
        private var pendingOfferNotificationOpen: Map<String, String?>? = null
        private val mainHandler = Handler(Looper.getMainLooper())

        fun notifyFlutterServiceStopped(reason: String) {
            mainHandler.post {
                serviceMethodChannel?.invokeMethod(
                    "serviceStopped",
                    mapOf("reason" to reason)
                )
            }
        }

        fun notifyFlutterOfferReceived(payloadJson: String) {
            mainHandler.post {
                serviceMethodChannel?.invokeMethod(
                    "offerReceived",
                    mapOf("payloadJson" to payloadJson)
                )
            }
        }

        fun notifyFlutterOfferNotificationOpened(
            offerId: String?,
            payloadJson: String?
        ) {
            mainHandler.post {
                serviceMethodChannel?.invokeMethod(
                    "offerNotificationOpened",
                    mapOf(
                        "offerId" to offerId,
                        "payloadJson" to payloadJson
                    )
                )
            }
        }
    }
}
