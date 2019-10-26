import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/svg_icon_button.dart';
import 'package:speed_cube_timer/shared/custom_input.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

class InputWithSubmit extends StatelessWidget {
  final double width;

  InputWithSubmit({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        width: width,
        height: 36
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.all(Radius.circular(18))
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(
              width: width - 50
            ),
            alignment: Alignment.center,
            child: CustomInput(),
          ),
          SvgIconButton("assets/icons/check.svg", "check icon", () => null, animate: true)
        ],
      ),
    );
  }
}