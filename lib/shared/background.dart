import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:speed_cube_timer/utils/sizes.dart';

class Background extends StatefulWidget {
  final bool recordTaps;
  final Widget child;

  final Function ready;
  final Function startStopwatch;
  final Function stopStopwatch;

  Background({this.recordTaps = false, this.child, this.ready, this.startStopwatch, this.stopStopwatch});

  @override
  State<StatefulWidget> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  bool recording = false;
  bool gettingReady = false;
  List<Color> overlayGradient = [Colors.red, Colors.orange];

  void _onTapDown(TapDownDetails details, double paddingTop) {
    if (widget.recordTaps && details.globalPosition.dy > (NAVBAR_HEIGHT + paddingTop)) {
      if (!recording) {
        print("start ready animation");
        setState(() => gettingReady = true);
      } else {
        widget.stopStopwatch();
        setState(() => recording = false);
        print("stop stopwatch");
      }
    }
  }

  void _onTapUp(TapUpDetails details, double paddingTop) {
    if (widget.recordTaps && details.globalPosition.dy > (NAVBAR_HEIGHT + paddingTop)) {
      if (!recording) {
        setState(() => gettingReady = false);
        print("stop ready animation");
      }
    }
  }

  void _onLongPressStart(LongPressStartDetails details, double paddingTop) {
    if (widget.recordTaps && details.globalPosition.dy > (NAVBAR_HEIGHT + paddingTop)) {
      if (!recording) {
        widget.ready();
        // setState(() => gettingReady = false);
        print("stop ready animation");
      }
    }
  }

  void _onLongPressEnd(LongPressEndDetails details, double paddingTop) {
    if (widget.recordTaps && details.globalPosition.dy > (NAVBAR_HEIGHT + paddingTop)) {
      if (!recording) {
        widget.startStopwatch();
        setState(() => recording = true);
        print("start stopwatch");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return WatchBoxBuilder(
      box: Hive.box("background"),
      watchKeys: ["mesh_gradient", "linear_gradient"],
      builder: (BuildContext context, Box box) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) => _onTapDown(details, paddingTop),
          onTapUp: (TapUpDetails details) => _onTapUp(details, paddingTop),
          // onLongPress: _onLongPress,
          // onLongPressUp: _onLongPressUp,
          onLongPressEnd: (LongPressEndDetails details) => _onLongPressEnd(details, paddingTop),
          onLongPressStart: (LongPressStartDetails details) => _onLongPressStart(details, paddingTop),
          child: Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gradients/mesh/gradient" + box.get("mesh_gradient", defaultValue: 0).toString() + ".jpg"),
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
                  colors: [overlayGradient[0].withOpacity(gettingReady ? 1.0 : 0.0), overlayGradient[1].withOpacity(gettingReady ? 1.0 : 0.0)]
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