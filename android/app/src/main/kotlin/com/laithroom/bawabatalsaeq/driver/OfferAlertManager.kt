package com.bawabatalsaeq.driver

import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import org.json.JSONException
import org.json.JSONObject

class OfferAlertManager(
    private val context: Context
) {

    private var mediaPlayer: MediaPlayer? = null
    private var activeOfferKey: String? = null

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
            summary = summary,
            payloadJson = payloadJson
        )

        try {
            NotificationManagerCompat
                .from(context)
                .notify(DriverForegroundService.OFFER_NOTIFICATION_ID, notification)
        } catch (error: SecurityException) {
            Log.e(TAG, "Failed to show offer notification", error)
        }

        if (!isSameActiveOffer) {
            activeOfferKey = offerKey
            startSoundPlaybackOnce()
        }

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
        val player = mediaPlayer ?: return

        try {
            if (player.isPlaying) {
                player.stop()
            }
        } catch (_: IllegalStateException) {
        }

        try {
            player.reset()
        } catch (_: IllegalStateException) {
        }

        try {
            player.release()
        } catch (_: IllegalStateException) {
        }

        mediaPlayer = null
    }

    private fun startSoundPlaybackOnce() {
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
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION_EVENT)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )

                setDataSource(
                    assetFileDescriptor.fileDescriptor,
                    assetFileDescriptor.startOffset,
                    assetFileDescriptor.length
                )

                isLooping = false

                setOnCompletionListener {
                    stopSoundOnly()
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
        } catch (error: Exception) {
            Log.e(TAG, "Failed to start offer sound playback", error)
            mediaPlayer = null
        }
    }

    private fun buildOfferNotification(
        summary: OfferSummary,
        payloadJson: String
    ): Notification {
        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(
                DriverForegroundService.EXTRA_LAUNCH_SOURCE,
                DriverForegroundService.LAUNCH_SOURCE_OFFER_NOTIFICATION
            )

            if (!summary.offerId.isNullOrBlank()) {
                putExtra(DriverForegroundService.EXTRA_LAUNCHED_OFFER_ID, summary.offerId)
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
            .setSmallIcon(android.R.drawable.ic_dialog_map)
            .setLargeIcon(loadAppLargeIcon())
            .setContentTitle(summary.title)
            .setContentText(summary.previewText)
            .setSubText("بوابة السائق")
            .setStyle(
                NotificationCompat.BigTextStyle()
                    .bigText(summary.bigText)
                    .setSummaryText("اضغط لفتح العرض الآن")
            )
            .setContentIntent(contentPendingIntent)
            .setDeleteIntent(dismissPendingIntent)
            .addAction(
                android.R.drawable.ic_menu_view,
                "فتح العرض",
                contentPendingIntent
            )
            .setAutoCancel(true)
            .setOnlyAlertOnce(false)
            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setColor(0xFF0EA5E9.toInt())
            .setShowWhen(true)
            .setWhen(System.currentTimeMillis())
            .setTicker("عرض جديد متاح الآن")
            .setDefaults(NotificationCompat.DEFAULT_LIGHTS)
            .setVibrate(longArrayOf(0, 250, 150, 250))
            .setFullScreenIntent(contentPendingIntent, false)
            .build()
    }

    private fun parseOfferSummary(payloadJson: String): OfferSummary {
        var offerId: String? = null
        var pickup = ""
        var dropoff = ""
        var price = ""
        var notes = ""

        try {
            val json = JSONObject(payloadJson)

            offerId = json.optString("offerId")
                .ifBlank { json.optString("id") }
                .ifBlank { null }

            pickup = json.optString("pickup")
                .ifBlank { json.optString("pickup_address") }

            dropoff = json.optString("dropoff")
                .ifBlank { json.optString("dropoff_address") }

            price = json.optString("price")
                .ifBlank { json.optString("fare") }

            notes = json.optString("notes")
        } catch (error: JSONException) {
            Log.e(TAG, "Failed to parse offer payload", error)
        }

        val previewText = buildString {
            if (pickup.isNotBlank()) {
                append("الانطلاق: ")
                append(pickup)
            } else {
                append("وصلك عرض رحلة جديد")
            }

            if (price.isNotBlank()) {
                append(" • الأجرة: ")
                append(price)
            }
        }

        val bigText = buildString {
            if (pickup.isNotBlank()) {
                append("نقطة الانطلاق: ")
                append(pickup)
            } else {
                append("وصلك عرض رحلة جديد")
            }

            if (dropoff.isNotBlank()) {
                append("\nالوجهة: ")
                append(dropoff)
            }

            if (price.isNotBlank()) {
                append("\nالأجرة: ")
                append(price)
            }

            if (notes.isNotBlank()) {
                append("\nملاحظات: ")
                append(notes)
            }
        }

        return OfferSummary(
            title = "عرض رحلة جديد",
            previewText = previewText,
            bigText = bigText,
            offerId = offerId
        )
    }

    private fun loadAppLargeIcon(): Bitmap? {
        val iconRes = context.applicationInfo.icon
        if (iconRes == 0) return null
        return try {
            BitmapFactory.decodeResource(context.resources, iconRes)
        } catch (_: Exception) {
            null
        }
    }

    private fun immutableFlag(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_IMMUTABLE
        } else {
            0
        }
    }

    private data class OfferSummary(
        val title: String,
        val previewText: String,
        val bigText: String,
        val offerId: String?
    )

    companion object {
        private const val TAG = "OfferAlertManager"
    }
}
