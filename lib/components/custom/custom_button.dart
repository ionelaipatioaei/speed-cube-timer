import 'dart:async';

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Widget child;
  final Function action;
  final BoxConstraints constraints;
  final double borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;

  CustomButton({this.child, this.action, this.constraints, this.borderRadius = 0.0, this.margin, this.padding});

  @override
  State<StatefulWidget> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
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
        constraints: widget.constraints,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          color: Colors.black.withOpacity(opacity)
        ),
        margin: widget.margin,
        padding: widget.padding,
        child: widget.child
      )
    );
  }
}