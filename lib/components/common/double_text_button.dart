import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_button.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

class DoubleTextButton extends StatelessWidget {
  final String text0;
  final String text1;
  final double width;
  final Function action;
  final EdgeInsets margin;
  final double text0Size;
  final double text1Size;

  DoubleTextButton(this.text0, this.text1, this.width, this.action, {this.margin, this.text0Size = 13, this.text1Size = 13});

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomText(text0, size: text0Size, align: TextAlign.center),
          CustomText(text1, size: text1Size, align: TextAlign.center),
        ],
      )
    );
  }
}