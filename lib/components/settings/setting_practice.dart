import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';
import 'package:speed_cube_timer/utils/sizes.dart';

class SettingPractice extends StatelessWidget {
  final String text;
  final String value;
  final double width;
  final Function action;

  SettingPractice(this.text, this.value, this.width, this.action);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        width: width,
        height: KNOB_SIZE + 10
      ),
      margin: EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomText(text, size: 18),
          GestureDetector(
            onTap: action,
            child: Container(
              // constraints: BoxConstraints.expand(
              //   height: 20,
              //   width: width * 0.5
              // ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.12),
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: CustomText(value, size: 18, color: Colors.white70),
            )
          )
        ],
      )
    );
  }
}