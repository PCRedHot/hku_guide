import 'package:flutter/material.dart';
import 'package:hku_guide/classes/OnlineJsonClasses.dart';
import 'package:hku_guide/tools/DataManager.dart';


class BuildingPage extends StatefulWidget{
  BuildingPage({Key key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage>{

  List<Building> buildingData = [];

  @override
  void initState() {
    super.initState();
    getBuildingData().then((value){
      setState(() {
        buildingData = [];
        for (int i = 0; i < value.length; i++){
          Map buildingJson = value[i];
          buildingData.add(Building.fromJson(buildingJson));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _getBuildingWidgets(),
    );

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
      child: Text('BUILD'),
    );
  }


  List<Widget> _getBuildingWidgets(){
    List<Widget> widgets = [];
    for (int i = 0; i < buildingData.length; i++) {
      Building building = buildingData[i];
      widgets.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(building.abbv),
            Text(building.name),
          ],
        ),
      ));
    }
    return widgets;
  }
}