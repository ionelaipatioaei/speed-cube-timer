import 'package:flutter/material.dart';

class CustomText extends StatelessWidget  {
  final String _text;

  final double size;
  final Color color;
  final FontWeight weight;
  final FontStyle style;
  CustomText(this._text, {this.size, this.color, this.weight, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: color ?? Colors.white, fontSize: size ?? 14, fontWeight: weight ?? FontWeight.w400, fontStyle: style ?? FontStyle.normal, fontFamily: "OpenSans"),
    );
  }
}