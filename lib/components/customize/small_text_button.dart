import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

class SmallTextButton extends StatefulWidget {
  final String text;
  final Function action;

  SmallTextButton(this.text, this.action);

  @override
  State<StatefulWidget> createState() => _SmallTextButtonState();
}

class _SmallTextButtonState extends State<SmallTextButton> {
  double opacity = 0.12;

  void animatePress() {
    setState(() => opacity = 0.3);
    widget.action();
    Timer(Duration(milliseconds: 150), () => setState(() => opacity = 0.12));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: animatePress,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        constraints: BoxConstraints.expand(
          height: 40.0,
          // width: widget.width
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.black.withOpacity(opacity)
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        margin: EdgeInsets.all(4.0),
        alignment: Alignment.center,
        child: CustomText(widget.text, align: TextAlign.center, size: 12),
      )
    );
  }
}