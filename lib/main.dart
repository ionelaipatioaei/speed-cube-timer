import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'screens/home.dart';

void main() async {
  Directory appDocuments = await getApplicationDocumentsDirectory();
  Hive.init(appDocuments.path);
  await Hive.openBox("background");
  await Hive.openBox("settings");
  await Hive.openBox("stats");
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