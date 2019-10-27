import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_icon.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final String src;
  final String alt;
  final Function action;

  MenuButton(this.title, this.src, this.alt, this.action);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomIcon(src, alt, 26),
          CustomText(title, size: 12)
        ],
      )
    );
  }
}