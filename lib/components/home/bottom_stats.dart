import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomText("Best time: 12.02s"),
              CustomText("Worst time: 54.21s"),
              CustomText("Total solves: 1256"),
              SizedBox(height: 16.0)
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              CustomText("Average of 5: 20.2s"),
              CustomText("Average of 12: 22.12s"),
              CustomText("Average of 50: 23.2s"),
              SizedBox(height: 16.0)
            ],
          )
        ],
      )
    );
  }
}