import 'package:flutter/material.dart';


class ClassPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage>{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blue,
      child: Text('CLASS'),
    );
  }
}