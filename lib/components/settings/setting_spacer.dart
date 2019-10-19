import 'package:flutter/material.dart';

class SettingSpacer extends StatelessWidget {
  final double width;
  SettingSpacer(this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: 1.0,
        width: width
      ),
      margin: EdgeInsets.only(bottom: 16.0, top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16)
      ),
    );
  }
}