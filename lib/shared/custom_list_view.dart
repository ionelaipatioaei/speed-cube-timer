import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';

class CustomListView extends StatelessWidget {
  final Widget child;
  final Widget fixedWidget;
  CustomListView({this.fixedWidget, this.child});

  @override
  Widget build(BuildContext context) {
    return AdjustedContainer(
      child: Column(
        children: fixedWidget != null ? <Widget>[
          fixedWidget,
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.white,
                child: child
              ),
            )
          )
        ] : <Widget>[
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.white,
                child: child
              ),
            )
          )
        ]
      )
    );
  }
}