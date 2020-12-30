///
///获取GitHub贡献日历
///@author ChangJiahong
///@date 2020/12/30
///Create By Android Studio
///

class CTitle{
  int index;
  String title;
  CTitle({this.index, this.title});
}

class Week {
  int x;
  List<Day> days;
  Week({this.x,this.days});
}

class Day{
  int y;
  String date;
  int dataCount;
  String fill;
  Day({this.y,this.date,this.dataCount,this.fill});

  @override
  String toString() {
    return "{y:$y,date:$date,dataCount:$dataCount,fill:$fill}";
  }
}
