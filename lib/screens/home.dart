import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:hive/hive.dart';

import 'package:speed_cube_timer/components/navigation/top_navbar_menu.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';
import 'package:speed_cube_timer/utils/hex_color.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  Box background = Hive.box("background");
  String action = "Long press to get ready";

  Stopwatch stopwatch = Stopwatch();
  Timer timer;

  void changeBackground() {
    if (_currentIndex == 15) {
     setState(() =>_currentIndex = 0); 
    } else {
      setState(() => _currentIndex++);
    }
    background.put("mesh_gradient", _currentIndex);
  }

  void ready() {
    setState(() => action = "Tap up to start");
    stopwatch.reset();
  }

  void startStopwatch() {
    setState(() => action = "Stopwatch started...");
    stopwatch.start();
  }

  void stopStopwatch() {
    setState(() {
      ms = stopwatch.elapsedMilliseconds;
      action = "Stopwatch stopped! Total time: unknown! Long press to get ready";
    });
    stopwatch.stop();
  }

  int ms = 0;

  void updateCounter(Timer timer) {
    setState(() => ms = stopwatch.elapsedMilliseconds);
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 32), updateCounter);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // myBanner..load()..show();
    return Scaffold(
      body: Background(
        recordTaps: true,
        ready: () => ready(),
        startStopwatch: () => startStopwatch(),
        stopStopwatch: () => stopStopwatch(),
        child: Column(
          children: <Widget>[
            TopNavbarMenu(),
            AdjustedContainer(
              child: Column(
                children: <Widget>[
                  RaisedButton(onPressed: changeBackground),
                  CustomText(action),
                  CustomText(ms.truncate().toString())
                ],
              )
            )
          ],
        ),
      )
    );
  }
}