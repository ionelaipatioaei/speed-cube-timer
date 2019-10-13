import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';
import 'package:speed_cube_timer/shared/svg_icon.dart';

class SvgIconButton extends StatefulWidget {
  final String _src;
  final String _alt;
  final Function _action;
  final double iconHeight;
  final String text;
  SvgIconButton(this._src, this._alt, this._action, {this.iconHeight, this.text});

  @override
  State<StatefulWidget> createState() => _SvgIconButtonState();
}

class _SvgIconButtonState extends State<SvgIconButton> {
  bool pressed = false;

  void resetOpacity() {
    setState(() => pressed = false);
  }

  void animatePress() {
    setState(() => pressed = true);
    widget._action();
    Timer(Duration(milliseconds: 400), resetOpacity);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.text != null) {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgIcon(widget._src, widget._alt, widget.iconHeight ?? 26),
          CustomText(widget.text, size: 12)
        ],
      );
    } else {
      child = SvgIcon(widget._src, widget._alt, widget.iconHeight ?? 26);
    }
    return GestureDetector(
      onTap: animatePress,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        opacity: pressed ? 0.1 : 1.0,
        child: child
      )
    );
  }
}