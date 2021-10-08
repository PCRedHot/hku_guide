import 'dart:convert';

import 'package:http/http.dart' as http;

final String buildingURL = "https://pcredhot.github.io/hku_guide/building.json";
final String buildingVersionURL = "https://pcredhot.github.io/hku_guide/building_version.json";

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

Future<List> fetchBuildingDataFromAPI() async{
  final response = await http.get(
      Uri.parse(buildingURL)
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return [];
  }
}