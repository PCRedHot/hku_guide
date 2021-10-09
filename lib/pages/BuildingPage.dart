import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hku_guide/classes/OnlineJsonClasses.dart';
import 'package:hku_guide/tools/DataManager.dart';
import 'package:hku_guide/tools/LocationTools.dart';
import 'package:url_launcher/url_launcher.dart';


class BuildingPage extends StatefulWidget{
  BuildingPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage>{

  List<Building> buildingData;

  GeolocatorPlatform _geolocator;
  Position _position;
  StreamSubscription<Position> _positionStream;
  TextEditingController _searchTextEditingController;
  String searchText = '';

  final Color colorThemeDark = Color.fromRGBO(58, 66, 86, 1.0);
  final Color colorThemeLight = Color.fromRGBO(68, 76, 96, 1.0);
  final Color colorThemeLighter = Color.fromRGBO(78, 86, 106, 1.0);
  final Map<String, Color> areaColors = {
    'A': Color.fromRGBO(233, 196, 166, 1),
    'B': Color.fromRGBO(244, 245, 160, 1),
    'C': Color.fromRGBO(207, 237, 184, 1),
  };

  @override
  void initState() {
    super.initState();

    // Load Building Data
    if (PageStorage.of(context).readState(context, identifier: 'buildingData') != null){
        buildingData = PageStorage.of(context).readState(context, identifier: 'buildingData');
    }else{
      getBuildingData().then((value){
        buildingData = [];
        value.forEach((buildingJson) => buildingData.add(Building.fromJson(buildingJson)));
        PageStorage.of(context).writeState(context, buildingData, identifier: 'buildingData');
     });
    }

    // Initialise Geolocator
    _geolocator = GeolocatorPlatform.instance;
    _positionStream = _geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation, timeInterval: 5000).listen((Position position) {
      print('Position Get: ${position.toString()}');
      setState(() {
        _position = position;
        if (buildingData != null) {
          buildingData.forEach((building) {
            building.distance = distanceBetweenPositions(_position.longitude, _position.latitude, building.longitude, building.latitude);
          });
          buildingData.sort((a, b) => a.distance.compareTo(b.distance));
        }
      });
      PageStorage.of(context).writeState(context, buildingData, identifier: 'buildingData');
    });

    // Initialise Search Bar Controller
    _searchTextEditingController = TextEditingController();
    _searchTextEditingController.addListener(() {
      setState(() {
        searchText = _searchTextEditingController.value.text;
        PageStorage.of(context).writeState(context, searchText, identifier: 'buildingSearchText');
      });
    });
    searchText = PageStorage.of(context).readState(context, identifier: 'buildingSearchText') ?? '';
    _searchTextEditingController.value = _searchTextEditingController.value.copyWith(
      text: searchText
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    _positionStream.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (buildingData == null){
      return Center(
        child: SpinKitSquareCircle(
          color: Color.fromRGBO(220, 220, 220, 1.0),
          size: 50.0,
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0 , 10.0, 20.0, 2.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: _searchTextEditingController,
            autofocus: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Color.fromRGBO(220, 220, 220, 1.0),),
              suffixIcon: GestureDetector(
                  onTap: _clearSearch,
                  child: Icon(Icons.backspace_outlined, color: Color.fromRGBO(220, 220, 220, 1.0),)
              ),              filled: true,
              fillColor: colorThemeLighter,
              labelText: 'Search',
              labelStyle: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: _getBuildingWidgets(),
            ),
          ),
        ),
      ],
    );
  }


  List<Widget> _getBuildingWidgets(){
    List<Widget> widgets = [];
    buildingData.forEach((building) {
      if (searchText != ''){
        if (!building.toLowerString().contains(searchText.toLowerCase())) return;
      }
      Widget w = Card(
          color: areaColors[building.area],
          elevation: 3.0,
          child: ListTile(
            leading: _getLeading(building.abbv),
            title: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0, 3.0),
                  child: Text(building.name),
                ),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 2.0, color: colorThemeLight))),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 2.0, 0, 2.0),
                  child: Text(building.distance != null ? building.distance > 1 ? building.distance.toStringAsFixed(2) + ' km' : (building.distance*1000).toStringAsFixed(0) + ' m' : 'No Location Data'),
                ),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 1.5, color: colorThemeLight))),
              ),
            ),
            trailing: GestureDetector(
                onTap: () => launch('https://www.google.com/maps/search/?api=1&query=${building.latitude}%2C${building.longitude}'),
                child: Icon(Icons.map)
            ),
          )
      );
      widgets.add(w);
    });
    return widgets;
  }

  Widget _getLeading(String abbv){
    return Container(
      width: 45,
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Text(abbv,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  void _clearSearch(){
    _searchTextEditingController.clear();
    searchText = '';
    PageStorage.of(context).writeState(context, searchText, identifier: 'buildingSearchText');
  }
}