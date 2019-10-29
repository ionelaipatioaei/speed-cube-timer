import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

import 'package:speed_cube_timer/utils/sizes.dart';

class CustomSlider extends StatefulWidget {
  final int value;
  final double width;
  final int minValue;
  final int maxValue;
  final bool disabled;
  final double offset;

  final Function onChange;

  CustomSlider({this.value, this.width, this.minValue, this.maxValue, this.disabled, this.offset, this.onChange});

  @override
  State<StatefulWidget> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  static const double lineHeight = 8;

  double step;
  double knobX;
  int calculatedValue;

  int sliderAnimationDuration = 100;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!widget.disabled) {
      // print("local: ${details.localPosition.dx} | global: ${details.globalPosition.dx}");
      setState(() => sliderAnimationDuration = 0);
      double dx = details.globalPosition.dx - widget.offset;
      // double dx = details.localPosition.dx;
      if (dx < (widget.width - (KNOB_SIZE / 2)) && dx > KNOB_SIZE / 2) {
        setState(() => knobX = dx);
      } else if (dx < 0.0) {
        setState(() => knobX = KNOB_SIZE / 2);
      } else if (dx > widget.width) {
        setState(() => knobX = widget.width - (KNOB_SIZE / 2));
      }
      int val = ((knobX - KNOB_SIZE / 2) / step).round();
      if (val != calculatedValue) {
        setState(() => calculatedValue = val);
        // widget.onChange(val);
        // print("calculated value: $calculatedValue | $val");
      }
    }
  }

  // I can also update the value only after the users lifts the finger from the slider
  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() => sliderAnimationDuration = 100);
    widget.onChange(calculatedValue);
  }

  @override
  void initState() {
    step = (widget.width - KNOB_SIZE) / (widget.maxValue - widget.minValue);
    knobX = (widget.value * step) + (KNOB_SIZE / 2);
    calculatedValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: _onTap,
      // onHorizontalDragStart: (DragStartDetails details) => _onHorizontalDragStart(details),
      onHorizontalDragEnd: (DragEndDetails details) => _onHorizontalDragEnd(details),
      onHorizontalDragUpdate: (DragUpdateDetails details) => _onHorizontalDragUpdate(details),
      child: Container(
        constraints: BoxConstraints.expand(
          height: KNOB_SIZE,
          width: widget.width
        ),
        margin: EdgeInsets.only(top: 8.0),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: (KNOB_SIZE - lineHeight) / 2,
              child: Container(
                constraints: BoxConstraints.expand(
                  height: lineHeight,
                  width: widget.width
                ),
                // margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(lineHeight / 2)),
                  color: Colors.black.withOpacity(0.12)
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: (KNOB_SIZE - lineHeight) / 2,
              child: AnimatedContainer(
                duration: Duration(milliseconds: sliderAnimationDuration),
                constraints: BoxConstraints.expand(
                  height: lineHeight,
                  width: knobX
                ),
                // margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(lineHeight / 2)),
                  // color: Color(0xff4DD964),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [widget.disabled ? Color(0xff939393) : Color(0xff4DD964), widget.disabled ? Color(0xffbbbbbb) : Color(0xff78ffd6)]
                  )
                ),
              ),
            ),
            Positioned(
              left: knobX - KNOB_SIZE / 2,
              top: 0,
              child: Container(
                constraints: BoxConstraints.expand(
                  height: KNOB_SIZE,
                  width: KNOB_SIZE
                ),
                // margin: EdgeInsets.only(left: currentMargin),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(KNOB_SIZE / 2)),
                  color: Colors.white
                ),
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 1),
                  child: CustomText(calculatedValue.toString(), size: 11, color: Colors.black26, weight: FontWeight.w700),
                )
              ),
            ),
          ],
        )
      )
    );
  }
}