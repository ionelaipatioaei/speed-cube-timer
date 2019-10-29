import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_button.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

class TextButton extends StatelessWidget {
  final String text;
  final double width;
  final Function action;
  final EdgeInsets margin;

  TextButton(this.text, this.width, this.action, {this.margin});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      action: action,
      margin: margin,
      constraints: BoxConstraints.expand(
        height: 40.0,
        width: width
      ),
      borderRadius: 21.0,
      child: CustomText(text, size: 20, align: TextAlign.center)
    );
  }
}