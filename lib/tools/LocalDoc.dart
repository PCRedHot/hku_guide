import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hku_guide/classes/AppSettingClass.dart';
import 'package:hku_guide/classes/OnlineJsonClasses.dart';
import 'package:path_provider/path_provider.dart';


final String buildingVersionFile = 'building_version.txt';
final String buildingFile = 'building.txt';
final String classVersionFile = 'class_version.txt';
final String classFile = 'class.txt';
final String enrolledClassFile = 'enrolledClass.txt';
final String appSettingFile = 'appSetting.txt';

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

Future<String> getClassVersionFromLocal() async{
  try{
    final file = await getLocalFile(classVersionFile);
    final contents = await file.readAsString();
    return contents;
  } catch (e){
    return "";
  }
}

Future<void> writeClassVersionToLocal(String version) async{
  writeFileWithName(classVersionFile, version);
}

Future<Map> getClassDataFromLocal() async{
  try{
    final file = await getLocalFile(classFile);
    final contents = await file.readAsString();
    return jsonDecode(contents);
  } catch (e){
    return Map();
  }
}

void writeClassDataToLocal(String data) => writeFileWithName(classFile, data);

Future<List<EnrolledClass>> getEnrolledClassesFromLocal() async{
  try{
    final file = await getLocalFile(enrolledClassFile);
    final contents = await file.readAsString();
    List<dynamic> jsonObjects = jsonDecode(contents);
    return jsonObjects.map((e) => EnrolledClass.fromJson(e)).toList();
  } catch (e){
    return [];
  }
}

void writeEnrolledClassesToLocal(List<EnrolledClass> enrolledClasses) =>
    writeFileWithName(enrolledClassFile, jsonEncode(enrolledClasses.map((e) => e.toJson()).toList()));

Future<AppSetting> getAppSettingFromLocal() async{
  try{
    final file = await getLocalFile(appSettingFile);
    final contents = await file.readAsString();
    Map jsonObject = jsonDecode(contents);
    return AppSetting.fromJson(jsonObject);
  } catch (e){
    return AppSetting.defaultSetting();
  }
}

void writeAppSettingToLocal(AppSetting appSetting) =>
    writeFileWithName(appSettingFile, jsonEncode(appSetting.toJson()));