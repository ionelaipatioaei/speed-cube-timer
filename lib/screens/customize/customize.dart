import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

class Customize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomText("Hello!"),
      ),
    );
  }
}