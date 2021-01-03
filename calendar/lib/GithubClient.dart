import 'dart:convert';
import 'dart:io';
import 'package:calendar/Calendar.dart';
import 'package:calendar/HttpError.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' as prefix;
import 'package:html/parser.dart' show parse;
import 'package:xpath_parse/xpath_selector.dart';

///
///获取GitHub贡献日历
///@author ChangJiahong
///@date 2020/12/30
///Create By Android Studio
///

class CalendarSheet{
  List<Week> data;
  List<CTitle> mTitle;
  CalendarSheet({this.data, this.mTitle});

}

class GithubClient {
  var httpClient = new HttpClient();

  static String parseFill(String f) {
    switch (f) {
      case "var(--color-calendar-graph-day-bg)":
        return "def";
      case "var(--color-calendar-graph-day-L1-bg)":
        return "L1";
      case "var(--color-calendar-graph-day-L2-bg)":
        return "L2";
      case "var(--color-calendar-graph-day-L3-bg)":
        return "L3";
      case "var(--color-calendar-graph-day-L4-bg)":
        return "L4";
    }
  }

  static String parseDate(String date, bool isEn){
    var mm = date.split("-")[1];
    switch(mm){
      case "01":
        return isEn?"Jan":"一月";
      case "02":
        return isEn?"Feb":"二月";
      case "03":
        return isEn?"Mar":"三月";
      case "04":
        return isEn?"Apr":"四月";
      case "05":
        return isEn?"May":"五月";
      case "06":
        return isEn?"Jun":"六月";
      case "07":
        return isEn?"Jul":"七月";
      case "08":
        return isEn?"Aug":"八月";
      case "09":
        return isEn?"Sep":"九月";
      case "10":
        return isEn?"Oct":"十月";
      case "11":
        return isEn?"Nov":"十一";
      case "12":
        return isEn?"Dec":"十二";
    }
  }


  static Future<CalendarSheet> getGithubCalendar(String url) async {
    Response res ;
    try {
      res = await new Dio().get(url);
    }catch(e){
      throw HttpError();
    }
    var html = res.data;
    // var list = XPath.source(html).query("//*[@id=\"js-pjax-container\"]/div[2]/div/div[2]/div[2]/div/div[2]/div[1]/div/div/div[1]").list();
    var document = parse(html);
    var svg = document.getElementsByClassName("js-calendar-graph-svg").first;

    // 取到所有的列数据
    var g_text = svg.children.first.children;
    List<Week> data = List();
    List<CTitle> monthTitles= List();
    int xIndex = 0;//列号
    bool mTileFlag=false;//记录月份标志
    var tempMonth="";
    for (var gt in g_text) {
      switch (gt.localName) {
        case "g":
          // 分割列数据
          var col = gt;
          var days = col.children;
          var week = Week(x:xIndex++);
          week.days=List();
          int yIndex = 0;//行号
          // print("-----------${week.x}--------");
          var p=parseDate(days[0].attributes["data-date"], true);// 当前列第一天的月份
          var f=false;
          for (var day in days) {
            var wd = Day(
                y: yIndex++,
                date: day.attributes["data-date"],
                dataCount: int.parse(day.attributes["data-count"]),
                fill: parseFill(day.attributes["fill"]));
            var date = parseDate(wd.date, true);
            if(date!=p){// 与当前列第一天不是同一月
              f=true;
            }

            week.days.add(wd);
            // print(day.outerHtml);
            // print(wd);
          }
          if(mTileFlag||week.days[0].date.split("-")[2]=="01") {
            // 记录标题
            monthTitles.add(CTitle(
                index: week.x, title: parseDate(week.days[0].date, true)));
            mTileFlag=false;
          }
          mTileFlag=f;
          data.add(week);
          break;
        case "text":
          switch(gt.className){
            case "month":
              // monthTitles.add(CTitle(index: ((int.parse(gt.attributes["x"])-1)/15 - 1).round(), title: gt.text));
              break;
            case "wday":

              break;
          }
          break;
      }

    }

    return CalendarSheet(data: data, mTitle: monthTitles);
  }
}
