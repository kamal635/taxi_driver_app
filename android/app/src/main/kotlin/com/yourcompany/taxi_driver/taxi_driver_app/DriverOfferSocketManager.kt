package com.yourcompany.taxi_driver.taxi_driver_app

import android.util.Log
import io.socket.client.IO
import io.socket.client.Socket
import io.socket.engineio.client.transports.WebSocket
import org.json.JSONObject
import java.net.URI

class DriverOfferSocketManager {

    private var socket: Socket? = null
    private var isRunning = false
    private var currentToken: String? = null
    private var currentDriverId: String? = null
    private var onOfferReceived: ((DriverOfferPayload) -> Unit)? = null

    // Start the offer runtime.
    fun start(
        token: String,
        driverId: String,
        onOfferReceived: (DriverOfferPayload) -> Unit
    ) {
        if (isRunning) {
            Log.d(TAG, "Offer runtime already running")
            return
        }

        this.currentToken = token
        this.currentDriverId = driverId
        this.onOfferReceived = onOfferReceived
        isRunning = true

        Log.d(TAG, "Offer runtime starting -> driverId=$driverId")

        val options = IO.Options.builder()
            .setForceNew(true)
            .setReconnection(true)
            .setAuth(mapOf("token" to token))
            .setTransports(arrayOf(WebSocket.NAME))
            .build()

        val newSocket = IO.socket(URI.create(BASE_URL), options)
        socket = newSocket

        newSocket.on(Socket.EVENT_CONNECT) {
            Log.d(TAG, "Socket connected -> joining driver room: $driverId")
            newSocket.emit("join_driver_room", driverId)
        }

        newSocket.on(Socket.EVENT_CONNECT_ERROR) { args ->
            val error = args.firstOrNull()?.toString() ?: "unknown_connect_error"
            Log.e(TAG, "Socket connect error -> $error")
        }

        newSocket.on(Socket.EVENT_DISCONNECT) { args ->
            val reason = args.firstOrNull()?.toString() ?: "unknown_disconnect"
            Log.d(TAG, "Socket disconnected -> $reason")
        }

        newSocket.on("new_offer") { args ->
            val raw = args.firstOrNull() ?: return@on

            val payloadJson = when (raw) {
                is JSONObject -> raw.toString()
                is String -> raw
                else -> JSONObject.wrap(raw)?.toString()
            } ?: return@on

            Log.d(TAG, "Socket new_offer received")

            onOfferReceived?.invoke(
                DriverOfferPayload(payloadJson = payloadJson)
            )
        }

        newSocket.connect()
    }

    // Stop the offer runtime.
    fun stop() {
        if (!isRunning) return

        isRunning = false
        currentToken = null
        currentDriverId = null
        onOfferReceived = null

        socket?.disconnect()
        socket?.close()
        socket = null

        Log.d(TAG, "Offer runtime stopped")
    }

    companion object {
        private const val TAG = "DriverOfferRuntime"
        private const val BASE_URL = "http://10.0.2.2:3000"
    }
}

data class DriverOfferPayload(
    val payloadJson: String
)