import 'package:flutter/material.dart';

import 'package:speed_cube_timer/utils/sizes.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final bool disabled;
  final Function onChange;
  final bool useValueToUpdate;

  CustomSwitch({this.value, this.disabled, this.onChange, this.useValueToUpdate});

  @override
  State<StatefulWidget> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  static const double height = KNOB_SIZE + 4;
  static const double width = KNOB_SIZE * 2;
  // static const double size = 21.0;

  double marginMin = (height - KNOB_SIZE) / 2;
  double marginMax = width - KNOB_SIZE - ((height - KNOB_SIZE) / 2);

  bool selected;
  double currentMargin;

  void _onTap() {
    if (!widget.disabled) {
      widget.onChange(selected);
      setState(() {
        selected = !selected;
        currentMargin = selected ? marginMax : marginMin;
      });
    }
  }

  @override
  void initState() {
    selected = widget.value;
    currentMargin = widget.value ? marginMax : marginMin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useValueToUpdate) {
      setState(() {
        selected = widget.value;
        currentMargin = widget.value ? marginMax : marginMin;
      });
    }
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        constraints: BoxConstraints.expand(
          height: height,
          width: width
        ),
        // margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(height / 2)),
          // color: selected ? Color(0xff4DD964) : Colors.black.withOpacity(0.12),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              (selected && !widget.disabled) ? Color(0xff4DD964) : Colors.black.withOpacity(0.12), 
              (selected && !widget.disabled) ? Color(0xff78ffd6) : Colors.black.withOpacity(0.12)
              ]
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              constraints: BoxConstraints.expand(
                height: KNOB_SIZE,
                width: KNOB_SIZE
              ),
              margin: EdgeInsets.only(left: widget.disabled ? marginMin : currentMargin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(KNOB_SIZE / 2)),
                color: Colors.white
              ),
            ),
          ],
        )
      )
    );
  }
}