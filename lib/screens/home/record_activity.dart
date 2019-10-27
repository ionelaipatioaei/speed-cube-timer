import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/containers/action_buttons.dart';
import 'package:speed_cube_timer/components/containers/bottom_stats.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';
import 'package:speed_cube_timer/utils/format_time.dart';

class RecordActivity extends StatelessWidget {
  static const Duration hideAnimationDuration = Duration(milliseconds: 200);

  final int totalMs;
  final bool showStatus;
  final String status;
  final bool displayWidgets;
  final bool liveStopwatch;
  final bool runningTimer;
  final String scramble;

  RecordActivity({this.totalMs, this.showStatus, this.status, this.displayWidgets, this.liveStopwatch, this.runningTimer, this.scramble});

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

    return AdjustedContainer(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: WatchBoxBuilder(
        box: Hive.box("settings"),
        watchKeys: ["show_scrambling_sequence"],
        builder: (BuildContext context, Box box) {
          // List<String> options = box.get("options", defaultValue: ["2x2x2", "3x3x3", "4x4x4", "5x5x5", "6x6x6", "7x7x7"]);
          // int selectedOption = box.get("selected_option", defaultValue: 0);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: CustomText("Currently practicing for 3x3x3", size: 18, align: TextAlign.center, weight: FontWeight.w300,),
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
                    "${formatMinutes(mins)}:${formatSeconds(secs)}:${formatMs(ms)}" : "", 
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
      ),
    );
  }
}