import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_button.dart';
import 'package:speed_cube_timer/components/custom/custom_icon.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final String src;
  final String alt;
  final Function action;
  final bool checked;

  ActionButton(this.text, this.src, this.alt, this.action, this.checked);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      action: action,
      margin: EdgeInsets.all(6.0),
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      borderRadius: 30.0,
      startOpacity: checked ? 0.3 : 0.12,
      child: Row(
        children: <Widget>[
          CustomIcon(src, alt, 20.0),
          SizedBox(width: 2.0),
          CustomText(text, align: TextAlign.center, size: 16)
        ],
      ),
    );
  }
}