import 'package:flutter/material.dart';
import 'main_components/PageFrame.dart';
import 'main_components/TopBar.dart';
import 'main_components/BottomBar.dart';

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
        child: Scaffold(body: Main(title: 'Home')),
      )
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final PageController controller = PageController(initialPage: 2);
  int currentPage = 2;

  void changePage(int index){
    controller.jumpToPage(index);
    currentPage = index;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TopBar(),
        Expanded(child: PageFrame(controller:controller),),
        BottomBar(changePage: changePage),
      ]
    );
  }
}
