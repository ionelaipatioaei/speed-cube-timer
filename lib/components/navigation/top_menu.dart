import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/common/menu_button.dart';
import 'package:speed_cube_timer/screens/algorithms/algorithms.dart';
import 'package:speed_cube_timer/screens/customize/customize.dart';
import 'package:speed_cube_timer/screens/settings/settings.dart';
import 'package:speed_cube_timer/screens/statistics/statistics.dart';

import 'package:speed_cube_timer/utils/sizes.dart';

class TopMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        constraints: BoxConstraints.expand(
          height: NAVBAR_HEIGHT + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width
        ),
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.12),
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.white)
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MenuButton("Statistics", "assets/icons/pie-chart.svg", "pie chart icon", 
              () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => Statistics()))
            ),
            MenuButton("Algorithms", "assets/icons/algorithm.svg", "step like icon", 
              () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => Algorithms()))
            ),
            MenuButton("Customize", "assets/icons/sliders.svg", "slider icon", 
              () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => Customize()))
            ),
            MenuButton("Settings", "assets/icons/settings.svg", "settings icon", 
              () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => Settings()))
            )
          ],
        ),
      )
    );
  }
}