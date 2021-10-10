import 'package:flutter/material.dart';
import 'package:hku_guide/pages/ClassPage.dart';
import 'pages/BuildingPage.dart';
import 'pages/HomePage.dart';
import 'pages/SettingPage.dart';
import 'pages/TipPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HKU Guide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(
        child: Main(title: 'Home',),
      )
    );
  }
}

final bucketGlobal = PageStorageBucket();

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  Color colorThemeDark = Color.fromRGBO(58, 66, 86, 1.0);
  Color colorThemeLight = Color.fromRGBO(68, 76, 96, 1.0);
  int _selectedIndex = 2;
  List pages;

  @override
  void initState() {
    super.initState();
    pages = [ClassPage(key: PageStorageKey<String>('ClassPage')), BuildingPage(key: PageStorageKey<String>('BuildingPage'), ), HomePage(), TipPage(), SettingPage()];
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      drawer: getDrawer(),
      bottomNavigationBar: getBottomNavigationBar(),
      body: SafeArea(
        child: PageStorage(
          bucket: bucketGlobal,
          child: pages[_selectedIndex],
        ),
      ),
      backgroundColor: colorThemeLight,
    );
  }

  AppBar getAppBar(){
    return AppBar(
        title: Text('HKU Guide'),
        backgroundColor: colorThemeDark,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 17.0, color: Colors.white),
    );
  }

  Drawer getDrawer(){
    return Drawer();
  }

  BottomNavigationBar getBottomNavigationBar(){
    Color unselectedColor = Color.fromRGBO(240, 240, 240, 0.7);
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Courses',),
        BottomNavigationBarItem(icon: Icon(Icons.location_city_outlined), label: 'Buildings',),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
        BottomNavigationBarItem(icon: Icon(Icons.wb_incandescent_outlined), label: 'Tips'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      backgroundColor: colorThemeDark,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      unselectedItemColor: unselectedColor,
      fixedColor: Colors.white,
      onTap: _onItemTapped,
    );
  }
}
