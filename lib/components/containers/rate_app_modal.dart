import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:launch_review/launch_review.dart'; 

import 'package:speed_cube_timer/components/common/text_button.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

class RateAppModal extends StatelessWidget {
  final Box settings = Hive.box("settings");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9 - 16.0;
    double buttonWidth = (width / 3) - 4.0;

    return Container(
      constraints: BoxConstraints.expand(
        // height: 250.0,
        height: 120,
        width: MediaQuery.of(context).size.width * 0.9
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.black.withOpacity(0.12)
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomText("If you enjoy using Speed Cube Timer, please take a few seconds to rate it. Thanks!", align: TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton("Never", buttonWidth, () {
                settings.put("reviewed", true);
                Navigator.of(context).pop();
              }),
              TextButton("Later", buttonWidth, () => Navigator.of(context).pop()),
              TextButton("Sure", buttonWidth, () {
                settings.put("reviewed", true);
                LaunchReview.launch();
                Navigator.of(context).pop();
              })
            ],
          )
        ],
      )
    );
  }
}