import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speed_cube_timer/screens/home/home.dart';
import 'package:speed_cube_timer/utils/ads_ids.dart';
import 'package:speed_cube_timer/utils/iap_config.dart';
import 'package:speed_cube_timer/utils/solve.dart';

void main() async {
  Directory appDocuments = await getApplicationDocumentsDirectory();
  Hive.init(appDocuments.path);
  await Hive.openBox("customize");
  await Hive.openBox("settings");
  await Hive.openBox("unlocked");
  
  // check the format version of the statistics
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

  runApp(App());
}

class App extends StatelessWidget {
  // show the bottom ad
  final BannerAd bottomBanner = BannerAd(
    adUnitId: BOTTOM_BANNER_AD_ID,
    size: AdSize.smartBanner,
    // targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // for some reason these values are switched
      statusBarBrightness: Platform.isIOS ? Brightness.dark : Brightness.light,
    ));

    Hive.box("unlocked").watch(key: "remove_all_ads_unlock_all_customizations").listen((event) {
      if (event.value) {
        bottomBanner.dispose();
      }
    });

    if (!(Hive.box("unlocked").get("remove_all_ads_unlock_all_customizations", defaultValue: false))) {
      bottomBanner..load()..show();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Speed Cube Timer",
      home: Home()
    );
  }
}