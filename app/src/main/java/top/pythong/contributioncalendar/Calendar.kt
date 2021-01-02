package top.pythong.contributioncalendar

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews


/**
 * 应用小工具功能的实现。
 */
class Calendar : AppWidgetProvider() {
    companion object {
        val REFRESH_ACTION = "top.pythong.refresh_action"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // 可能有多个小部件处于活动状态，因此请更新所有小部件
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
//            GlobalScope.launch(Dispatchers.IO){
//                Log.d("GridFactory","刷新数据")
//                delay(10000)
//                Log.d("GridFactory","刷新数据成功")
//                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId,R.id.gridView)
//            }
        }
    }

    override fun onReceive(context: Context, intent: Intent?) {
        val action = intent!!.action
        val appWidgetManager = AppWidgetManager.getInstance(context)
        Log.d("GridFactory", "接收点击事件，位置：${intent!!.getStringExtra(REFRESH_ACTION)}")
        if (action == REFRESH_ACTION) {
            Log.d("GridFactory", "接收点击事件，位置：${intent!!.getStringExtra(REFRESH_ACTION)}")
//            val appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,
//                    AppWidgetManager.INVALID_APPWIDGET_ID)
//            updateAppWidget(context,appWidgetManager,appWidgetId)
        }

        super.onReceive(context, intent)
    }

    override fun onEnabled(context: Context) {
        // 当该窗口小部件第一次添加到桌面时调用该方法
    }

    override fun onDisabled(context: Context) {
        // 当最后一个该窗口小部件删除时调用该方法
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {


    // 构造RemoteViews对象
    val views = RemoteViews(context.packageName, R.layout.calendar)

    val serviceIntent = Intent(context, GridWidgetService::class.java)
    views.setRemoteAdapter(R.id.gridView, serviceIntent)
    Log.d("Calendar", "updateAPPWidget")

    val gridIntent = Intent()
    gridIntent.action = Calendar.REFRESH_ACTION
    gridIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
    val pendingIntent =
        PendingIntent.getBroadcast(context, 0, gridIntent, PendingIntent.FLAG_UPDATE_CURRENT)
    // 设置intent模板
    // 设置intent模板
    views.setPendingIntentTemplate(R.id.gridView, pendingIntent)

//    // 指示小部件管理器更新小部件
    appWidgetManager.updateAppWidget(appWidgetId, views)
}