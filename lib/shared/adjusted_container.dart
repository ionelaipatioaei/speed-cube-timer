import 'package:flutter/material.dart';

class AdjustedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  AdjustedContainer({this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    const double bottomBannerAdHeight = 0.0;
    return Expanded(
      child: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width
        ),
        // decoration: BoxDecoration(
        //   color: Colors.blue
        // ),
        padding: padding,
        margin: EdgeInsets.only(bottom: bottomBannerAdHeight),
        child: child
      )
    );
  }
}