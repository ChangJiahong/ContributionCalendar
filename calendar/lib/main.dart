import 'package:calendar/Calendar.dart';
import 'package:calendar/GithubClient.dart';
import 'package:calendar/Svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  static const int maxRow = 27; //最大显示列数

  static const String USERNAME = "username";

  SharedPreferences prefs ;
  String username;

  CalendarSheet sheet = CalendarSheet(
      data: List.generate(
          maxRow,
              (x) =>
              Week(
                  x: x, days: List.generate(7, (y) => Day(y: y, fill: "def")))),
      mTitle: List.generate(28, (index) => CTitle(index: index, title: " ")));

  void refreshData() async {
    prefs = await SharedPreferences.getInstance();
    username = getUsername();
    try {
      var res =
      await GithubClient.getGithubCalendar("https://github.com/$username");
      // 28
      // print(res.data.length);
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
      toast("加载成功");
    }catch(e){
      toast("用户名不存在，请检查后重试");
    }
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
        body: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.all(5),
                      // color: Colors.red,
                      child: Svg(
                        width: w - 10,
                        height: 200,
                        monthTitle: sheet.mTitle,
                        weekTitle: [1, 3, 5],
                        data: sheet.data,
                      )),
                  Positioned(
                    left: 20,
                    top: 20,
                    child: GestureDetector(
                      child: Text(username,
                        style: TextStyle(fontSize: 25, fontFamily: "Courier"),),
                      onTap: (){
                        showAlertDialog(context);
                      },),
                  ),
                ])
        ));
  }

  void showAlertDialog(BuildContext context) {

    TextEditingController _vc = new TextEditingController(text: username);
    //设置按钮
    Widget cancelButton = FlatButton(
      child: Text("取消"),
      onPressed: () {
        Navigator.of(context).pop(1);
      },
    );

    Widget continueButton = FlatButton(
      child: Text("确定"),
      onPressed: () {
        setUsername(_vc.text);
        setState(() {
          username = _vc.text;
        });
        refreshData();
        Navigator.of(context).pop(1);
      },
    );


    //设置对话框
    AlertDialog alert = AlertDialog(
      title: Text("输入用户名"),
      content: TextField(
        controller: _vc,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    //显示对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void toast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,  // 消息框弹出的位置
        timeInSecForIos: 1,  // 消息框持续的时间（目前的版本只有ios有效）
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void setUsername(String name) {
    prefs.setString(USERNAME, name);
  }

  String getUsername() {
    String name = prefs.getString(USERNAME);
    username =  name!=null&&name.isNotEmpty?name:"ChangJiahon";
    return username;
  }
}


// Week(x: 0,days: [Day(y: 0,fill: "def"),Day(y: 1,fill: "L2"),Day(y: 2,fill: "L3"),Day(y: 3,fill: "L4"),Day(y: 4,fill: "L4"),Day(y: 5,fill: "L1"),Day(y: 6,fill: "L1")]),
