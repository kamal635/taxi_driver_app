package com.yourcompany.taxi_driver.taxi_driver_app

import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import org.json.JSONException
import org.json.JSONObject

class OfferAlertManager(
    private val context: Context
) {

    private val mainHandler = Handler(Looper.getMainLooper())

    private var mediaPlayer: MediaPlayer? = null
    private var activeOfferKey: String? = null

    private val stopSoundRunnable = Runnable {
        stopSoundOnly()
    }

    fun showOfferAlert(payloadJson: String) {
        val summary = parseOfferSummary(payloadJson)
        val offerKey = summary.offerId ?: payloadJson
        val isSameActiveOffer = activeOfferKey == offerKey

        if (!NotificationManagerCompat.from(context).areNotificationsEnabled()) {
            Log.w(TAG, "Offer alert skipped: app notifications are disabled")
            activeOfferKey = null
            return
        }

        val notification = buildOfferNotification(
            title = summary.title,
            body = summary.body,
            offerId = summary.offerId,
            payloadJson = payloadJson
        )

        try {
            NotificationManagerCompat
                .from(context)
                .notify(DriverForegroundService.OFFER_NOTIFICATION_ID, notification)
        } catch (error: SecurityException) {
            Log.e(TAG, "Failed to show offer notification", error)
        }

        if (isSameActiveOffer) {
            Log.d(TAG, "Offer alert updated without replaying sound -> offerKey=$offerKey")
            return
        }

        activeOfferKey = offerKey
        startSoundPlayback()

        Log.d(TAG, "Offer alert shown -> offerKey=$offerKey")
    }

    fun stopAlerting(cancelNotification: Boolean) {
        stopSoundOnly()

        if (cancelNotification) {
            NotificationManagerCompat
                .from(context)
                .cancel(DriverForegroundService.OFFER_NOTIFICATION_ID)
        }

        activeOfferKey = null
    }

    private fun stopSoundOnly() {
        mainHandler.removeCallbacks(stopSoundRunnable)

        mediaPlayer?.run {
            try {
                if (isPlaying) {
                    stop()
                }
            } catch (_: IllegalStateException) {
            }

            reset()
            release()
        }

        mediaPlayer = null
    }

    private fun startSoundPlayback() {
        stopSoundOnly()

        try {
            val assetFileDescriptor = context.resources.openRawResourceFd(R.raw.offer_alert)
                ?: run {
                    Log.e(TAG, "offer_alert raw resource not found")
                    return
                }

            val player = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )

                setDataSource(
                    assetFileDescriptor.fileDescriptor,
                    assetFileDescriptor.startOffset,
                    assetFileDescriptor.length
                )

                isLooping = false

                setOnCompletionListener { mp ->
                    try {
                        mp.reset()
                    } catch (_: Exception) {
                    }
                    try {
                        mp.release()
                    } catch (_: Exception) {
                    }
                    if (mediaPlayer === mp) {
                        mediaPlayer = null
                    }
                }

                setOnErrorListener { mp, what, extra ->
                    Log.e(TAG, "Offer sound playback error -> what=$what, extra=$extra")
                    try {
                        mp.reset()
                    } catch (_: Exception) {
                    }
                    try {
                        mp.release()
                    } catch (_: Exception) {
                    }
                    mediaPlayer = null
                    true
                }

                prepare()
                start()
            }

            assetFileDescriptor.close()
            mediaPlayer = player

            mainHandler.postDelayed(stopSoundRunnable, MAX_SOUND_PLAYBACK_MS)
        } catch (error: Exception) {
            Log.e(TAG, "Failed to start offer sound playback", error)
            mediaPlayer = null
        }
    }

    private fun buildOfferNotification(
        title: String,
        body: String,
        offerId: String?,
        payloadJson: String
    ): Notification {
        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(
                DriverForegroundService.EXTRA_LAUNCH_SOURCE,
                DriverForegroundService.LAUNCH_SOURCE_OFFER_NOTIFICATION
            )

            if (!offerId.isNullOrBlank()) {
                putExtra(DriverForegroundService.EXTRA_LAUNCHED_OFFER_ID, offerId)
            }

            putExtra(DriverForegroundService.EXTRA_LAUNCHED_OFFER_PAYLOAD, payloadJson)
        }

        val contentPendingIntent = PendingIntent.getActivity(
            context,
            DriverForegroundService.OFFER_NOTIFICATION_ID,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag()
        )

        val dismissIntent = Intent(context, DriverForegroundService::class.java).apply {
            action = DriverForegroundService.ACTION_DISMISS_OFFER_NOTIFICATION
        }

        val dismissPendingIntent = PendingIntent.getService(
            context,
            DriverForegroundService.OFFER_NOTIFICATION_ID,
            dismissIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or immutableFlag()
        )

        return NotificationCompat.Builder(context, DriverForegroundService.OFFERS_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(contentPendingIntent)
            .setDeleteIntent(dismissPendingIntent)
            .setAutoCancel(true)
            .setOnlyAlertOnce(false)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setVibrate(longArrayOf(0, 300, 200, 300))
            .setWhen(System.currentTimeMillis())
            .build()
    }

    private fun parseOfferSummary(payloadJson: String): OfferSummary {
        var title = "عرض رحلة جديد"
        var body = "وصلك عرض جديد."
        var offerId: String? = null

        try {
            val json = JSONObject(payloadJson)

            offerId = json.optString("offerId")
                .ifBlank { json.optString("id") }
                .ifBlank { null }

            val pickup = json.optString("pickup")
                .ifBlank { json.optString("pickup_address") }

            val price = json.optString("price")

            body = buildString {
                if (pickup.isNotBlank()) {
                    append("نقطة الانطلاق: ")
                    append(pickup)
                } else {
                    append("وصلك عرض جديد.")
                }

                if (price.isNotBlank()) {
                    append(" • السعر: ")
                    append(price)
                }
            }
        } catch (error: JSONException) {
            Log.e(TAG, "Failed to parse offer payload", error)
        }

        return OfferSummary(
            title = title,
            body = body,
            offerId = offerId
        )
    }

    private fun immutableFlag(): Int {
        return if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE
        } else {
            0
        }
    }

    private data class OfferSummary(
        val title: String,
        val body: String,
        val offerId: String?
    )

    companion object {
        private const val TAG = "OfferAlertManager"
        private const val MAX_SOUND_PLAYBACK_MS = 4_000L
    }
}
