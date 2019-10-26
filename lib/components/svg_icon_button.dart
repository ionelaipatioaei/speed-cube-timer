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
  final bool animate;
  final EdgeInsets margin;
  SvgIconButton(this._src, this._alt, this._action, {this.iconHeight, this.text, this.animate, this.margin});

  @override
  State<StatefulWidget> createState() => _SvgIconButtonState();
}

class _SvgIconButtonState extends State<SvgIconButton> {
   double opacity = 0.0;

  void animatePress() {
    if (widget.animate) {
      setState(() => opacity = 0.26);
      Timer(Duration(milliseconds: 200), () => setState(() => opacity = 0.0));
    }
    widget._action();
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
      child: widget.animate ? AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(opacity),
          borderRadius: BorderRadius.all(Radius.circular(40.0))
        ),
        margin: widget.margin,
        child: child
      ) : child
    );
  }
}