import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:speed_cube_timer/components/navigation/top_navbar_menu.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;

  void changeBackground(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // myBanner..load()..show();
    return Scaffold(
      body: Background(
        [Colors.transparent, Colors.transparent],
        _currentIndex,
        child: Column(
          children: <Widget>[
            TopNavbarMenu(),
            // RaisedButton(onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => Stats())))
          ],
        ),
      )
    );
  }
}