import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hku_guide/classes/OnlineJsonClasses.dart';
import 'package:hku_guide/tools/DataManager.dart';


class ClassPage extends StatefulWidget{
  ClassPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage>{

  List<Class> classData;

  TextEditingController _searchTextEditingController;
  String searchText = '';

  final Color colorThemeDark = Color.fromRGBO(58, 66, 86, 1.0);
  final Color colorThemeLight = Color.fromRGBO(68, 76, 96, 1.0);
  final Color colorThemeLighter = Color.fromRGBO(78, 86, 106, 1.0);

  @override
  void initState() {
    super.initState();
    if (PageStorage.of(context).readState(context, identifier: 'classData') != null){
      setState(() {
        classData = PageStorage.of(context).readState(context, identifier: 'classData');
      });
    }else{
      getClassData().then((data) {
        setState(() {
          classData = [];
          data.forEach((courseCode, json) => classData.add(Class.fromJson(courseCode, json)));
          PageStorage.of(context).writeState(context, classData, identifier: 'classData');
        });
      });
    }

    // Initialise Search Bar Controller
    _searchTextEditingController = TextEditingController();
    _searchTextEditingController.addListener(() {
      setState(() {
        searchText = _searchTextEditingController.value.text;
        PageStorage.of(context).writeState(context, searchText, identifier: 'classSearchText');
      });
    });
    searchText = PageStorage.of(context).readState(context, identifier: 'classSearchText') ?? '';
    _searchTextEditingController.value = _searchTextEditingController.value.copyWith(
        text: searchText
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (classData == null){
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
              ),
              filled: true,
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
              children: _getClassWidgets(),
            ),
          ),
        ),
      ],
    );
  }


  List<Widget> _getClassWidgets(){
    List<Widget> widgets = [];
    classData.forEach((course) {
      if (searchText != ''){
        if (!course.toLowerString().contains(searchText.toLowerCase())) return;
      }
      Widget widget = Card(
        child: ListTile(
          title: Text(course.courseCode + ': ' + course.title),
        ),
      );
      widgets.add(widget);
    });
    return widgets;
  }

  void _clearSearch(){
    _searchTextEditingController.clear();
    searchText = '';
    PageStorage.of(context).writeState(context, searchText, identifier: 'classSearchText');
  }
}