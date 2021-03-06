import 'dart:convert';

import 'package:hku_guide/classes/AppSettingClass.dart';
import 'package:hku_guide/classes/OnlineJsonClasses.dart';
import 'package:hku_guide/tools/DataFetch.dart';
import 'package:hku_guide/tools/LocalDoc.dart';

Future<List> getBuildingData() async{
  try{
    final localVersion = await getBuildingVersionFromLocal();
    final onlineVersion = await fetchBuildingDataVersionFromAPI();

    print('Local Version: $localVersion');
    print('API Version: $onlineVersion');

    if (localVersion.compareTo(onlineVersion) != 0){
      writeBuildingVersionToLocal(onlineVersion);
      return updateBuildingData();
    }
  }catch (e){

  }

  try{
    final localBuildingData = await getBuildingDataFromLocal();
    if (localBuildingData.isEmpty){
      print('File Empty');
      return updateBuildingData();
    }
    print('Get From File');
    return localBuildingData;
  }catch (e){
    print('File Error');
    return updateBuildingData();
  }
}

Future<List> updateBuildingData() async {
  print('Update Building Data From API');
  final onlineBuildingData = await fetchBuildingDataFromAPI();
  writeBuildingDataToLocal(onlineBuildingData);
  return jsonDecode(onlineBuildingData);
}

Future<Map> getClassData() async{
  try{
    final localVersion = await getClassVersionFromLocal();
    final onlineVersion = await fetchClassDataVersionFromAPI();

    print('Local Version: $localVersion');
    print('API Version: $onlineVersion');

    if (localVersion.compareTo(onlineVersion) != 0){
      writeClassVersionToLocal(onlineVersion);
      return updateClassData();
    }
  }catch (e){

  }

  try{
    final localClassData = await getClassDataFromLocal();
    if (localClassData.isEmpty){
      print('File Empty');
      return updateClassData();
    }
    print('Get From File');
    return localClassData;
  }catch (e){
    print('File Error');
    return updateClassData();
  }

}

Future<Map> updateClassData() async {
  print('Update Class Data From API');
  final onlineClassData = await fetchClassDataFromAPI();
  writeClassDataToLocal(onlineClassData);
  return jsonDecode(onlineClassData);
}

Future<List<EnrolledClass>> getEnrolledClassData() async{
  print('Get Enrolled Class Data From File');
  return getEnrolledClassesFromLocal();
}

void updateEnrolledClassData(List<EnrolledClass> enrolledClasses) async{
  print('Update Enrolled Class Data To Local');
  writeEnrolledClassesToLocal(enrolledClasses);
}

Future<AppSetting> getAppSettingData() async{
  return getAppSettingFromLocal();
}

void updateAppSettingData(AppSetting appSetting) {
  print('Update App Setting Data To Local');
  writeAppSettingToLocal(appSetting);
}
