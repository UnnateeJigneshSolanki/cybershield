package com.example.csh

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.SystemClock
import android.widget.RemoteViews
import android.app.ActivityManager
import android.os.Environment
import android.os.StatFs
import android.net.TrafficStats
import android.view.View
import java.net.NetworkInterface
import java.net.Inet4Address

// ─────────────────────────────────────────────────────────────────────────────
// ✨ THE MASTER WIDGET (CyberWidgetProvider)
// ─────────────────────────────────────────────────────────────────────────────
class CyberWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, CyberWidgetProvider::class.java).apply {
            action = "com.example.csh.WIDGET_SYNC"
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.setInexactRepeating(
            AlarmManager.ELAPSED_REALTIME,
            SystemClock.elapsedRealtime() + AlarmManager.INTERVAL_FIFTEEN_MINUTES,
            AlarmManager.INTERVAL_FIFTEEN_MINUTES,
            pendingIntent
        )
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "com.example.csh.WIDGET_SYNC") {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, CyberWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            for (appWidgetId in appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId)
            }
        }
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, CyberWidgetProvider::class.java).apply {
            action = "com.example.csh.WIDGET_SYNC"
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }

    companion object {
        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            views.setTextViewText(R.id.wid_model, android.os.Build.MODEL)
            val uptimeMillis = SystemClock.elapsedRealtime()
            val hours = (uptimeMillis / (1000 * 60 * 60)).toInt()
            val mins = ((uptimeMillis / (1000 * 60)) % 60).toInt()
            views.setTextViewText(R.id.wid_uptime, "Uptime ${hours}h ${mins}m")

            val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memInfo = ActivityManager.MemoryInfo()
            am.getMemoryInfo(memInfo)
            val ramPct = (((memInfo.totalMem - memInfo.availMem).toDouble() / memInfo.totalMem) * 100).toInt()
            views.setTextViewText(R.id.wid_ram_val, "$ramPct%")
            views.setProgressBar(R.id.wid_ram_bar, 100, ramPct, false)

            val path = Environment.getDataDirectory()
            val stat = StatFs(path.path)
            val totalStorage = stat.blockCountLong * stat.blockSizeLong
            val freeStorage = stat.availableBlocksLong * stat.blockSizeLong
            val usedStorage = totalStorage - freeStorage
            val storagePct = if (totalStorage > 0) ((usedStorage.toDouble() / totalStorage) * 100).toInt() else 0
            views.setTextViewText(R.id.wid_storage_val, "$storagePct%")
            views.setProgressBar(R.id.wid_storage_bar, 100, storagePct, false)

            val batteryStatus: Intent? = IntentFilter(Intent.ACTION_BATTERY_CHANGED).let { context.applicationContext.registerReceiver(null, it) }
            val level: Int = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val scale: Int = batteryStatus?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
            val batPct = if (level != -1 && scale != -1) (level * 100 / scale.toFloat()).toInt() else 0
            val temp = batteryStatus?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
            val batTemp = if (temp > 0) temp / 10 else 0

            views.setTextViewText(R.id.wid_bat_val, "🔋 $batPct%")
            views.setTextViewText(R.id.wid_temp_val, "$batTemp°C")

            val rxBytes = TrafficStats.getTotalRxBytes()
            val txBytes = TrafficStats.getTotalTxBytes()
            val totalBytes = if (rxBytes == TrafficStats.UNSUPPORTED.toLong()) 0L else (rxBytes + txBytes)
            val mb = totalBytes / (1024 * 1024)
            if (mb > 1024) {
                views.setTextViewText(R.id.wid_data_val, String.format("%.1f GB", mb / 1024.0))
            } else {
                views.setTextViewText(R.id.wid_data_val, "$mb MB")
            }

            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.wid_model, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// ✨ THE CYBER STRIP (4x1)
// ─────────────────────────────────────────────────────────────────────────────
class CyberStripProvider : AppWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == "ACTION_STRIP_SYNC_CLICK") {
            val appWidgetId = intent.getIntExtra("WIDGET_ID", AppWidgetManager.INVALID_APPWIDGET_ID)
            if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val views = RemoteViews(context.packageName, R.layout.widget_cyber_strip)

                // 1. STRIKE: Hide Cyan, Show White
                views.setViewVisibility(R.id.sync_icon_cyan, View.GONE)
                views.setViewVisibility(R.id.sync_icon_white, View.VISIBLE)
                appWidgetManager.partiallyUpdateAppWidget(appWidgetId, views)

                val pendingResult = goAsync()

                // 2. THE UNSTOPPABLE TIMER
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    try {
                        // ✨ EXPLICIT REVERSAL: Force the widget to drop the White view before fetching data
                        val resetViews = RemoteViews(context.packageName, R.layout.widget_cyber_strip)
                        resetViews.setViewVisibility(R.id.sync_icon_white, View.GONE)
                        resetViews.setViewVisibility(R.id.sync_icon_cyan, View.VISIBLE)

                        // Push this reset to the OS immediately
                        appWidgetManager.partiallyUpdateAppWidget(appWidgetId, resetViews)

                        // 3. Now run the full data refresh
                        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId))
                    } catch (e: Exception) {
                        e.printStackTrace()
                    } finally {
                        pendingResult.finish()
                    }
                }, 400) // 400ms flash duration
            }
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_cyber_strip)

            // ✨ HARD DEFAULT: Ensure every data update guarantees the Cyan icon is active
            views.setViewVisibility(R.id.sync_icon_white, View.GONE)
            views.setViewVisibility(R.id.sync_icon_cyan, View.VISIBLE)

            // Get RAM
            val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memInfo = ActivityManager.MemoryInfo()
            am.getMemoryInfo(memInfo)
            val ramPct = (((memInfo.totalMem - memInfo.availMem).toDouble() / memInfo.totalMem) * 100).toInt()

            // Get Battery & Temp
            val batteryStatus: Intent? = IntentFilter(Intent.ACTION_BATTERY_CHANGED).let { context.applicationContext.registerReceiver(null, it) }
            val level: Int = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val scale: Int = batteryStatus?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
            val batPct = if (level != -1 && scale != -1) (level * 100 / scale.toFloat()).toInt() else 0
            val temp = batteryStatus?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
            val batTemp = if (temp > 0) temp / 10 else 0

            views.setTextViewText(R.id.strip_ram_val, "$ramPct%")
            views.setTextViewText(R.id.strip_bat_val, "$batPct%")
            views.setTextViewText(R.id.strip_temp_val, "$batTemp°C")

            // Attach click listener to the entire sync container
            val syncIntent = Intent(context, CyberStripProvider::class.java).apply {
                action = "ACTION_STRIP_SYNC_CLICK"
                putExtra("WIDGET_ID", appWidgetId)
            }
            val pendingSync = PendingIntent.getBroadcast(
                context, appWidgetId, syncIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.btn_sync_container, pendingSync)

            // Final push to the home screen
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// ✨ THE POWER NODE (2x2)
// ─────────────────────────────────────────────────────────────────────────────
class PowerNodeProvider : AppWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "ACTION_POWER_SYNC_CLICK") {
            val appWidgetId = intent.getIntExtra("WIDGET_ID", AppWidgetManager.INVALID_APPWIDGET_ID)
            if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val views = RemoteViews(context.packageName, R.layout.widget_power_node)

                views.setViewVisibility(R.id.sync_icon_cyan, View.GONE)
                views.setViewVisibility(R.id.sync_icon_white, View.VISIBLE)
                appWidgetManager.partiallyUpdateAppWidget(appWidgetId, views)

                val pendingResult = goAsync()
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    try {
                        val resetViews = RemoteViews(context.packageName, R.layout.widget_power_node)
                        resetViews.setViewVisibility(R.id.sync_icon_white, View.GONE)
                        resetViews.setViewVisibility(R.id.sync_icon_cyan, View.VISIBLE)
                        appWidgetManager.partiallyUpdateAppWidget(appWidgetId, resetViews)

                        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId))
                    } finally {
                        pendingResult.finish()
                    }
                }, 400)
            }
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_power_node)

            views.setViewVisibility(R.id.sync_icon_white, View.GONE)
            views.setViewVisibility(R.id.sync_icon_cyan, View.VISIBLE)

            val batteryStatus: Intent? = IntentFilter(Intent.ACTION_BATTERY_CHANGED).let { context.applicationContext.registerReceiver(null, it) }
            val level: Int = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val scale: Int = batteryStatus?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
            val batPct = if (level != -1 && scale != -1) (level * 100 / scale.toFloat()).toInt() else 0
            val temp = batteryStatus?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
            val batTemp = if (temp > 0) temp / 10 else 0

            views.setTextViewText(R.id.node_bat_val, "$batPct%")
            views.setTextViewText(R.id.node_temp_val, "$batTemp°C")
            views.setProgressBar(R.id.node_bat_ring, 100, batPct, false)

            val syncIntent = Intent(context, PowerNodeProvider::class.java).apply {
                action = "ACTION_POWER_SYNC_CLICK"
                putExtra("WIDGET_ID", appWidgetId)
            }
            val pendingSync = PendingIntent.getBroadcast(context, appWidgetId, syncIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.btn_sync_container, pendingSync)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// ✨ THE MEMORY NODE (2x2)
// ─────────────────────────────────────────────────────────────────────────────
class MemoryNodeProvider : AppWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "ACTION_MEMORY_SYNC_CLICK") {
            val appWidgetId = intent.getIntExtra("WIDGET_ID", AppWidgetManager.INVALID_APPWIDGET_ID)
            if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val views = RemoteViews(context.packageName, R.layout.widget_memory_node)

                views.setViewVisibility(R.id.sync_icon_cyan, View.GONE)
                views.setViewVisibility(R.id.sync_icon_white, View.VISIBLE)
                appWidgetManager.partiallyUpdateAppWidget(appWidgetId, views)

                val pendingResult = goAsync()
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    try {
                        val resetViews = RemoteViews(context.packageName, R.layout.widget_memory_node)
                        resetViews.setViewVisibility(R.id.sync_icon_white, View.GONE)
                        resetViews.setViewVisibility(R.id.sync_icon_cyan, View.VISIBLE)
                        appWidgetManager.partiallyUpdateAppWidget(appWidgetId, resetViews)

                        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId))
                    } finally {
                        pendingResult.finish()
                    }
                }, 400)
            }
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_memory_node)

            views.setViewVisibility(R.id.sync_icon_white, View.GONE)
            views.setViewVisibility(R.id.sync_icon_cyan, View.VISIBLE)

            val am = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memInfo = ActivityManager.MemoryInfo()
            am.getMemoryInfo(memInfo)
            val ramPct = (((memInfo.totalMem - memInfo.availMem).toDouble() / memInfo.totalMem) * 100).toInt()

            val path = Environment.getDataDirectory()
            val stat = StatFs(path.path)
            val totalStorage = stat.blockCountLong * stat.blockSizeLong
            val freeStorage = stat.availableBlocksLong * stat.blockSizeLong
            val usedStorage = totalStorage - freeStorage
            val storagePct = if (totalStorage > 0) ((usedStorage.toDouble() / totalStorage) * 100).toInt() else 0

            views.setTextViewText(R.id.node_ram_val, "$ramPct%")
            views.setTextViewText(R.id.node_storage_val, "Storage: $storagePct%")
            views.setProgressBar(R.id.node_ram_ring, 100, ramPct, false)

            val syncIntent = Intent(context, MemoryNodeProvider::class.java).apply {
                action = "ACTION_MEMORY_SYNC_CLICK"
                putExtra("WIDGET_ID", appWidgetId)
            }
            val pendingSync = PendingIntent.getBroadcast(context, appWidgetId, syncIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.btn_sync_container, pendingSync)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// ✨ THE NETWORK UPLINK (2x2)
// ─────────────────────────────────────────────────────────────────────────────
class NetworkUplinkProvider : AppWidgetProvider() {
    private fun getLocalIpAddress(): String {
        try {
            val en = NetworkInterface.getNetworkInterfaces()
            while (en.hasMoreElements()) {
                val intf = en.nextElement()
                val enumIpAddr = intf.inetAddresses
                while (enumIpAddr.hasMoreElements()) {
                    val inetAddress = enumIpAddr.nextElement()
                    if (!inetAddress.isLoopbackAddress && inetAddress is Inet4Address) {
                        return inetAddress.hostAddress?.toString() ?: "--"
                    }
                }
            }
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
        return "Offline"
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "ACTION_NETWORK_SYNC_CLICK") {
            val appWidgetId = intent.getIntExtra("WIDGET_ID", AppWidgetManager.INVALID_APPWIDGET_ID)
            if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val views = RemoteViews(context.packageName, R.layout.widget_network_uplink)

                views.setViewVisibility(R.id.sync_icon_cyan, View.GONE)
                views.setViewVisibility(R.id.sync_icon_white, View.VISIBLE)
                appWidgetManager.partiallyUpdateAppWidget(appWidgetId, views)

                val pendingResult = goAsync()
                android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                    try {
                        val resetViews = RemoteViews(context.packageName, R.layout.widget_network_uplink)
                        resetViews.setViewVisibility(R.id.sync_icon_white, View.GONE)
                        resetViews.setViewVisibility(R.id.sync_icon_cyan, View.VISIBLE)
                        appWidgetManager.partiallyUpdateAppWidget(appWidgetId, resetViews)

                        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId))
                    } finally {
                        pendingResult.finish()
                    }
                }, 400)
            }
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_network_uplink)

            views.setViewVisibility(R.id.sync_icon_white, View.GONE)
            views.setViewVisibility(R.id.sync_icon_cyan, View.VISIBLE)

            views.setTextViewText(R.id.node_ip_val, getLocalIpAddress())

            val rxBytes = TrafficStats.getTotalRxBytes()
            val txBytes = TrafficStats.getTotalTxBytes()
            val totalBytes = if (rxBytes == TrafficStats.UNSUPPORTED.toLong()) 0L else (rxBytes + txBytes)
            val mb = totalBytes / (1024 * 1024)

            if (mb > 1024) {
                views.setTextViewText(R.id.node_data_val, String.format("Traffic: %.1f GB", mb / 1024.0))
            } else {
                views.setTextViewText(R.id.node_data_val, "Traffic: $mb MB")
            }

            val syncIntent = Intent(context, NetworkUplinkProvider::class.java).apply {
                action = "ACTION_NETWORK_SYNC_CLICK"
                putExtra("WIDGET_ID", appWidgetId)
            }
            val pendingSync = PendingIntent.getBroadcast(context, appWidgetId, syncIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.btn_sync_container, pendingSync)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}