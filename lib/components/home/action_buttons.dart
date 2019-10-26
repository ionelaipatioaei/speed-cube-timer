import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/home/action_button.dart';

class ActionButtons extends StatelessWidget {
  final bool running;
  final Duration duration;

  ActionButtons(this.running, this.duration);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: duration,
      opacity: running ? 0.0 : 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ActionButton("+2S", "assets/icons/zap.svg", "zap icon", () => null),
          ActionButton("DNF", "assets/icons/frown.svg", "meh face icon", () => null),
          ActionButton("DEL", "assets/icons/trash.svg", "trash can icon", () => null),
        ],
      ),
    );
  }
}