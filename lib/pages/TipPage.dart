import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TipPage extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 7/9,
            initialPage: 0,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale
        ),
        items: _getTipsWidgets(),
      ),
    );
  }

  List<Widget> _getTipsWidgets(){
    return [
      ['bad_weather.png', 'http://www.exam.hku.hk/a2_badweather.php'],
      ['cc_queue.png', 'https://sweb.hku.hk/ccacad/ccc_appl/enrol_stat.html'],
      ['important_date.png', 'https://aao.hku.hk/important-academic-dates/'],
    ].map((item) =>
        GestureDetector(
          onTap: (){launch(item[1]);},
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/${item[0]}'),
                    fit: BoxFit.cover
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
          ),
        )
    ).toList();
  }
}
