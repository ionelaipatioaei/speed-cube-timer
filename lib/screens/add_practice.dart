import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/components/settings/input_with_submit.dart';
import 'package:speed_cube_timer/components/svg_icon_button.dart';
import 'package:speed_cube_timer/components/text_button.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/shared/custom_list_view.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';
import 'package:speed_cube_timer/components/settings/text_switch.dart';

class AddPractice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPracticeState();
}

class _AddPracticeState extends State<AddPractice>{
  Box settings = Hive.box("settings");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Add New Item", "assets/icons/plus-circle.svg", "plus inside a circle icon"),
            CustomListView(
              // fixedWidget: InputWithSubmit(() => addOption("8x8x8"), width: width),
              child: WatchBoxBuilder(
                box: Hive.box("settings"),
                watchKeys: ["options", "selected_option"],
                builder: (BuildContext context, Box box) {
                  return ListView(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05 + 8),
                    children: <Widget>[
                      CustomText("Name: 3x3x3 OH"),
                      InputWithSubmit(() => null, width: width - 16),

                      CustomText("Scramble sequence: 3x3x3"),

                      CustomText("New scramble sequence: 3x3x3 OH"),
                      CustomText("New scramble moves: R' F2"),
                      InputWithSubmit(() => null, width: width - 16),
                      TextButton("Save", "", () {
                        Navigator.of(context).push(
      // We will now use PageRouteBuilder
      PageRouteBuilder(
        opaque: false,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
        pageBuilder: (BuildContext context, var a, var a2) {
          return new Scaffold(
            backgroundColor: Colors.transparent,
            body: new Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 250),
              
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.12),
              borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              alignment: Alignment.center,
            child: CustomText("HELLO", size: 32,),
          ),
        ),
              // child: new FlatButton(
              //    child: Text('Close'),
              //    onPressed: () {
              //      Navigator.pop(context);
              //    }
              // ), // FlatButton
            ), // Container
          ); // Scaffold
        }
      )
    );
                      })
                    ]
                  );
                }
              )
            )
          ],
        )
      )
    );
  }
}