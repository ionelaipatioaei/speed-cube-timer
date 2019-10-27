import 'dart:ui';

import 'package:flutter/material.dart';

class CustomModal {
  static PageRouteBuilder createRoute(Widget child) {
    return PageRouteBuilder(
      opaque: false,
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget transitionChild) {
        Offset begin = Offset(0.0, 1.0);
        Offset end = Offset.zero;
        Curve curve = Curves.ease;
        Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: transitionChild,
        );
      },

      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: child
            ),
          ),
        );
      }
    );
  }
}