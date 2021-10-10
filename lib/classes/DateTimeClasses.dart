
extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return this.add(
      Duration(
        days: (day - this.weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}

DateTime getDateTimeFromCustomDate(CustomDate d) => DateTime.parse(d.toString());

class CustomDate {
  int year;
  int month;
  int day;

  CustomDate({this.year, this.month, this.day});

  factory CustomDate.fromString(String string){
    List<String> component = string.split('-');
    return CustomDate(
      year: int.parse(component[0]),
      month: int.parse(component[1]),
      day: int.parse(component[2]),
    );
  }

  factory CustomDate.fromDateTime(DateTime dt) => CustomDate(
    year: dt.year,
    month: dt.month,
    day: dt.day,
  );

  factory CustomDate.today() => CustomDate.fromDateTime(DateTime.now());
  //factory CustomDate.today() => CustomDate.fromString('2021-10-18');

  bool isLaterThan(CustomDate d){
    if (this.year > d.year) return true;
    if (this.year < d.year) return false;
    if (this.month > d.month) return true;
    if (this.month < d.month) return false;
    if (this.day > d.day) return true;
    return false;
  }

  bool isLaterThanOrEqual(CustomDate d){
    if (this.year > d.year) return true;
    if (this.year < d.year) return false;
    if (this.month > d.month) return true;
    if (this.month < d.month) return false;
    if (this.day >= d.day) return true;
    return false;
  }

  bool isEarlierThan(CustomDate d){
    if (this.year > d.year) return false;
    if (this.year < d.year) return true;
    if (this.month > d.month) return false;
    if (this.month < d.month) return true;
    if (this.day >= d.day) return false;
    return true;
  }

  bool isEarlierThanOrEqual(CustomDate d){
    if (this.year > d.year) return false;
    if (this.year < d.year) return true;
    if (this.month > d.month) return false;
    if (this.month < d.month) return true;
    if (this.day > d.day) return false;
    return true;
  }

  bool isBetweenOrEqual(CustomDate d1, CustomDate d2){
    CustomDate lateDate;
    CustomDate earlyDate;

    if (d2.isLaterThan(d1)){
      lateDate = d2;
      earlyDate = d1;
    }else{
      lateDate = d1;
      earlyDate = d2;
    }

    return this.isLaterThanOrEqual(earlyDate) && this.isEarlierThanOrEqual(lateDate);
  }
  
  @override
  String toString() {
    return year.toString()+'-'+month.toString().padLeft(2, '0')+'-'+day.toString().padLeft(2, '0');
  }

  @override
  bool operator ==(Object other) {
    if (!(other is CustomDate)) return false;
    CustomDate o = other;
    return this.year == o.year && this.month == o.month && this.day == o.day;
  }

  @override
  int get hashCode => super.hashCode;

}

class CustomTime {
  int hour, min;

  CustomTime(this.hour, this.min);

  factory CustomTime.parse(String str){
    if (str == '' || str == null) return CustomTime(null, null);
    List<String> listStr = str.split(':');
    try{
      return CustomTime(int.parse(listStr[0]), int.parse(listStr[1]));
    }catch (e){
      return CustomTime(null, null);
    }
  }

  factory CustomTime.fromDateTime(DateTime dt) => CustomTime(dt.hour, dt.minute);

  bool isLaterOrEqualTo(CustomTime t){
    if (this.hour > t.hour) return true;
    return this.min >= t.min;
  }

  bool isLater(CustomTime t){
    if (this.hour > t.hour) return true;
    return this.min >= t.min;
  }

  @override
  String toString() {
    if (hour == null || min == null) return '';
    return hour.toString().padLeft(2, '0') + ':' + min.toString().padLeft(2, '0');
  }

  @override
  bool operator ==(Object other) {
    if (!(other is CustomTime)) return false;
    CustomTime o = other;
    return (this.hour == o.hour && this.min == o.min);
  }

  @override
  int get hashCode => super.hashCode;

  String toJson() => this.toString();

}

class CustomPeriodTime {
  CustomTime startTime, endTime;

  CustomPeriodTime(this.startTime, this.endTime);

  factory CustomPeriodTime.fromStrings(String startTime, String endTime){
    return CustomPeriodTime(CustomTime.parse(startTime), CustomTime.parse(endTime));
  }

  int compareTo(CustomPeriodTime p){
    if (this.startTime.isLater(p.startTime)) return 1;
    if (p.startTime.isLater(this.startTime)) return -1;
    return this.endTime.isLater(p.endTime) ? 1 : -1;
  }

  bool isLaterOrBetween(CustomTime t){
    return endTime.isLaterOrEqualTo(t);
  }

  @override
  String toString() {
    return this.startTime.toString() + ' - ' + this.endTime.toString();
  }

  @override
  bool operator ==(Object other) {
    if (!(other is CustomPeriodTime)) return false;
    CustomPeriodTime o = other;
    return (this.startTime == o.startTime && this.endTime == o.endTime);
  }

  @override
  int get hashCode => super.hashCode;

  Map<String, dynamic> toJson() => {
    'start_time': startTime.toJson(),
    'end_time': endTime.toJson(),
  };

}