import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class BottomStats extends StatefulWidget {
  final bool running;
  final Duration duration;

  BottomStats(this.running, this.duration);

  @override
  State<StatefulWidget> createState() => _BottomStatsState();
}

class _BottomStatsState extends State<BottomStats> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      opacity: widget.running ? 0.0 : 1.0,
      child: WatchBoxBuilder(
        box: Hive.box("settings"),
        builder: (BuildContext context, Box settings) {
          List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
          int selected = settings.get("selected_option", defaultValue: 0);
          String name = GenScramble.getOptionName(options[selected]);
          return WatchBoxBuilder(
            box: Hive.box("statistics"),
            builder: (BuildContext context, Box statistics) {
              int bestTime = statistics.get("stats_${name}_best_time", defaultValue: 0);
              int worstTime = statistics.get("stats_${name}_worst_time", defaultValue: 0);
              int totalSolves = statistics.get("stats_${name}_total_solves", defaultValue: 0);
              int avg5 = statistics.get("stats_${name}_average_5", defaultValue: 0);
              int avg12 = statistics.get("stats_${name}_average_12", defaultValue: 0);
              int avg50 = statistics.get("stats_${name}_average_50", defaultValue: 0);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText("Best time: $bestTime"),
                      CustomText("Worst time: $worstTime"),
                      CustomText("Total solves: $totalSolves"),
                      SizedBox(height: 16.0)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      CustomText("Average of 5: $avg5"),
                      CustomText("Average of 12: $avg12"),
                      CustomText("Average of 50: $avg50"),
                      SizedBox(height: 16.0)
                    ],
                  )
                ],
              );
            }
          );

        }
      )
    );
  }
}