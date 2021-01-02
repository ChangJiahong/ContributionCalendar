package top.pythong.contributioncalendar

import org.jsoup.Jsoup


/**
 * @author ChangJiahong
 * @date 2021/1/2
 * Create By Android Studio
 */
object GithubClient {
    fun parseFill(f: String): String = when (f) {
        "var(--color-calendar-graph-day-bg)" -> "def"
        "var(--color-calendar-graph-day-L1-bg)" -> "L1"
        "var(--color-calendar-graph-day-L2-bg)" -> "L2"
        "var(--color-calendar-graph-day-L3-bg)" -> "L3"
        "var(--color-calendar-graph-day-L4-bg)" -> "L4"
        else -> "null"
    }

    private fun parseDate(date: String, isEn: Boolean): String =
        when (date.split("-").toTypedArray()[1]) {
            "01" -> if (isEn) "Jan" else "一月"
            "02" -> if (isEn) "Feb" else "二月"
            "03" -> if (isEn) "Mar" else "三月"
            "04" -> if (isEn) "Apr" else "四月"
            "05" -> if (isEn) "May" else "五月"
            "06" -> if (isEn) "Jun" else "六月"
            "07" -> if (isEn) "Jul" else "七月"
            "08" -> if (isEn) "Aug" else "八月"
            "09" -> if (isEn) "Sep" else "九月"
            "10" -> if (isEn) "Oct" else "十月"
            "11" -> if (isEn) "Nov" else "十一"
            "12" -> if (isEn) "Dec" else "十二"
            else -> " "
        }

    fun getSheetByGithub(url:String): CalendarSheet {

        val doc = Jsoup.connect(url).get()
        val svgs = doc.getElementsByClass("js-calendar-graph-svg")[0].children()[0].children()
        val data: ArrayList<Week> = ArrayList()
        val monthTitles: ArrayList<CTitle> = ArrayList()
        var xIndex = 0 //列号
        var mTileFlag = false //记录月份标志
        for (gt in svgs) {
            when (gt.nodeName()) {
                "g" -> {
                    // 分割列数据
                    val col = gt;
                    val days = col.children()
                    val week = Week(xIndex++, days = ArrayList())
                    val p = parseDate(
                        days[0].attr("data-date"),
                        true
                    ) // 当前列第一天的月份

                    var f = false
                    for ((yIndex, day) in days.withIndex()) {
                        val wd = Day(
                            index = yIndex,
                            date = day.attr("data-date"),
                            dataCount = day.attr("data-count").toInt(),
                            fill = parseFill(day.attr("fill"))
                        )
                        val date = parseDate(wd.date, true)
                        if (date != p) {// 与当前列第一天不是同一月
                            f = true;
                        }
                        week.days.add(wd)
                    }
                    if (mTileFlag || week.days[0].date.split("-")[2] == "01") {
                        // 记录标题
                        monthTitles.add(
                            CTitle(
                                index = week.index, title = parseDate(week.days[0].date, true)
                            )
                        )
                        mTileFlag = false
                    }
                    mTileFlag = f
                    data.add(week)
                }
                "text" -> {
                    when (gt.className()) {
                        "month" -> {
                            // monthTitles.add(CTitle(index: ((int.parse(gt.attributes["x"])-1)/15 - 1).round(), title: gt.text));
                        }
                        "wday" -> {
                        }
                    }
                }
            }

        }

        return CalendarSheet(data = data, mTitle = monthTitles);
    }


    fun createData(): CalendarSheet {
        val weeks = arrayListOf(
            Week(
                0, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L2"),
                    Day(3, "", 0, "L3"),
                    Day(4, "", 0, "L4"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L2")
                )
            ),
            Week(
                1, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                2, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                3, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                4, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                5, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                6, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                7, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                8, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                9, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                10, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                11, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L1"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L1"),
                    Day(5, "", 0, "L1"),
                    Day(6, "", 0, "L1")
                )
            ),
            Week(
                12, arrayListOf(
                    Day(0, "", 0, "L1"),
                    Day(1, "", 0, "L1"),
                    Day(2, "", 0, "L3"),
                    Day(3, "", 0, "L1"),
                    Day(4, "", 0, "L2"),
//                Day(5, "", 0, "L1"),
//                Day(6, "", 0, "L1")
                )
            )
        )
        val monthTitles = arrayListOf(CTitle(0, "dec"), CTitle(4, "tep"))
        val data = CalendarSheet(weeks, monthTitles)
        return data
    }

}