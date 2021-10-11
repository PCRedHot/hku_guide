import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
            autoPlayInterval: Duration(seconds: 10),
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
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bad_weather.png'),
            fit: BoxFit.cover
            ),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
      ),
    ];
  }
}
