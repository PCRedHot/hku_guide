/**
class Version{
  final String version;

  Version({this.version});

  factory Version.fromJson(Map<String, dynamic> json){
    return Version(
        version: json['version']
    );
  }
}
 **/

class Building {
  final String abbv;
  final String name;
  final String area;

  Building({this.abbv, this.name, this.area});


  factory Building.fromJson(Map<String, dynamic> json){
    return Building(
      abbv: json['abbv'],
      name: json['name'],
      area: json['area'],
    );
  }
}