import 'package:flutter/material.dart';

class TipPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _TipPageState();
}

class _TipPageState extends State<TipPage>{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.yellow,
      child: Text('TIP'),
    );
  }
}