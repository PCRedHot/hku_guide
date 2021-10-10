import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hku_guide/classes/DateTimeClasses.dart';
import 'package:hku_guide/classes/OnlineJsonClasses.dart';
import 'package:hku_guide/tools/DataManager.dart';


class HomePage extends StatefulWidget{
  HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  List<EnrolledClass> enrolledClasses;

  final Color colorThemeDark = Color.fromRGBO(58, 66, 86, 1.0);
  final Color colorThemeLight = Color.fromRGBO(68, 76, 96, 1.0);
  final Color colorThemeLighter = Color.fromRGBO(78, 86, 106, 1.0);

  @override
  void initState(){
    super.initState();

    enrolledClasses = PageStorage.of(context).readState(context, identifier: 'enrolledClasses');
    if (enrolledClasses == null){
      getEnrolledClassData().then((value) {
        enrolledClasses = value;
        PageStorage.of(context).writeState(context, enrolledClasses, identifier: 'enrolledClasses');

        //TODO remove below
        print(enrolledClasses.map((element) => element.title).toList());
        enrolledClasses.forEach((enrolledClass){
          CustomPeriodTime period = enrolledClass.getLessonPeriodOnDate(CustomDate.fromString('2021-10-18'));
          if (period != null) print("${enrolledClass.title}: $period");
        });
      });
    }//TODO remove below
    else{
      print(enrolledClasses.map((element) => element.title).toList());
      enrolledClasses.forEach((enrolledClass){
        CustomPeriodTime period = enrolledClass.getLessonPeriodOnDate(CustomDate.fromString('2021-10-18'));
        if (period != null) print("${enrolledClass.title}: $period");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getTimetableCarouselWidget(),
        ],
      ),
    );
  }


  Widget _getTimetableCarouselWidget(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 3.5,
          initialPage: 0,
          viewportFraction: 1.0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 10),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale
        ),
        items: [
          _getAcademicCalendarWidget(),
          _getTimetableWidget(),
        ],
      ),
    );
  }

  Widget _getAcademicCalendarWidget(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/calendar_widget.png'),
            fit: BoxFit.fitWidth
        ),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Academic\n    Calendar',
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Colors.deepOrangeAccent,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: colorThemeDark,
                  blurRadius: 6,
                  offset: Offset(-2, 2),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }

  String getComingThreeSchedulesString(List<EnrolledClass> enrolledClasses){

  }

  Widget _getTimetableWidget(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: colorThemeDark,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 40.0, 20.0),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text('My Coming Schedule',
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: Color.fromRGBO(246, 239, 238, 1.0),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 5,
                          offset: Offset(-2, 2),
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}