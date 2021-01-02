package top.pythong.contributioncalendar

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import kotlinx.coroutines.*


/**
 * @author ChangJiahong
 * @date 2020/12/31
 * Create By Android Studio
 */
class GridWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        Log.d("RemoteService", "create GridRemoteViewsFactory")
        return GridRemoteViewsFactory(this, intent)
    }

    class GridRemoteViewsFactory(val context: Context, val intent: Intent?) : RemoteViewsFactory {

        val TAG = "GridFactory"

        private val mAppWidgetId = intent?.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        )

        val maxLineSize = 14
        val maxLine = 8
        val maxSize = maxLineSize * maxLine

        val weeks = arrayOf("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")

        private var data: Array<Day> = Array(maxSize) { i ->
            if (i==1*maxLineSize||i==2*maxLineSize||i==3*maxLineSize||i==4*maxLineSize||i==5*maxLineSize||i==6*maxLineSize||i==7*maxLineSize){
                // 初始化星期列
                return@Array Day(
                    i,
                    "",
                    0,
                    if (i / maxLineSize % 2 != 0) " " else weeks[i / maxLineSize - 1]
                )
            }
            if (i<14){
                // 初始化标题行
                return@Array Day(i, "", 0, " ")
            }
            Day(i, "", 0, "null")
        }

        override fun onCreate() {

        }

        override fun onDataSetChanged() {
            val sheet = getSheetByGithub()
            sheetToData(sheet)
        }

        private fun getSheetByGithub(): CalendarSheet {
            val sheet = GithubClient.getSheetByGithub("https://github.com/ChangJiahong")

            /**
             * 裁剪数据
             */
            val maxRow = maxLineSize-1
            var subInt = sheet.data.size - maxRow
            // 裁剪数据
            val dayData=sheet.data.subList(subInt,sheet.data.size)
            dayData.forEach {
                it.index -=subInt
            }
            // 裁剪标题
            val nTitle = ArrayList<CTitle>();
            for (t in sheet.mTitle) {
                t.index -= subInt
                if (t.index >= 0) {
                    nTitle.add(t);
                }
            }

            return CalendarSheet(dayData, nTitle)
        }

        /**
         * 把Sheet数据转换成gridView 数组
         */
        private fun sheetToData(sheet: CalendarSheet) {
//            // 初始化标题行
//            for (i in 0..13) {
//                data[i].fill = " "
//            }

            // 标题行
            sheet.mTitle.forEach {
                data[it.index + 1].fill = it.title
            }
//            // 星期行
//            for (i in 1..7) {
//                data[i * maxLineSize].fill = if (i % 2 == 0) " " else weeks[i - 1]
//            }

            // 填充数据
            sheet.data.forEach { week ->
                week.days.forEach { day ->
                    data[(day.index + 1) * maxLineSize + week.index + 1]=day
                }
            }
        }

        override fun onDestroy() {
            data
        }

        override fun getCount(): Int {
            return data.size
        }

        override fun getViewAt(position: Int): RemoteViews {

//            Log.d(TAG, "GridRemoteViewsFactory getViewAt:$position")
            // 获取 grid_view_item.xml 对应的RemoteViews
            val rv = RemoteViews(context.packageName, R.layout.grid_view_item)

            // 设置 第position位的“视图”的数据
            val day: Day = data[position]

            val bg = parse(day.fill)
            if (bg != -1) {
                rv.setViewVisibility(R.id.itemText, View.GONE)
                rv.setViewVisibility(R.id.itemImage, View.VISIBLE)
                rv.setImageViewResource(R.id.itemImage, bg)
            } else {
                rv.setViewVisibility(R.id.itemText, View.VISIBLE)
                rv.setViewVisibility(R.id.itemImage, View.GONE)
                rv.setTextViewText(R.id.itemText, day.fill)
            }

            // 设置 第position位的“视图”对应的响应事件
            val fillInIntent = Intent()
            fillInIntent.putExtra(Calendar.REFRESH_ACTION, position)
            rv.setOnClickFillInIntent(R.id.itemImage, fillInIntent)

            return rv
        }

        fun parse(fill: String) = when (fill) {
            "L1" -> R.drawable.rect_l1
            "L2" -> R.drawable.rect_l2
            "L3" -> R.drawable.rect_l3
            "L4" -> R.drawable.rect_l4
            "def" -> R.drawable.rect_def
            "null" -> R.drawable.rect_null
            else -> -1
        }

        fun reparse(fill: Int) = when (fill) {
            R.drawable.rect_l1 -> "L1"
            R.drawable.rect_l2 -> "L2"
            R.drawable.rect_l3 -> "L3"
            R.drawable.rect_l4 -> "L4"
            R.drawable.rect_def -> "def"
            R.drawable.rect_null -> "null"
            else -> "l"
        }


        override fun getLoadingView(): RemoteViews? {
            return null
        }

        override fun getViewTypeCount(): Int {
            return 1
        }

        override fun getItemId(position: Int): Long {
            return position.toLong()
        }

        override fun hasStableIds(): Boolean {
            return true
        }
    }
}