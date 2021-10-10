

import 'package:flutter/foundation.dart';

import 'DateTimeClasses.dart';

enum Day {Mon, Tue, Wed, Thu, Fri, Sat, Sun}
extension DayExtension on Day {
  String get string => describeEnum(this);

  String toJson() => describeEnum(this).toLowerCase();
}

final Map<String, Day> stringToDay = {
  'mon': Day.Mon,
  'tue': Day.Tue,
  'wed': Day.Wed,
  'thu': Day.Thu,
  'fri': Day.Fri,
  'sat': Day.Sat,
  'sun': Day.Sun,
};

final Map<int, Day> dateTimeToDay = {
  DateTime.monday: Day.Mon,
  DateTime.tuesday: Day.Tue,
  DateTime.wednesday: Day.Wed,
  DateTime.thursday: Day.Thu,
  DateTime.friday: Day.Fri,
  DateTime.saturday: Day.Sat,
  DateTime.sunday: Day.Sun,
};

final Map<Day, int> dayToDateTime = {
  Day.Mon: DateTime.monday,
  Day.Tue: DateTime.tuesday,
  Day.Wed: DateTime.wednesday,
  Day.Thu: DateTime.thursday,
  Day.Fri: DateTime.friday,
  Day.Sat: DateTime.saturday,
  Day.Sun: DateTime.sunday,
};

Day getDayFromString(String s) => stringToDay[s];
Day getDayFromDateTime(DateTime dt) => stringToDay[dt.weekday];
int getDateTimeWeekdayFromDay(Day d) => dayToDateTime[d];


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

class Instructor {
  final String surname, lastName;

  Instructor({this.surname, this.lastName});

  factory Instructor.parse(String str){
    List<String> strList = str.split(',');
    return Instructor(
      surname: strList[0],
      lastName: strList[1],
    );
  }
}

class DayTimeslot {
  final List<CustomPeriodTime> periods;
  final Day day;

  DayTimeslot({this.periods, this.day});

  factory DayTimeslot.filter(Day day, List<Timeslot> timeslots){
    List<CustomPeriodTime> periods = [];
    timeslots.forEach((timeslot) {
      if (timeslot.day == day && !periods.contains(timeslot.period)) periods.add(timeslot.period);
    });
    periods.sort((CustomPeriodTime a, CustomPeriodTime b) => a.compareTo(b));
    return DayTimeslot(
      periods: periods,
      day: day,
    );
  }

}

class Timeslot {
  final CustomPeriodTime period;
  final Day day;

  Timeslot({this.period, this.day});

  factory Timeslot.fromString(Day day, String startTime, String endTime) =>
      Timeslot(
        day: day,
        period: CustomPeriodTime.fromStrings(startTime, endTime)
      );


  factory Timeslot.fromJson(dynamic json) => Timeslot(
        day: getDayFromString(json['day']),
        period: CustomPeriodTime.fromStrings(json['period']['start_time'], json['period']['end_time'])
    );



  bool hasLessonOnDate(CustomDate date){
    DateTime dtDate = getDateTimeFromCustomDate(date);
    return dtDate.weekday == getDateTimeWeekdayFromDay(this.day);
  }




  Map<String, dynamic> toJson() => {
    'period': period.toJson(),
    'day': day.toJson(),
  };
}

class LessonTime {
  final CustomDate startDate;
  final CustomDate endDate;
  final String venue;
  final List<Timeslot> timeslots;

  LessonTime({this.startDate, this.endDate, this.venue, this.timeslots});

  factory LessonTime.fromJson(Map<String, dynamic> json){
    List<Timeslot> timeslots = [];
    if (json['mon']) timeslots.add(Timeslot.fromString(Day.Mon, json['start_time'], json['end_time']));
    if (json['tue']) timeslots.add(Timeslot.fromString(Day.Tue, json['start_time'], json['end_time']));
    if (json['wed']) timeslots.add(Timeslot.fromString(Day.Wed, json['start_time'], json['end_time']));
    if (json['thu']) timeslots.add(Timeslot.fromString(Day.Thu, json['start_time'], json['end_time']));
    if (json['fri']) timeslots.add(Timeslot.fromString(Day.Fri, json['start_time'], json['end_time']));
    if (json['sat']) timeslots.add(Timeslot.fromString(Day.Sat, json['start_time'], json['end_time']));
    if (json['sun']) timeslots.add(Timeslot.fromString(Day.Sun, json['start_time'], json['end_time']));
    return LessonTime(
      startDate: CustomDate.fromString(json['start_date']),
      endDate: CustomDate.fromString(json['end_date']),
      venue: json['venue'],
      timeslots: timeslots,
    );
  }

  factory LessonTime.fromJson2(Map<String, dynamic> json) =>
      LessonTime(
        startDate: CustomDate.fromString(json['start_date']),
        endDate: CustomDate.fromString(json['end_date']),
        venue: json['venue'],
        timeslots: (json['timeslots'] as List<dynamic>).map((e) => Timeslot.fromJson(e)).toList(),
      );


  Map<String, dynamic> toJson() => {
    'start_date': startDate.toString(),
    'end_date': endDate.toString(),
    'venue': venue,
    'timeslots': timeslots.map((e) => e.toJson()).toList(),
  };


  bool isBetweenDate(CustomDate d) =>
    d.isBetweenOrEqual(startDate, endDate);


}

class Subclass {
  final String subclassCode;
  final String term;
  final List<String> instructors;
  final List<LessonTime> lessonTimes;

  Subclass({this.subclassCode, this.term, this.instructors, this.lessonTimes});

  factory Subclass.fromJson(String subclassCode, Map<String, dynamic> json){
    List<LessonTime> lessonTime = [];
    json['time'].forEach((timeslotJson) => lessonTime.add(LessonTime.fromJson(timeslotJson)));

    List<String> instructors = json['instructor'].split(';');
    return Subclass(
      subclassCode: subclassCode,
      term: json['term'],
      instructors: instructors,
      lessonTimes: lessonTime
    );
  }

  List<Timeslot> get allTimeslots {
    List<Timeslot> timeslots = [];
    this.lessonTimes.forEach((lessonTime) => timeslots.addAll(lessonTime.timeslots));
    return timeslots;
  }

  List<String> get venues {
    List<String> rtn = [];
    this.lessonTimes.forEach((timeslot) {
      if (!rtn.contains(timeslot.venue)) rtn.add(timeslot.venue);
    });
    return rtn;
  }

  String get briefTime {
    List<Timeslot> allTimeslots = this.allTimeslots;
    List<DayTimeslot> dayTimeslots = [];
    Day.values.forEach((day) => dayTimeslots.add(DayTimeslot.filter(day, allTimeslots)));

    String briefTime = '';
    dayTimeslots.forEach((dayTimeslot) {
      if (dayTimeslot.periods.isEmpty) return;
      if (briefTime != '') briefTime += '\n';
      briefTime += dayTimeslot.day.string + '\t';
      dayTimeslot.periods.forEach((period) => briefTime += ' ' + period.toString());
    });
    return briefTime;
  }

  String get briefInstructors {
    String rtn = '';
    instructors.forEach((instructor) {
      if (rtn != '') rtn += ';';
      rtn += instructor.replaceAll(',', ', ');
    });
    return rtn;
  }

}

class Class {
  final String courseCode, career, title, dept;
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

  String toString() => this.courseCode + ': ' + this.title;

  String toLowerString() => this.courseCode.toLowerCase() + ': ' + this.title.toLowerCase();

}

class EnrolledClass {
  final String courseCode, career, title, dept, subclassCode, term;
  final List<String> instructors;
  final List<LessonTime> lessonTimes;

  EnrolledClass({this.courseCode, this.career, this.title, this.dept, this.subclassCode, this.term, this.instructors, this.lessonTimes});

  factory EnrolledClass.fromClassAndSubclass(Class c, Subclass s) {
    return EnrolledClass(
      courseCode: c.courseCode,
      career: c.career,
      title: c.title,
      dept: c.dept,
      subclassCode: s.subclassCode,
      term: s.term,
      instructors: s.instructors,
      lessonTimes: s.lessonTimes,
    );
  }

  factory EnrolledClass.fromJson(Map json){
    return EnrolledClass(
        courseCode: json['courseCode'],
        career: json['career'],
        title: json['title'],
        dept: json['dept'],
        subclassCode: json['subclassCode'],
        term: json['term'],
        instructors: (json['instructors'] as String).split('; '),
        lessonTimes: (json['lessonTimes'] as List<dynamic>).map((e) => LessonTime.fromJson2(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'courseCode': courseCode,
    'career': career,
    'title': title,
    'dept': dept,
    'subclassCode': subclassCode,
    'term': term,
    'instructors': instructors.join(';'),
    'lessonTimes': lessonTimes.map((e) => e.toJson()).toList()
  };

   List getLessonOnDate(CustomDate date){

    List<LessonTime> validLessonTimes = [];
    this.lessonTimes.forEach((lt) {
      //if (lt.isBetweenDate(CustomDate.fromDateTime(DateTime.now())))
      if (lt.isBetweenDate(date)) validLessonTimes.add(lt);
    });

    List validTimeslots = [];
    validLessonTimes.forEach((lt) {
      lt.timeslots.forEach((ts) {
        if (ts.hasLessonOnDate(date)) validTimeslots.add([lt, ts]);
      });
    });

    assert(validTimeslots.length <= 1);
    if (validTimeslots.length == 0) return null;
    return validTimeslots[0];
  }

  @override
  bool operator ==(Object other) {
    if (!(other is EnrolledClass)) return false;
    EnrolledClass o = other;
    return this.courseCode == o.courseCode && this.subclassCode == o.subclassCode;
  }

  @override
  int get hashCode => super.hashCode;
}