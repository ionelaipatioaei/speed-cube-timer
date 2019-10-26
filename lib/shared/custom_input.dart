import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final bool value;
  final bool disabled;
  final Function onChange;
  final bool useValueToUpdate;

  CustomInput({this.value, this.disabled, this.onChange, this.useValueToUpdate});

  @override
  State<StatefulWidget> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  void initState() {
    // selected = widget.value;
    // currentMargin = widget.value ? marginMax : marginMin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Add new item",
        hintStyle: TextStyle(fontFamily: "OpenSans", color: Colors.white.withOpacity(0.8)),
        focusColor: Colors.white,
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
        // hasFloatingPlaceholder: true
      ),
      autocorrect: false,
      style: TextStyle(fontFamily: "OpenSans", color: Colors.white),
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Colors.white.withOpacity(0.5),
      cursorWidth: 1.0,
    );
  }
}