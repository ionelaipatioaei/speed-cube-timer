import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_switch.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';
import 'package:speed_cube_timer/utils/sizes.dart';

class TextSwitch extends StatelessWidget {
  final String text;
  final double width;
  final bool value;
  final bool disabled;
  final Function onChange;
  final bool useValueToUpdate;

  TextSwitch({this.text, this.value, this.disabled, this.width, this.useValueToUpdate = false, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        width: width,
        height: KNOB_SIZE + 10
      ),
      // margin: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomText(text, size: 18),
          CustomSwitch(value: value, useValueToUpdate: useValueToUpdate, onChange: (bool value) => onChange(value), disabled: disabled)
        ],
      )
    );
  }
}