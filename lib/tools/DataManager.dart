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
    print(localBuildingData);
    return updateBuildingData();
  }

  print('Get From File');
  return localBuildingData;
}

Future<List> updateBuildingData() async {
  print('Update Building Data From API');
  final onlineBuildingData = await fetchBuildingDataFromAPI();
  writeBuildingDataToLocalWithList(onlineBuildingData);
  return onlineBuildingData;
}