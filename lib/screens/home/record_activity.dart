import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/containers/delete_solve_modal.dart';
import 'package:speed_cube_timer/components/containers/action_buttons.dart';
import 'package:speed_cube_timer/components/containers/bottom_stats.dart';
import 'package:speed_cube_timer/components/custom/custom_modal.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';
import 'package:speed_cube_timer/utils/format_time.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class RecordActivity extends StatelessWidget {
  static const Duration hideAnimationDuration = Duration(milliseconds: 200);

  final int totalMs;
  final bool showStatus;
  final String status;
  final bool displayWidgets;
  final bool liveStopwatch;
  final bool runningTimer;
  final String scramble;
  final Function resetCycle;

  RecordActivity({this.totalMs, this.showStatus, this.status, this.displayWidgets, this.liveStopwatch, this.runningTimer, this.scramble, this.resetCycle});

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
          List<String> options = box.get("options", defaultValue: GenScramble.defaultOptions);
          int selectedOption = box.get("selected_option", defaultValue: 0);
          String optionName = GenScramble.getOptionName(options[selectedOption]);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: CustomText("Currently practicing for $optionName", size: 18, align: TextAlign.center, weight: FontWeight.w300,),
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
                  ActionButtons(displayWidgets, hideAnimationDuration,
                    // resetCycle is called because some time onTapDown from home.dart is called and the home
                    // screen changes to the inspection/ready color, this prevents that
                    action0: () {
                      resetCycle();
                    },
                    action1: () {
                      resetCycle();
                    },
                    action2: () {
                      resetCycle();
                      Navigator.of(context).push(CustomModal.createRoute(DeleteSolveModal())); 
                    },
                  )
                ],
              ),
              BottomStats(displayWidgets, hideAnimationDuration)
            ],
          );
        }
      ),
    );
  }
}