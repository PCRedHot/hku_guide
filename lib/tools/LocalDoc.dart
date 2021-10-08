import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';


final String buildingVersionFile = 'building_version.txt';
final String buildingFile = 'building.txt';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> getLocalFile(String fileName) async {
  final path = await _localPath;
  return File('$path/'+fileName);
}

Future<File> writeFile(File f, String content) async{
  return f.writeAsString(content);
}

Future<File> writeFileWithName(String fileName, String content) async{
  final file = await getLocalFile(fileName);
  return await writeFile(file, content);
}

Future<String> readFile(String fileName) async{
  try{
    final file = await getLocalFile(fileName);
    final contents = await file.readAsString();
    return contents;
  } catch (e){
    return "";
  }
}

Future<String> getBuildingVersionFromLocal() async{
  try{
    final file = await getLocalFile(buildingVersionFile);
    final contents = await file.readAsString();
    return contents;
  } catch (e){
    return "";
  }
}

Future<void> writeBuildingVersionToLocal(String version) async{
  writeFileWithName(buildingVersionFile, version);
}

Future<List> getBuildingDataFromLocal() async{
  try{
    final file = await getLocalFile(buildingFile);
    final contents = await file.readAsString();
    return jsonDecode(contents);
  } catch (e){
    return [];
  }
}

Future<void> writeBuildingDataToLocal(String data) async{
  writeFileWithName(buildingFile, data);
}

Future<void> writeBuildingDataToLocalWithList(List data) async{
  writeBuildingDataToLocal(jsonEncode(data));
}
