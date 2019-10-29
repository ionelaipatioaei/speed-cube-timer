import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speed_cube_timer/components/custom/custom_button.dart';
import 'package:speed_cube_timer/components/custom/custom_icon.dart';

class CustomInput extends StatelessWidget {
  final double width;
  final TextEditingController controller;
  final String placeholder;
  final int maxLength;
  final Function onChange;

  CustomInput({this.width, this.controller, this.placeholder = "", this.maxLength, this.onChange});

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
            child: TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.white.withOpacity(0.8)),
                focusColor: Colors.white,
                border: InputBorder.none,
                counterText: "",
                contentPadding: EdgeInsets.all(0),
                // hasFloatingPlaceholder: true
              ),
              controller: controller,
              onChanged: (text) => onChange(text),
              maxLength: maxLength,
              inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
              autocorrect: false,
              style: TextStyle(fontFamily: "OpenSans", color: Colors.white),
              textAlignVertical: TextAlignVertical.center,
              cursorColor: Colors.white.withOpacity(0.5),
              cursorWidth: 1.0,
            )
          ),
          CustomButton(
            action: () => FocusScope.of(context).unfocus(),
            constraints: BoxConstraints.expand(
              height: 26,
              width: 26
            ),
            borderRadius: 26,
            startOpacity: 0.0,
            endOpacity: 0.2,
            child: CustomIcon("assets/icons/check.svg", "check icon", 26),
          )
        ],
      ),
    );
  }
}