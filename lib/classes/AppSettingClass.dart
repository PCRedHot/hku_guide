

import 'package:hku_guide/tools/DataManager.dart';

class AppSetting {

  bool mainPageLinkDescription = true;
  bool showNearbyBuilding = true;

  AppSetting({this.mainPageLinkDescription, this.showNearbyBuilding});

  factory AppSetting.fromJson(Map json) => AppSetting(
      mainPageLinkDescription: json['mainPageLinkDescription'],
      showNearbyBuilding: json['showNearbyBuilding'],
  );

  factory AppSetting.defaultSetting() => AppSetting(
    mainPageLinkDescription: true,
    showNearbyBuilding: true,
  );

  Map toJson() => {
    'mainPageLinkDescription': mainPageLinkDescription,
    'showNearbyBuilding': showNearbyBuilding
  };

  void checkNull() {
    if (mainPageLinkDescription == null) mainPageLinkDescription = true;
    if (showNearbyBuilding == null) showNearbyBuilding = true;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }

  List getSettingBoolNames() {
    return [
      ['Link Descriptions', 'mainPageLinkDescription'],
      ['Show Nearby Buildings', 'showNearbyBuilding'],
    ];
  }

  operator []=(String name, dynamic val) {
    switch(name) {
      case 'mainPageLinkDescription': mainPageLinkDescription = val; break;
      case 'showNearbyBuilding': showNearbyBuilding = val; break;
    }
    updateAppSettingData(this);
  }

  dynamic operator [](String name) {
    switch(name) {
      case 'mainPageLinkDescription': return mainPageLinkDescription;
      case 'showNearbyBuilding': return showNearbyBuilding;
    }
  }


}