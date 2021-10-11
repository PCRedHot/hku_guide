import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hku_guide/classes/DateTimeClasses.dart';
import 'package:hku_guide/classes/OnlineJsonClasses.dart';
import 'package:hku_guide/tools/DataFetch.dart';
import 'package:hku_guide/tools/DataManager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blur/blur.dart';


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
        print(getScheduleStringOnDate(CustomDate.today()));
      });
    }//TODO remove below
    else{
      print(enrolledClasses.map((element) => element.title).toList());
      print(getScheduleStringOnDate(CustomDate.today()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _getRows(),
    );
  }

  List<Widget> _getRows(){
    return [
      _getTimetableCarouselWidget(),
      _getDividerWidget(),
      Expanded(child: _getLinkGridView()),
    ];
  }

  Widget _getDividerWidget(){
    Color c = Color.fromRGBO(230, 230, 230, 0.9);
    Divider d = Divider(thickness: 1.5, color: c);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
      child: d,
    );
  }

  Widget _getLinkGridView(){
    return GridView.count(
      crossAxisCount: 4,
      childAspectRatio: 5/7,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 8.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: _getLinkWidgets(),
      physics: NeverScrollableScrollPhysics(),
    );
  }


  List<Widget> _getLinkWidgets(){
    //.blurred(blur: 1.0, colorOpacity: 0.2, borderRadius: BorderRadius.circular(15.0),)
    return [
      [
        Color.fromRGBO(109, 188, 47, 1.0),
        Image.asset('assets/images/university.png', fit: BoxFit.cover,),
        'HKU', 'https://www.hku.hk/'
      ],
      [
        Color.fromRGBO(109, 188, 47, 1.0),
        Image.asset('assets/images/university.png', fit: BoxFit.cover,).blurred(
            blur: 1.3,
            colorOpacity: 0.1,
            borderRadius: BorderRadius.circular(15.0),
            overlay: Text('Portal',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(230, 230, 230, 1.0),
                shadows: [
                  Shadow(
                    offset: Offset(-1, 1),
                    blurRadius: 5.0
                  ),
                  Shadow(
                      offset: Offset(0.5, -0.5),
                      blurRadius: 5.0
                  )
                ]
              ),
            )
        ),
        'HKU Portal', 'https://hkuportal.hku.hk/'
      ],
      [
        Color.fromRGBO(109, 188, 47, 1.0),
        Image.asset('assets/images/university.png', fit: BoxFit.cover,).blurred(
            blur: 1.3,
            colorOpacity: 0.1,
            borderRadius: BorderRadius.circular(15.0),
            overlay: Text('Moodle',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(230, 230, 230, 1.0),
                  shadows: [
                    Shadow(
                        offset: Offset(-1, 1),
                        blurRadius: 5.0
                    ),
                    Shadow(
                        offset: Offset(0.5, -0.5),
                        blurRadius: 5.0
                    )
                  ]
              ),
            )
        ),
        'Moodle', 'https://moodle.hku.hk/'
      ],
      [
        Color.fromRGBO(255, 255, 255, 1.0),
        Image.asset('assets/images/university.png', fit: BoxFit.cover,).blurred(
            blur: 1.3,
            colorOpacity: 0.1,
            borderRadius: BorderRadius.circular(15.0),
            overlay: Text('Library',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(230, 230, 230, 1.0),
                  shadows: [
                    Shadow(
                        offset: Offset(-1, 1),
                        blurRadius: 5.0
                    ),
                    Shadow(
                        offset: Offset(0.5, -0.5),
                        blurRadius: 5.0
                    )
                  ]
              ),
            )
        ),
        'Library', 'https://lib.hku.hk/index.html'
      ],
      [
        Color.fromRGBO(201, 238, 246, 1.0),
        Image.asset('assets/images/cedars.png', fit: BoxFit.cover,),
        'CEDARS', 'https://www.cedars.hku.hk/'
      ],
      [
        Color.fromRGBO(255, 255, 255, 1.0),
        Image.asset('assets/images/aao.png', fit: BoxFit.cover,),
        'AAO', 'https://aao.hku.hk/'
      ],
      [
        Color.fromRGBO(47, 71, 177, 1.0),
        Image.asset('assets/images/cc.png', fit: BoxFit.cover,),
        'Common Core', 'https://commoncore.hku.hk/'
      ],
      [
        Color.fromRGBO(255, 255, 255, 1.0),
        Image.asset('assets/images/net_jobs.png', fit: BoxFit.cover,),
        'NETjobs', 'https://web2.cedars.hku.hk:4181/jobs/main.php'
      ],
    ].map((item) =>
      Column(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {launch(item[3]);},
              child: Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  semanticContainer: true,
                  elevation: 5.0,
                  color: item[0],
                  child: item[1],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(item[2],
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(240, 240, 240, 1.0),
                fontSize: 15.0,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      )
    ).toList();
  }

  Widget _getTimetableCarouselWidget(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150,
          //aspectRatio: 3.5,
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
    return GestureDetector(
      onTap: _showAcademicCalendar,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/calendar_widget.png'),
              fit: BoxFit.cover
          ),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Academic\n     Calendar',
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: colorThemeDark,
                    blurRadius: 8,
                    offset: Offset(-2, 2),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Today\'s Schedule',
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
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(getScheduleStringOnDate(CustomDate.today()).map((e) => e = '- $e').toList().join('\n'),
                    style: TextStyle(
                      color: Color.fromRGBO(240, 236, 232, 1.0),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  List<String> getScheduleStringOnDate(CustomDate d){
    if (enrolledClasses == null) return [];
    List stringAndTime = [];
    enrolledClasses.forEach((ec) {
      List lesson = ec.getLessonOnDate(d);
      if (lesson == null) return;
      stringAndTime.add(['${ec.courseCode}: ${lesson[1].period.toString()} ${lesson[0].venue == '' ? '' : 'at ${lesson[0].venue}'}', lesson[1].period]);
    });
    stringAndTime.sort((a, b) => a[1].compareTo(b[1]));
    return stringAndTime.map((e) => e[0] as String).toList();
  }

  void _showAcademicCalendar() async{
    launch(await getCalendarURLString());
  }
}