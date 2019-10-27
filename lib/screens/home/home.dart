import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/background.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background()
    );
  }
}