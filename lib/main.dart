import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speed_cube_timer/screens/home/home.dart';

void main() async {
  Directory appDocuments = await getApplicationDocumentsDirectory();
  Hive.init(appDocuments.path);
  await Hive.openBox("background");
  await Hive.openBox("settings");
  // statistics will have multiple boxes for each pratice option, each box will hold 100 records
  // this statistics box will only hold general info, like the current record box
  // index and the averages of 5, 12, 50, best time, total solves, etc
  // the idea is to prevent the statistics box to get huge and slow
  await Hive.openBox("statistics");
  await Hive.openBox("iap");
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