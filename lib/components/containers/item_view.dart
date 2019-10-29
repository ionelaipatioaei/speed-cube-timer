import 'package:flutter/material.dart';
import 'package:speed_cube_timer/utils/sizes.dart';

class ItemView extends StatelessWidget {
  final double width;
  final List<Widget> children;
  
  ItemView({this.width, this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        width: width,
        height: KNOB_SIZE + 10
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children
      )
    );
  }
}