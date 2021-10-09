

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

    return this.isLaterThanOrEqual(d1) && this.isEarlierThanOrEqual(d2);
  }
}