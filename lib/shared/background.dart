import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:speed_cube_timer/utils/sizes.dart';

class Background extends StatefulWidget {
  final bool recordTaps;
  final Widget child;
  final bool allowInspectionTime;

  final bool gettingReadyForInspection;
  final bool readyToInspect;
  final bool runningInspectionTimer;
  final bool finishedInspection;

  final bool gettingReady;
  final bool ready;
  final bool runningTimer;

  final Function onTapDown;
  final Function onTapUp;
  final Function onLongPressEnd;
  final Function onLongPressStart;

  Background({
    this.recordTaps = false, this.child, this.allowInspectionTime,
    this.gettingReadyForInspection, this.readyToInspect, this.runningInspectionTimer, this.finishedInspection,
    this.gettingReady, this.ready, this.runningTimer,
    this.onTapDown, this.onTapUp, this.onLongPressEnd, this.onLongPressStart
   });

  @override
  State<StatefulWidget> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  Color readyColor0 = Colors.green;
  Color readyColor1 = Colors.greenAccent;
  Color inspectionColor0 = Colors.orange;
  Color inspectionColor1 = Colors.yellow;

  void _onTapDown(TapDownDetails details, double paddingTop) {
    if (widget.recordTaps && details.globalPosition.dy > (NAVBAR_HEIGHT + paddingTop)) {
      widget.onTapDown();
    }
  }

  void _onTapUp(TapUpDetails details, double paddingTop) {
    if (widget.recordTaps && details.globalPosition.dy > (NAVBAR_HEIGHT + paddingTop)) {
      widget.onTapUp();
    }
  }

  void _onLongPressStart(LongPressStartDetails details, double paddingTop) {
    if (widget.recordTaps && details.globalPosition.dy > (NAVBAR_HEIGHT + paddingTop)) {
      widget.onLongPressStart();
    }
  }

  void _onLongPressEnd(LongPressEndDetails details, double paddingTop) {
    if (widget.recordTaps && details.globalPosition.dy > (NAVBAR_HEIGHT + paddingTop)) {
      widget.onLongPressEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;

    double backgroundOpacity;
    bool showInspectionColor;

    Color color0 = Colors.transparent;
    Color color1 = Colors.transparent;

    if (widget.recordTaps) {
      backgroundOpacity = (widget.gettingReady || widget.ready || widget.runningTimer || 
        widget.gettingReadyForInspection || widget.readyToInspect || widget.runningInspectionTimer) ? 1.0 : 0.0;
      showInspectionColor = (widget.allowInspectionTime && !widget.finishedInspection);

      color0 = showInspectionColor ? inspectionColor0.withOpacity(backgroundOpacity) : readyColor0.withOpacity(backgroundOpacity);
      color1 = showInspectionColor ? inspectionColor1.withOpacity(backgroundOpacity) : readyColor1.withOpacity(backgroundOpacity);
    }

    return WatchBoxBuilder(
      box: Hive.box("background"),
      watchKeys: ["mesh_gradient", "linear_gradient"],
      builder: (BuildContext context, Box box) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) => _onTapDown(details, paddingTop),
          onTapUp: (TapUpDetails details) => _onTapUp(details, paddingTop),
          onLongPressEnd: (LongPressEndDetails details) => _onLongPressEnd(details, paddingTop),
          onLongPressStart: (LongPressStartDetails details) => _onLongPressStart(details, paddingTop),
          child: Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gradients/mesh/gradient" + box.get("mesh_gradient", defaultValue: 4).toString() + ".jpg"),
                fit: BoxFit.fill
              ),
            ),
            child: AnimatedContainer(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width
              ),
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [color0, color1]
                )
              ),
              child: widget.child,
            )
          )
        );
      }
    );
  }
}