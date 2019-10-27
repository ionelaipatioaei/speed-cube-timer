import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/common/action_button.dart';

class ActionButtons extends StatelessWidget {
  final bool running;
  final Duration duration;

  final Function action0;
  final Function action1;
  final Function action2;

  ActionButtons(this.running, this.duration, {this.action0, this.action1, this.action2});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: duration,
      opacity: running ? 0.0 : 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ActionButton("+2S", "assets/icons/zap.svg", "zap icon", action0),
          ActionButton("DNF", "assets/icons/frown.svg", "meh face icon", action1),
          ActionButton("DEL", "assets/icons/trash.svg", "trash can icon", action2),
        ],
      ),
    );
  }
}