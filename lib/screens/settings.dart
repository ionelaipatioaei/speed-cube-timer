import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        [Colors.transparent, Colors.transparent],
        1,
        child: Column(
          children: <Widget>[
            TopNavbar("Settings", "assets/icons/settings.svg", "settings icon")
          ],
        )
       )
    );
  }
}