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
  double opacity = 0.12;

  void animatePress() {
    setState(() => opacity = 0.3);
    widget.action();
    Timer(Duration(milliseconds: 150), () => setState(() => opacity = 0.12));
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        constraints: BoxConstraints.expand(
          height: 40.0,
          width: widget.width
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.black.withOpacity(opacity)
        ),
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: child
      )
    );
  }
}