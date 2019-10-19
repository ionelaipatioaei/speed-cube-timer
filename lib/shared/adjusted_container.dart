import 'package:flutter/material.dart';

class AdjustedContainer extends StatelessWidget {
  final Widget child;

  AdjustedContainer({this.child});

  @override
  Widget build(BuildContext context) {
    const double bottomBannerAdHeight = 60;
    return Expanded(
      child: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width
        ),
        // decoration: BoxDecoration(
        //   color: Colors.blue
        // ),
        margin: EdgeInsets.only(bottom: bottomBannerAdHeight),
        child: child
      )
    );
  }
}