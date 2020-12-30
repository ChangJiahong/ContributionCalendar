import 'package:calendar/Calendar.dart';
import 'package:calendar/GithubClient.dart';
import 'package:calendar/Svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Bg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const int maxRow=27;//最大显示列数

  CalendarSheet sheet = CalendarSheet(
      data: List.generate(
          maxRow,
          (x) => Week(
              x: x, days: List.generate(7, (y) => Day(y: y, fill: "def")))),
      mTitle: List.generate(28, (index) => CTitle(index: index,title: " ")));

  void refreshData() async {
    var res =
        await GithubClient.getGithubCalendar("https://github.com/ChangJiahong");
    // 28
    print(res.data.length);
    var subInt = res.data.length - maxRow;
    // print(subInt);
    // print(res.mTitle.iterator);
    // 裁剪数据
    res.data = res.data.sublist(subInt);
    // 裁剪标题
    List<CTitle> nTitle = List();
    for (var t in res.mTitle) {
      // print(t.index);
      t.index -= subInt;
      // print(t.index);
      if (t.index >= 0) {
        nTitle.add(t);
      }
    }
    res.mTitle = nTitle;

    setState(() {
      sheet = res;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    refreshData();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double w = _mediaQueryData.size.width;
    double h = _mediaQueryData.size.height;
    double cw = w / 51.0;
    double ch = h / 7.0;

    return Scaffold(
        body: Center(
            child: Container(
                margin: EdgeInsets.all(5),
                // color: Colors.red,
                child: Svg(
                  width: w - 10,
                  height: 200,
                  monthTitle: sheet.mTitle,
                  weekTitle: [1, 3, 5],
                  data: sheet.data,
                ))));
  }
}


// Week(x: 0,days: [Day(y: 0,fill: "def"),Day(y: 1,fill: "L2"),Day(y: 2,fill: "L3"),Day(y: 3,fill: "L4"),Day(y: 4,fill: "L4"),Day(y: 5,fill: "L1"),Day(y: 6,fill: "L1")]),
