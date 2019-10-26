import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';
import 'package:speed_cube_timer/shared/svg_icon.dart';

class ActionButton extends StatefulWidget {
  final String text;
  final String src;
  final String alt;
  final Function action;

  ActionButton(this.text, this.src, this.alt, this.action);

  @override
  State<StatefulWidget> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
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
        // constraints: BoxConstraints.expand(
        //   height: 30.0,
        //   // width: widget.width
        // ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.black.withOpacity(opacity)
        ),
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
        margin: EdgeInsets.all(6.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgIcon(widget.src, widget.alt, 20),
            SizedBox(width: 2.0),
            CustomText(widget.text, align: TextAlign.center, size: 16),
          ],
        )
      )
    );
  }
}