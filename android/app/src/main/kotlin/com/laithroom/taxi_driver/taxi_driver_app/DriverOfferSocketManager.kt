package com.laithroom.taxi.driver

import android.util.Log
import io.socket.client.IO
import io.socket.client.Manager
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
    private var onForceLogout: ((DriverForceLogoutPayload) -> Unit)? = null

    fun start(
        token: String,
        driverId: String,
        onOfferReceived: (DriverOfferPayload) -> Unit,
        onForceLogout: (DriverForceLogoutPayload) -> Unit,
    ) {
        if (isRunning) {
            Log.d(TAG, "Offer runtime already running")
            return
        }

        currentToken = token
        currentDriverId = driverId
        this.onOfferReceived = onOfferReceived
        this.onForceLogout = onForceLogout
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

        attachSocketListeners(newSocket, driverId)
        newSocket.connect()
    }

    fun stop() {
        if (!isRunning) return

        isRunning = false
        currentToken = null
        currentDriverId = null
        onOfferReceived = null
        onForceLogout = null

        socket?.disconnect()
        socket?.off()
        socket?.close()
        socket = null

        Log.d(TAG, "Offer runtime stopped")
    }

    private fun attachSocketListeners(
        socket: Socket,
        driverId: String,
    ) {
        socket.on(Socket.EVENT_CONNECT) {
            Log.d(TAG, "Socket connected -> id=${socket.id()} -> joining driver room: $driverId")
            socket.emit("join_driver_room", driverId)
        }

        socket.on(Socket.EVENT_CONNECT_ERROR) { args ->
            val error = args.firstOrNull()?.toString() ?: "unknown_connect_error"
            Log.e(TAG, "Socket connect error -> $error")
        }

        socket.on(Socket.EVENT_DISCONNECT) { args ->
            val reason = args.firstOrNull()?.toString() ?: "unknown_disconnect"
            Log.w(TAG, "Socket disconnected -> $reason")
        }

        socket.io().on(Manager.EVENT_RECONNECT_ATTEMPT) { args ->
            val attempt = args.firstOrNull()?.toString() ?: "unknown"
            Log.w(TAG, "Socket reconnect attempt -> $attempt")
        }

        socket.io().on(Manager.EVENT_RECONNECT) { args ->
            val attempt = args.firstOrNull()?.toString() ?: "unknown"
            Log.d(TAG, "Socket reconnected successfully -> attempt=$attempt")
        }

        socket.io().on(Manager.EVENT_RECONNECT_ERROR) { args ->
            val error = args.firstOrNull()?.toString() ?: "unknown_reconnect_error"
            Log.e(TAG, "Socket reconnect error -> $error")
        }

        socket.io().on(Manager.EVENT_RECONNECT_FAILED) {
            Log.e(TAG, "Socket reconnect failed permanently")
        }

        socket.on(EVENT_NEW_OFFER) { args ->
            val raw = args.firstOrNull() ?: return@on
            val payloadJson = rawToJsonString(raw) ?: return@on

            Log.d(TAG, "Socket new_offer received")
            onOfferReceived?.invoke(
                DriverOfferPayload(payloadJson = payloadJson)
            )
        }

        socket.on(EVENT_FORCE_LOGOUT) { args ->
            val raw = args.firstOrNull()
            val payloadJson = rawToJsonString(raw) ?: "{}"
            val reason = extractForceLogoutReason(payloadJson)

            Log.w(TAG, "Socket force_logout received -> reason=$reason")

            onForceLogout?.invoke(
                DriverForceLogoutPayload(
                    reason = reason,
                    payloadJson = payloadJson,
                )
            )
        }
    }

    private fun rawToJsonString(raw: Any?): String? {
        return when (raw) {
            null -> null
            is JSONObject -> raw.toString()
            is String -> raw
            else -> JSONObject.wrap(raw)?.toString()
        }
    }

    private fun extractForceLogoutReason(payloadJson: String): String {
        return try {
            JSONObject(payloadJson)
                .optString("reason")
                .ifBlank { DEFAULT_FORCE_LOGOUT_REASON }
        } catch (_: Exception) {
            if (payloadJson.isBlank()) {
                DEFAULT_FORCE_LOGOUT_REASON
            } else {
                payloadJson
            }
        }
    }

    companion object {
        private const val TAG = "DriverOfferRuntime"
        private const val BASE_URL = "https://taxi-backend.laithroom.com"

        private const val EVENT_NEW_OFFER = "new_offer"
        private const val EVENT_FORCE_LOGOUT = "force_logout"
        private const val DEFAULT_FORCE_LOGOUT_REASON = "force_logout"
    }
}

data class DriverOfferPayload(
    val payloadJson: String,
)

data class DriverForceLogoutPayload(
    val reason: String,
    val payloadJson: String,
)