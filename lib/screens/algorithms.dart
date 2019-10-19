import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

class Algorithms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          children: <Widget>[
            TopNavbar("Algorithms", "assets/icons/algorithm.svg", "steps like icon")
          ],
        )
       )
    );
  }
}