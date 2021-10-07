import 'package:flutter/material.dart';


class MapPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blue,
      child: Text('MAP'),
    );
  }
}