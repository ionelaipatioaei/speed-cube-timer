import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speed_cube_timer/screens/home/home.dart';
import 'package:speed_cube_timer/utils/iap_config.dart';
import 'package:speed_cube_timer/utils/solve.dart';

void main() async {
  Directory appDocuments = await getApplicationDocumentsDirectory();
  Hive.init(appDocuments.path);
  await Hive.openBox("customize");
  await Hive.openBox("settings");
  await Hive.openBox("unlocked");
  
  // check the formar version of the statistics
  await Hive.openBox("statistics");
  Box statistics = Hive.box("statistics");
  int statsFormatVersion = statistics.get("stats_format_number");
  if (statsFormatVersion == null) {
    statistics.put("stats_format_version", 0);
  } else if (statsFormatVersion != Solve.statsFormatVersion) {
    print("Found stats format version: $statsFormatVersion but the current version is: ${Solve.statsFormatVersion}.");
  }

  // init the iaps by placing the default values in firebase if there are none
  IAPConfig.init();

  // check too see how many backgrounds where the last time and update the number accordingly
  // Box unlocked = Hive.box("unlocked");
  // int updatedTotalBackgrounds = IAPConfig.totalBackgrounds;
  // int totalBackgrounds = unlocked.get("total_backgrounds", defaultValue: updatedTotalBackgrounds);
  // if (totalBackgrounds != updatedTotalBackgrounds) {
  //   print("Found only $totalBackgrounds total backgrounds and there are $updatedTotalBackgrounds now, updating...");
  //   IAPConfig.updateBackgrounds();
  // }

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // for some reason these values are switched
      statusBarBrightness: Platform.isIOS ? Brightness.dark : Brightness.light,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Speed Cube Timer",
      home: Home()
    );
  }
}