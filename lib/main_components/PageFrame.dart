import 'package:flutter/material.dart';
import 'package:hku_guide/pages/BuildingPage.dart';
import 'package:hku_guide/pages/ClassPage.dart';
import 'package:hku_guide/pages/HomePage.dart';
import 'package:hku_guide/pages/SettingPage.dart';
import 'package:hku_guide/pages/TipPage.dart';


class PageFrame extends StatefulWidget{
  PageFrame({Key key, this.controller}) : super(key: key);

  PageController controller;

  @override
  State<StatefulWidget> createState() => _PageFrameState();
}

class _PageFrameState extends State<PageFrame>{

  int getPageNum(){
    return widget.controller.page.round();
  }

  @override
  Widget build(BuildContext context) {


    return PageView(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: widget.controller,
      children: [
        ClassPage(),
        BuildingPage(),
        HomePage(),
        TipPage(),
        SettingPage(),
      ],
    );
  }
}