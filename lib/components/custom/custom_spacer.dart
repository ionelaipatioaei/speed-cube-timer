import 'package:flutter/material.dart';

class CustomSpacer extends StatelessWidget {
  final double width;
  final EdgeInsets margin;
  CustomSpacer(this.width, {this.margin = const EdgeInsets.symmetric(vertical: 10.0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: 1.0,
        width: width
      ),
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16)
      ),
    );
  }
}