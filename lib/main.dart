import 'package:flutter/material.dart';
import 'package:speed_cube_timer/screens/home.dart';

void main() async {

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Speed Cube Timer",
      home: Home()
    );
  }
}