import 'dart:async';

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Widget child;
  final Function action;
  final BoxConstraints constraints;
  final double borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double startOpacity;
  final double endOpacity;

  CustomButton({this.child, this.action, this.constraints, this.borderRadius = 0.0, this.margin, this.padding, this.startOpacity = 0.12, this.endOpacity = 0.3});

  @override
  State<StatefulWidget> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double opacity;

  void animatePress() {
    setState(() => opacity = widget.endOpacity);
    widget.action();
    Timer(Duration(milliseconds: 150), () => setState(() => opacity = widget.startOpacity));
  }

  @override
  void initState() {
    opacity = widget.startOpacity;
    super.initState();
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
        alignment: Alignment.center,
        margin: widget.margin,
        padding: widget.padding,
        child: widget.child
      )
    );
  }
}