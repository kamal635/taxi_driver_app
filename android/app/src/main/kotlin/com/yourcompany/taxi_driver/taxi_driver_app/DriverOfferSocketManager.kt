package com.yourcompany.taxi_driver.taxi_driver_app

import android.os.Handler
import android.os.Looper
import android.util.Log

class DriverOfferSocketManager {

    private val handler = Handler(Looper.getMainLooper())

    private var isRunning = false
    private var currentToken: String? = null
    private var currentDriverId: String? = null
    private var hasEmittedStartupOffer = false

    private val startupOfferRunnable = Runnable {
        if (!isRunning) return@Runnable

        emitTestOfferOnce()
    }

    // Start the offer runtime.
    fun start(
        token: String,
        driverId: String
    ) {
        if (isRunning) {
            Log.d(TAG, "Offer runtime already running")
            return
        }

        currentToken = token
        currentDriverId = driverId
        hasEmittedStartupOffer = false
        isRunning = true

        Log.d(TAG, "Offer runtime started -> driverId=$driverId")

        // Temporary test event.
        handler.postDelayed(startupOfferRunnable, STARTUP_TEST_DELAY_MS)
    }

    // Stop the offer runtime.
    fun stop() {
        if (!isRunning) return

        isRunning = false
        currentToken = null
        currentDriverId = null
        hasEmittedStartupOffer = false

        handler.removeCallbacks(startupOfferRunnable)

        Log.d(TAG, "Offer runtime stopped")
    }

    // Emit one startup test offer through the native bridge.
    private fun emitTestOfferOnce() {
        if (!isRunning) return
        if (hasEmittedStartupOffer) return

        hasEmittedStartupOffer = true

        Log.d(TAG, "Offer runtime -> emitting startup test offer")

        MainActivity.notifyFlutterOfferReceived(
            offerId = "manager-test-offer-001",
            title = "Manager test background offer",
            pickupAddress = "City Center Pickup"
        )
    }

    companion object {
        private const val TAG = "DriverOfferRuntime"
        private const val STARTUP_TEST_DELAY_MS = 3000L
    }
}