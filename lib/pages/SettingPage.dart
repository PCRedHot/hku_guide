import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hku_guide/classes/AppSettingClass.dart';
import 'package:hku_guide/tools/DataManager.dart';


class SettingPage extends StatefulWidget{
  SettingPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{

  AppSetting appSetting;

  @override
  void initState() {
    super.initState();

    appSetting = PageStorage.of(context).readState(context, identifier: 'appSetting');
    if (appSetting == null){
      appSetting = AppSetting.defaultSetting();
      getAppSettingData().then((setting) =>
        setState(() {
          appSetting = setting;
          PageStorage.of(context).writeState(context, appSetting, identifier: 'appSetting');
        })
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _getSettingWidgets(),
      ),
    );
  }

  List<Widget> _getSettingWidgets(){
    return appSetting.getSettingBoolNames().map((item) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item[0],
              style: TextStyle(
                color: Color.fromRGBO(230, 230, 230, 1.0),
                fontSize: 20,
                fontWeight: FontWeight.w300
              ),
            ),
            FlutterSwitch(
              width: 50,
              height: 25,
              value: appSetting[item[1]],
              onToggle: (bool value) => setState(() =>
                appSetting[item[1]] = value
              ),
            )
          ],
        ),
      )
    ).toList();
  }
}
