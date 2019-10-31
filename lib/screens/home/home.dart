import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speed_cube_timer/components/navigation/top_menu.dart';
import 'package:speed_cube_timer/screens/home/record_activity.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';
import 'package:speed_cube_timer/utils/solve.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int updateTimeMs = 16;

  Stopwatch stopwatch = Stopwatch();
  Timer timer;

  Box settings = Hive.box("settings");

  bool showStatus = true;
  String status = "Long press to get ready!";
  String scramble = "Generating...";
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
  bool solveFinished = false;

  bool plus2S = false;
  bool dnf = false;


  List<String> getScrambleMoves() {
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    return GenScramble.getScrambleMoves(options[selected]);
  }

  // a few notes on how the functions are triggered
  // onTapDown is always fired when the user touches the screen no matter what
  // onTapUp is fired if the users lifts the finger before onLongPressStart is called
  // if onLongPressStart gets fired onTaUp can't be triggered and onLongPressEnd is always
  // called when the users lifts the finger
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
        solveFinished = true;
      });
      // record the solve stats
      Solve.saveSolve(DateTime.now().millisecondsSinceEpoch, scramble, allowInspectionTime, inspectionTime, totalMs, plus2S, dnf);

      resetCycle();
      setState(() {
        status = allowInspectionTime ? "Long press to get ready for inspection!" : "Long press to get ready";
        plus2S = false;
        dnf = false;
      });
      
    }

    print("ON TAP DOWN");
    print("GRFI: $gettingReadyForInspection | RTI: $readyToInspect | RIT: $runningInspectionTimer | FI: $finishedInspection | GR: $gettingReady | R: $ready | RT: $runningTimer | SF: $solveFinished | P2S: $plus2S | DNF: $dnf");
  }

  void onTapUp() {
    setState(() => scramble = GenScramble.genScramble(scramblingSequenceLength, getScrambleMoves()));

    if (allowInspectionTime && !finishedInspection && !(runningInspectionTimer && runningTimer)) {
      setState(() => gettingReadyForInspection = false);
    }

    if (finishedInspection || !allowInspectionTime) {
      setState(() => gettingReady = false);
    }

    print("ON TAP UP");
    print("GRFI: $gettingReadyForInspection | RTI: $readyToInspect | RIT: $runningInspectionTimer | FI: $finishedInspection | GR: $gettingReady | R: $ready | RT: $runningTimer | SF: $solveFinished | P2S: $plus2S | DNF: $dnf");
  }

  void onLongPressStart() {
    if (allowInspectionTime && !finishedInspection && !(runningInspectionTimer && runningTimer && readyToInspect)) {
      setState(() {
        status = "Lift your finger to start inspection!";
        totalMs = inspectionTime;
        readyToInspect = true;
        plus2S = false;
        dnf = false;
       });
       stopwatch.reset();
    }

    if ((finishedInspection || !allowInspectionTime) && !ready) {
      setState(() {
        status = "Lift your finger to start!";
        totalMs = 0;
        ready = true;
        plus2S = false;
        dnf = false;
       });
       stopwatch.reset();
    }

    print("ON LONG PRESS START");
    print("GRFI: $gettingReadyForInspection | RTI: $readyToInspect | RIT: $runningInspectionTimer | FI: $finishedInspection | GR: $gettingReady | R: $ready | RT: $runningTimer | SF: $solveFinished | P2S: $plus2S | DNF: $dnf");
  }

  void onLongPressEnd() {
    if (allowInspectionTime && !finishedInspection && !(runningInspectionTimer && runningTimer) && readyToInspect) {
      setState(() {
        showStatus = false;
        runningInspectionTimer = true;
        solveFinished = false;
       });
    }

    if ((finishedInspection || !allowInspectionTime) && ready) {
      stopwatch.start();
      setState(() {
        showStatus = false;
        runningTimer = true;
        solveFinished = false;
       });
    }

    print("ON LONG PRESS END");
    print("GRFI: $gettingReadyForInspection | RTI: $readyToInspect | RIT: $runningInspectionTimer | FI: $finishedInspection | GR: $gettingReady | R: $ready | RT: $runningTimer | SF: $solveFinished | P2S: $plus2S | DNF: $dnf");
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

  void resetCycle() {
    setState(() {
      showStatus = true;
      // status = allowInspectionTime ? "Long press to get ready for inspection!" : "Long press to get ready";
      gettingReadyForInspection = false;
      readyToInspect = false;
      runningInspectionTimer = false;
      finishedInspection = false;
      gettingReady = false;
      ready = false;
      runningTimer = false;
      // plus2S = false;
      // dnf = false;
    });
  }

  void deleteSolve() {
    if (solveFinished) {
      Solve.deleteLastSolve();
      resetCycle();
      setState(() {
        status = allowInspectionTime ? "Long press to get ready for inspection!" : "Long press to get ready";
        plus2S = false;
        dnf = false;
        solveFinished = false;
        totalMs = 0;
      });
    }
  }

  void updatePlus2S() {
    if (solveFinished) {
      setState(() {
        plus2S = !plus2S;
        totalMs = plus2S ? totalMs + 2000 : stopwatch.elapsedMilliseconds;
      });
      Solve.updatePlus2SDnf(plus2S, dnf);
    }
  } 

  void updateDnf() {
    if (solveFinished) {
      setState(() {
        dnf = !dnf;
        totalMs = dnf ? 0 : stopwatch.elapsedMilliseconds;
      });
      Solve.updatePlus2SDnf(plus2S, dnf);
    }
  }

  @override
  void initState() {
    liveStopwatch = settings.get("live_stopwatch", defaultValue: true);
    allowInspectionTime = settings.get("allow_inspection_time", defaultValue: false);
    inspectionTime = settings.get("inspection_time", defaultValue: 15000);
    showScramblingSequence = settings.get("show_scrambling_sequence", defaultValue: true);
    scramblingSequenceLength = settings.get("scrambling_sequence_length", defaultValue: 16);
    scramble = GenScramble.genScramble(scramblingSequenceLength, getScrambleMoves());

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
            TopMenu(),
            RecordActivity(
              totalMs: totalMs, showStatus: showStatus, status: status,
              displayWidgets: (runningTimer || runningInspectionTimer),
              liveStopwatch: liveStopwatch, runningTimer: runningTimer, scramble: scramble, 
              resetCycle: resetCycle, deleteSolve: deleteSolve,
              plus2S: plus2S, dnf: dnf, updatePlus2S: updatePlus2S, updateDnf: updateDnf,
            )
          ],
        )
      )
    );
  }
}