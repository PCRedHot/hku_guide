import 'dart:convert';

import 'package:hku_guide/tools/DataFetch.dart';
import 'package:hku_guide/tools/LocalDoc.dart';

Future<List> getBuildingData() async{
  final localVersion = await getBuildingVersionFromLocal();
  final onlineVersion = await fetchBuildingDataVersionFromAPI();

  print('Local Version: $localVersion');
  print('API Version: $onlineVersion');

  if (localVersion.compareTo(onlineVersion) != 0){
    writeBuildingVersionToLocal(onlineVersion);
    return updateBuildingData();
  }

  final localBuildingData = await getBuildingDataFromLocal();
  if (localBuildingData.isEmpty){
    print('File Empty');
    return updateBuildingData();
  }

  print('Get From File');
  return localBuildingData;
}

Future<List> updateBuildingData() async {
  print('Update Building Data From API');
  final onlineBuildingData = await fetchBuildingDataFromAPI();
  writeBuildingDataToLocal(onlineBuildingData);
  return jsonDecode(onlineBuildingData);
}

Future<Map> getClassData() async{
  final localVersion = await getClassVersionFromLocal();
  final onlineVersion = await fetchClassDataVersionFromAPI();

  print('Local Version: $localVersion');
  print('API Version: $onlineVersion');

  if (localVersion.compareTo(onlineVersion) != 0){
    writeClassVersionToLocal(onlineVersion);
    return updateClassData();
  }

  final localClassData = await getClassDataFromLocal();
  if (localClassData.isEmpty){
    print('File Empty');
    return updateClassData();
  }

  print('Get From File');
  return localClassData;
}

Future<Map> updateClassData() async {
  print('Update Class Data From API');
  final onlineClassData = await fetchClassDataFromAPI();
  writeClassDataToLocal(onlineClassData);
  return jsonDecode(onlineClassData);
}