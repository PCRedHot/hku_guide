import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hku_guide/classes/OnlineJsonClasses.dart';
import 'package:hku_guide/tools/DataManager.dart';
import 'package:hku_guide/tools/ExtensionTool.dart';


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


  final List<Color> colorClasses = [
    Color.fromRGBO(112, 225, 201, 1.0),
    Color.fromRGBO(0, 240, 223, 1.0),
    Color.fromRGBO(0, 223, 241, 1.0),
    Color.fromRGBO(0, 182, 249, 1.0),
    Color.fromRGBO(12, 170, 254, 1.0),
    Color.fromRGBO(56, 157, 255, 1.0),
    Color.fromRGBO(130, 131, 225, 1.0),
    Color.fromRGBO(171, 115, 255, 1.0),
    Color.fromRGBO(211, 90, 250, 1.0),
  ];


  @override
  void initState() {
    super.initState();

    // Load Class Data
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
      Widget widget = GestureDetector(
        onTap: () {_openClassInfoDialog(course);},
        child: Card(
          color: course.courseCode.firstNumber == null || course.courseCode.firstNumber == 0 ? Colors.white : colorClasses[course.courseCode.firstNumber-1],
          child: ListTile(
            title: Text(course.courseCode + ': ' + course.title),
          ),
        )
      );

      widgets.add(widget);
    });
    return widgets;
  }

  void _openClassInfoDialog(Class course){
    showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text(course.toString()),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: _getSubclassWidgets(course),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  List<Widget> _getSubclassWidgets(Class course){
    List<Widget> widgets = [];
    course.subclasses.forEach((subclass) {
      widgets.add(
        GestureDetector(
          onTap: () {_onTapSubclassWidget(course, subclass);},
          child: Card(
            elevation: 1.5,
            color: Color.fromRGBO(250, 250, 250, 1.0),
            child: ListTile(
              title: Text(course.courseCode+'_'+subclass.subclassCode),
              subtitle: Text(subclass.term + '\n' + subclass.briefTime + '\n' + subclass.briefInstructors),
              isThreeLine: true,
              contentPadding: const EdgeInsets.all(10.0),

            ),
          ),
        )
      );
    });
    return widgets;
  }

  void _onTapSubclassWidget(Class course, Subclass subclass){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('${course.courseCode}_${subclass.subclassCode}: ${course.title}'),
          content: Text('Add this course to my enrolled courses'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _addEnrolledClass(course, subclass);
                },
                child: const Text('Add')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No')),
          ],
        );
      }
    );
  }

  void _addEnrolledClass(Class course, Subclass subclass){
    List<EnrolledClass> enrolledClasses = PageStorage.of(context).readState(context, identifier: 'enrolledClasses');
    if (enrolledClasses == null) enrolledClasses = [];
    EnrolledClass enrolledClass = EnrolledClass.fromClassAndSubclass(course, subclass);
    if (enrolledClasses.contains(enrolledClass)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Already Added ${course.courseCode}: ${course.title} Before!')));
      return;
    }
    enrolledClasses.add(enrolledClass);
    PageStorage.of(context).writeState(context, enrolledClasses, identifier: 'enrolledClasses');
    updateEnrolledClassData(enrolledClasses);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${course.courseCode}: ${course.title} To Enrolled Courses!')));
  }

  void _clearSearch(){
    _searchTextEditingController.clear();
    searchText = '';
    PageStorage.of(context).writeState(context, searchText, identifier: 'classSearchText');
  }
}