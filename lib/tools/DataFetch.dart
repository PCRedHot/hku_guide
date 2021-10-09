import 'dart:convert';

import 'package:http/http.dart' as http;

final String buildingURL = "https://pcredhot.github.io/hku_guide/building.json";
final String buildingVersionURL = "https://pcredhot.github.io/hku_guide/building_version.json";
final String classURL = "https://pcredhot.github.io/hku_guide/timetable.json";
final String classVersionURL = "https://pcredhot.github.io/hku_guide/timetable_version.json";

Future<String> fetchBuildingDataVersionFromAPI() async{
  final response = await http.get(
    Uri.parse(buildingVersionURL)
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['version'];
  } else {
    return '';
  }
}

Future<String> fetchBuildingDataFromAPI() async{
  final response = await http.get(
      Uri.parse(buildingURL)
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "";
  }
}

Future<String> fetchClassDataVersionFromAPI() async{
  final response = await http.get(
      Uri.parse(classVersionURL)
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['version'];
  } else {
    return '';
  }
}

Future<String> fetchClassDataFromAPI() async{
  final response = await http.get(
      Uri.parse(classURL)
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "";
  }
}