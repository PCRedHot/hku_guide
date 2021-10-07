import 'package:flutter/material.dart';


class SettingPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.green,
      child: Text('SETTING'),
    );
  }
}