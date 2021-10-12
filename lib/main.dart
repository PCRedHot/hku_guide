import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hku_guide/pages/ClassPage.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Timer changeFlutterLogoTimer;
  bool isFlutterLogoHorizontal = true;

  double padValue = 0;

  @override
  void initState() {
    super.initState();
    pages = [ClassPage(key: PageStorageKey<String>('ClassPage')), BuildingPage(key: PageStorageKey<String>('BuildingPage'), ), HomePage(), TipPage(), SettingPage()];
    changeFlutterLogoTimer = Timer.periodic(Duration(seconds: 6), (Timer t) => setState(() {
      isFlutterLogoHorizontal = !isFlutterLogoHorizontal;
      if (isFlutterLogoHorizontal) padValue = 0;
      else padValue = 40;
    }));
  }

  @override
  void dispose() {
    super.dispose();
    changeFlutterLogoTimer.cancel();
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

  Widget getDrawer(){
    TextStyle itemTS = TextStyle(color: Color.fromRGBO(230, 230, 230, 1.0), fontSize: 20, fontWeight: FontWeight.w300);
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: colorThemeLight.withAlpha(200),
      ),
      child: Drawer(
       child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0))
              ),
              child: Column(
                  children: [
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              image: DecorationImage(image: AssetImage('assets/images/university.png'),fit: BoxFit.scaleDown)
                          ),
                        )
                    ),
                    Text('HKU Guide',
                      style: TextStyle(
                          color: Color.fromRGBO(240, 240, 240, 1.0),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(-3,3),
                              blurRadius: 3,
                              color: Color.fromRGBO(20, 20, 20, 1),
                            )
                          ]
                      ),
                    ),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ListTile(
                title: Align(alignment: Alignment.center,
                    child: Text('Contact Us', style: itemTS,)
                ),
                onTap: () {launch('mailto:pcredhot@connect.hku.hk'); },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: ListTile(
                title: Align(alignment: Alignment.center,
                    child: Text('About This App', style: itemTS,)
                ),
                onTap: () {
                  showAboutDialog(context: context,
                      applicationVersion: '1.0',
                      applicationIcon: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/university.png'),fit: BoxFit.cover)
                        ),
                      ),
                      children: [
                        Text('HKU Guide is made by PCRedHot')
                      ]
                  );
                },
              ),
            ),
            Spacer(),
            AnimatedPadding(
              padding: EdgeInsets.fromLTRB(0,0,0,padValue),
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Powered by', style: TextStyle(color: Color.fromRGBO(240, 240, 240, 1.0), fontSize: 15),),
                  ),
                  FlutterLogo(size: isFlutterLogoHorizontal ? 120 : 50, style: isFlutterLogoHorizontal ? FlutterLogoStyle.horizontal : FlutterLogoStyle.markOnly, curve: Curves.easeInOut, textColor: Color.fromRGBO(240, 240, 240, 1.0), duration: Duration(seconds: 1),)
                ],
              ),
            )
          ],
        )
      ),
    );
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
