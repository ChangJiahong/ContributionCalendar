import 'package:calendar/Calendar.dart';
import 'package:calendar/Rect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Bg.dart';

///
///获取GitHub贡献日历
///@author ChangJiahong
///@date 2020/12/30
///Create By Android Studio
///

class Svg extends StatelessWidget {
  List<Week> data;
  List<CTitle> monthTitle;
  int mtIndex = 0;
  List weekTitle;
  int wtIndex = 0;
  double width;
  double height;

  var colors = {
    "def": Bg.defult,
    "L1": Bg.L1,
    "L2": Bg.L2,
    "L3": Bg.L3,
    "L4": Bg.L4,
  };

  var weeks=["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];

  Svg({this.width, this.height, this.data, this.monthTitle, this.weekTitle});

  @override
  Widget build(BuildContext context) {
    for (var w in data) {
      w.days.sort((a, b) => a.y.compareTo(b.y));
    }
    data.sort((a, b) => a.x.compareTo(b.x));

    List<Column> rows = new List();
    // 行数，带标题8行，不带则7行
    var len = monthTitle!=null&&monthTitle.isNotEmpty?8:7;
    /**
     * 加侧边周标题
     */
    if (weekTitle!=null&&weekTitle.isNotEmpty) {
      List<Widget> col = List();
      for (var i = 0; i < len; i++) {
        if(wtIndex<weekTitle.length&&weekTitle[wtIndex]==i-1){
          col.add(Rect(text: weeks[weekTitle[wtIndex]]));
          wtIndex++;
        }else{
          col.add(Rect(text:" "));
        }
      }
      var row = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: col,
      );
      rows.add(row);
    }
    for (var i = 0; i < data.length; i++) {
      List<Widget> col = new List();
      /**
       * 加月标题
       */
      if (monthTitle!=null&&monthTitle.isNotEmpty) {
        if (mtIndex<monthTitle.length && monthTitle[mtIndex].index == i) {
          col.add(Rect(text: monthTitle[mtIndex].title));
          mtIndex++;
        } else {
          col.add(Rect(text: " ",));
        }
      }
      /**
       * 绘制周数据
       */
      Week week = data[i];
      for (var j = 0; j < week.days.length; j++) {
        var day = week.days[j];
        var item = Rect(
          color: colors[day.fill],
        );
        col.add(item);
      }

      if(col.length<len){
        // 最后一列没有数据则显示空
        var s=len-col.length;
        for(var i=0;i<s;i++){
          col.add(Rect(text: " ",));
        }
      }

      var row = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: col,
      );
      rows.add(row);
    }

    var sheet =
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: rows);

    return Container(
      width: this.width,
      height: this.height,
      child: sheet,
    );
  }
}
