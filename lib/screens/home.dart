import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/home/action_buttons.dart';
import 'package:speed_cube_timer/components/home/bottom_stats.dart';

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
  static const int updateTimeMs = 16;
  static const Duration hideAnimationDuration = Duration(milliseconds: 200);

  Stopwatch stopwatch = Stopwatch();
  Timer timer;

  Box settings = Hive.box("settings");
  Box stats = Hive.box("stats");

  bool showStatus = true;
  String status = "Long press to get ready!";
  String scramble = "F2 D2 F U2 F' U2 L2";
  int totalMs = 0;

  // this values need to come from hive
  bool liveStopwatch;
  bool allowInspectionTime;
  bool showScramblingSequence;

  // this value can by update by hive but also used as state
  int inspectionTime;
  int scramblingSequenceLength;

  // the reason why there are so many variables is to hopefully eliminate all edge cases
  bool gettingReadyForInspection = false;
  bool readyToInspect = false;
  bool runningInspectionTimer = false;
  bool finishedInspection = false;

  bool gettingReady = false;
  bool ready = false;
  bool runningTimer = false;

  // a few notes on how the functions are triggered
  // onTapDown is always fired when the user touches the screen no matter what
  // onTapUp is fired if the users lifts the finger before onLongPressStart is called
  // if onLongPressStart gets fired onTaUp can't be triggered and onLongPressEnd is always
  // called when the users lifts the finger

  String genSramblingSequence(int length) {
    Random rng = Random();
    const List<String> moves = ["F", "R", "U", "L", "B", "D", "F'", "R'", "U'", "L'", "B'", "D'", "F2", "R2", "U2", "L2", "B2", "D2"];
    int totalMoves = moves.length;
    String genScramble = "";
    for (int i = 0; i < length; i++) {
      genScramble += moves[rng.nextInt(totalMoves)];
      if (i != length - 1) {
        genScramble += " ";
      }
    }
    return genScramble;
  }

  void updateBottomStats() {

  }

  void resetCycle() {
    setState(() {
      showStatus = true;
      status = allowInspectionTime ? "Long press to get ready for inspection!" : "Long press to get ready";
      gettingReadyForInspection = false;
      readyToInspect = false;
      runningInspectionTimer = false;
      finishedInspection = false;
      gettingReady = false;
      ready = false;
      runningTimer = false;
    });
  }

  void onTapDown() {
    // check the settings every time to see if the user updated them
    setState(() {
      liveStopwatch = settings.get("live_stopwatch", defaultValue: true);
      allowInspectionTime = settings.get("allow_inspection_time", defaultValue: false);
      inspectionTime = settings.get("inspection_time", defaultValue: 15000);
      showScramblingSequence = settings.get("show_scrambling_sequence", defaultValue: true);
      scramblingSequenceLength = settings.get("scrambling_sequence_length", defaultValue: 16);
    });

    if (allowInspectionTime && !finishedInspection && !(runningInspectionTimer && runningTimer)) {
      setState(() {
        gettingReadyForInspection = true;
      });
    }

    if (runningInspectionTimer) {
      setState(() {
        showStatus = true;
        status = "Long press to get ready!";
        finishedInspection = true;
        totalMs = 0;
      });
    }

    if (finishedInspection || !allowInspectionTime) {
      setState(() => gettingReady = true);
    }

    if (runningTimer) {
      stopwatch.stop();
      setState(() {
        totalMs = stopwatch.elapsedMilliseconds;
      });
      // record the timing from the solve


      resetCycle();
      stopwatch.reset();
    }

    print("ON TAP DOWN");
  }

  void onTapUp() {
    setState(() => scramble = genSramblingSequence(scramblingSequenceLength));

    if (allowInspectionTime && !finishedInspection && !(runningInspectionTimer && runningTimer)) {
      setState(() => gettingReadyForInspection = false);
    }

    if (finishedInspection || !allowInspectionTime) {
      setState(() => gettingReady = false);
    }

    print("ON TAP UP");
  }

  void onLongPressStart() {
    if (allowInspectionTime && !finishedInspection && !(runningInspectionTimer && runningTimer && readyToInspect)) {
      setState(() {
        status = "Lift your finger to start inspection!";
        totalMs = inspectionTime;
        readyToInspect = true;
       });
    }

    if ((finishedInspection || !allowInspectionTime) && !ready) {
      setState(() {
        status = "Lift your finger to start!";
        totalMs = 0;
        ready = true;
       });
    }

    print("ON LONG PRESS START");
  }

  void onLongPressEnd() {
    if (allowInspectionTime && !finishedInspection && !(runningInspectionTimer && runningTimer) && readyToInspect) {
      setState(() {
        showStatus = false;
        runningInspectionTimer = true;
       });
    }

    if ((finishedInspection || !allowInspectionTime) && ready) {
      stopwatch.start();
      setState(() {
        runningTimer = true;
        showStatus = false;
       });
    }

    print("ON LONG PRESS END");
  }

  void updateCounter(Timer timer) {
    setState(() {
      if (runningInspectionTimer) {
        totalMs -= updateTimeMs; 
      }
      if (runningTimer) {
        totalMs = stopwatch.elapsedMilliseconds;
      }
      if (totalMs < 1 && !ready) {
        showStatus = true;
        status = "Long press to get ready!";
      }
    });
  }

  @override
  void initState() {
    liveStopwatch = settings.get("live_stopwatch", defaultValue: true);
    allowInspectionTime = settings.get("allow_inspection_time", defaultValue: false);
    inspectionTime = settings.get("inspection_time", defaultValue: 15000);
    showScramblingSequence = settings.get("show_scrambling_sequence", defaultValue: true);
    scramblingSequenceLength = settings.get("scrambling_sequence_length", defaultValue: 16);
    scramble = genSramblingSequence(scramblingSequenceLength);

    if (allowInspectionTime) {
      status = "Long press to get ready for inspection!";
    }
    timer = Timer.periodic(Duration(milliseconds: updateTimeMs), updateCounter);
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
    double padding = MediaQuery.of(context).size.width * 0.05;
    int mins = 0;
    int secs = 0;
    int ms = 0;
    if (totalMs > 0) {
      mins = totalMs ~/ 60000;
      secs = ((totalMs % 60000) ~/ 1000);
      // this if is here to prevent the stupid divide by 0 error
      if (secs < 1) {
        ms = totalMs % 1000;
      } else {
        ms = totalMs % ((secs * 1000) + (mins * 60000));
      }
    }
    bool displayWidgets = (runningTimer || runningInspectionTimer);
    // myBanner..load()..show();
    return Scaffold(
      body: Background(
        recordTaps: true,
        allowInspectionTime: allowInspectionTime,

        gettingReadyForInspection: gettingReadyForInspection,
        readyToInspect: readyToInspect,
        runningInspectionTimer: runningInspectionTimer,
        finishedInspection: finishedInspection,

        gettingReady: gettingReady,
        ready: ready,
        runningTimer: runningTimer,

        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onLongPressEnd: onLongPressEnd,
        onLongPressStart: onLongPressStart,
        child: Column(
          children: <Widget>[
            TopNavbarMenu(),
            AdjustedContainer(
              padding: EdgeInsets.symmetric(horizontal: padding),

              child: WatchBoxBuilder(
                box: Hive.box("settings"),
                watchKeys: ["show_scrambling_sequence", "options", "selected_option"],
                builder: (BuildContext context, Box box) {
                  List<String> options = box.get("options", defaultValue: ["2x2x2", "3x3x3", "4x4x4", "5x5x5", "6x6x6", "7x7x7"]);
                  int selectedOption = box.get("selected_option", defaultValue: 0);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: CustomText("Currently practicing for ${options[selectedOption]}", size: 18, align: TextAlign.center, weight: FontWeight.w300,),
                        margin: EdgeInsets.only(top: 16.0)
                      ),
                      Column(
                        children: <Widget>[
                          AnimatedOpacity(
                            duration: hideAnimationDuration,
                            opacity: showStatus ? 1.0 : 0.0,
                            child: CustomText(status, align: TextAlign.center, color: Colors.white60),
                          ),
                          AnimatedContainer(
                            duration: hideAnimationDuration,
                            margin: EdgeInsets.only(bottom: displayWidgets ? 48.0 : 12.0)
                          ),
                          CustomText(!displayWidgets || liveStopwatch || !runningTimer ? 
                            "${mins > 9 ? mins : mins.toString().padLeft(2, '0')}:${secs > 9 ? secs : secs.toString().padLeft(2, '0')}:${ms.toString().length < 3 ? ms.toString().padRight(3, '0') : ms}" : "", 
                            align: TextAlign.center, size: 42),
                          box.get("show_scrambling_sequence", defaultValue: true) ? AnimatedOpacity(
                            duration: hideAnimationDuration,
                            opacity: displayWidgets ? 0.0 : 1.0,
                            child: CustomText(scramble, align: TextAlign.center, size: 16),
                          ) : SizedBox(height: 0),
                          SizedBox(height: 8.0),
                          ActionButtons(displayWidgets, hideAnimationDuration)
                        ],
                      ),
                      // !TODO: reset the things when clicking on the buttons
                      BottomStats(displayWidgets, hideAnimationDuration)
                    ],
                  );

                }
              )
            )
          ],
        ),
      )
    );
  }
}