import 'package:calendar/Bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * 贡献方块
 * @author ChangJiahong
 * @date 2020/12/30
 * Create By Android Studio
 */

class Rect extends StatelessWidget {



  final double width;
  final double height;
  final Color color;
  final String text;

  Rect({this.width=20, this.height=20, this.color=Bg.defult, this.text=""});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        height: this.height,
        child: Center(child:Text(text,style: TextStyle(fontSize: 10),)),
        decoration: text.isNotEmpty?null:BoxDecoration(
          border: Border.all(
            color: Color(0x0f1b1f23),
          ),
          borderRadius: BorderRadius.circular(3),
          color: this.color,
        ));
  }


}
