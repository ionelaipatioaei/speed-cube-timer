import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

class TextButton extends StatefulWidget {
  final String text;
  final String text2;
  final double width;

  final Function action;
  TextButton(this.text, this.text2, this.action, {this.width});

  @override
  State<StatefulWidget> createState() => _TextButtonState();
}

class _TextButtonState extends State<TextButton> {
  bool pressed = false;

  void resetOpacity() {
    setState(() => pressed = false);
  }

  void animatePress() {
    setState(() => pressed = true);
    widget.action();
    Timer(Duration(milliseconds: 400), resetOpacity);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.text2.isEmpty ? CustomText(widget.text, size: 16) : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomText(widget.text),
        CustomText(widget.text2)
      ],
    );
    return GestureDetector(
      onTap: animatePress,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        opacity: pressed ? 0.1 : 1.0,
        child: Container(
          constraints: BoxConstraints.expand(
            height: 40.0,
            width: widget.width
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.black.withOpacity(0.12)
          ),
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 4.0),
          child: child
        )
      )
    );
  }
}