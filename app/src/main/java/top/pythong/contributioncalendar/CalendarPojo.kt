package top.pythong.contributioncalendar


/**
 * @author ChangJiahong
 * @date 2020/12/31
 * Create By Android Studio
 */

class CalendarSheet(val data: List<Week>, val mTitle: ArrayList<CTitle>)

class CTitle(
    var index: Int,
    val title: String
)

class Week(var index: Int, val days: ArrayList<Day>)

class Day(val index: Int, var date: String, var dataCount: Int, var fill: String)
