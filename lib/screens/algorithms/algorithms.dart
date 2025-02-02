import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/background.dart';

class Algorithms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Algorithms", "assets/icons/algorithm.svg", "icon which look like an algorithm"),
            CustomListView(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05),
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 160
                    ),
                    child: Center(
                      child: CustomText("Coming soon!", size: 28)
                    )
                  )
                ]
              )
            )
          ],
        ),
      )
    );
  }
}