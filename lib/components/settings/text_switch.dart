import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/svg_icon_button.dart';
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
  final Widget button;

  TextSwitch({this.text, this.value, this.disabled, this.width, this.useValueToUpdate = false, this.onChange, this.button});

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
          button != null ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomSwitch(value: value, useValueToUpdate: useValueToUpdate, onChange: (bool value) => onChange(value), disabled: disabled),
              button
            ],
          ) : CustomSwitch(value: value, useValueToUpdate: useValueToUpdate, onChange: (bool value) => onChange(value), disabled: disabled),
        ],
      )
    );
  }
}