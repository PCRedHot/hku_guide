

import 'DateTimeClasses.dart';

class Building {
  final String abbv;
  final String name;
  final String area;
  final double latitude;
  final double longitude;
  double distance;

  Building({this.abbv, this.name, this.area, this.latitude, this.longitude});


  factory Building.fromJson(Map<String, dynamic> json){
    return Building(
      abbv: json['abbv'],
      name: json['name'],
      area: json['area'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
    );
  }

  String toLowerString() => abbv.toLowerCase() + ': ' + name.toLowerCase();
}

class Timeslot {
  final CustomDate startDate;
  final CustomDate endDate;
  final bool mon;
  final bool tue;
  final bool wed;
  final bool thu;
  final bool fri;
  final bool sat;
  final bool sun;
  final String venue;
  final String startTime;
  final String endTime;

  Timeslot({this.startDate, this.endDate, this.mon, this.tue, this.wed, this.thu, this.fri, this.sat, this.sun, this.venue, this.startTime, this.endTime});

  factory Timeslot.fromJson(Map<String, dynamic> json){
    return Timeslot(
      startDate: CustomDate.fromString(json['start_date']),
      endDate: CustomDate.fromString(json['end_date']),
      mon: json['mon'],
      tue: json['tue'],
      wed: json['wed'],
      thu: json['thu'],
      fri: json['fri'],
      sat: json['sat'],
      sun: json['sun'],
      venue: json['venue'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}

class Subclass {
  final String subclassCode;
  final String term;
  final List<String> instructors;
  final List<Timeslot> timeslots;

  Subclass({this.subclassCode, this.term, this.instructors, this.timeslots});

  factory Subclass.fromJson(String subclassCode, Map<String, dynamic> json){
    List<Timeslot> timeslots = [];
    json['time'].forEach((timeslotJson) => timeslots.add(Timeslot.fromJson(timeslotJson)));

    List<String> instructors = json['instructor'].split(';');
    return Subclass(
      subclassCode: subclassCode,
      term: json['term'],
      instructors: instructors,
      timeslots: timeslots
    );
  }
}

class Class {
  final String courseCode;
  final String career;
  final String title;
  final String dept;
  final List<Subclass> subclasses;

  Class({this.courseCode, this.career, this.title, this.dept, this.subclasses});

  factory Class.fromJson(String courseCode, Map<String, dynamic> json){
    List<Subclass> subclasses = [];
    json['subclasses'].forEach((subclassCode, subclassJson) => subclasses.add(Subclass.fromJson(subclassCode, subclassJson)));
    return Class(
      courseCode: courseCode,
      career: json['career'],
      title: json['title'],
      dept: json['dept'],
      subclasses: subclasses,
    );
  }

  String toLowerString() => this.courseCode.toLowerCase() + ': ' + this.title;

}