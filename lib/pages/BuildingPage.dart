import 'package:flutter/material.dart';


class BuildingPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage>{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
      child: Text('BUILD'),
    );
  }
}