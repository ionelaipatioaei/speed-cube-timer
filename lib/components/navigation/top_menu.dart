import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:speed_cube_timer/components/svg_icon_button.dart';
// import 'package:speed_cube_timer/screens/algorithms.dart';
// import 'package:speed_cube_timer/screens/customize.dart';
// import 'package:speed_cube_timer/screens/settings.dart';
// import 'package:speed_cube_timer/screens/stats.dart';

import 'package:speed_cube_timer/utils/sizes.dart';

class TopMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: navbarHeight,
      // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
            // SvgIcon("assets/icons/chevron-left.svg", "back", 40),
            // SvgIconButton("assets/icons/pie-chart.svg", "pie-char icon", () => Navigator.push(context, CupertinoPageRoute(builder: (context) => Stats())), text: "Statistics", animate: false),
            // SvgIconButton("assets/icons/algorithm.svg", "step like icon", () => Navigator.push(context, CupertinoPageRoute(builder: (context) => Algorithms())), text: "Algorithms", animate: false),
            // SvgIconButton("assets/icons/sliders.svg", "slider icon", () => Navigator.push(context, CupertinoPageRoute(builder: (context) => Customize())), text: "Customize", animate: false),
            // SvgIconButton("assets/icons/settings.svg", "settings icon", () => Navigator.push(context, CupertinoPageRoute(builder: (context) => Settings())), text: "Settings", animate: false)
          ],
        ),
      )
    );
  }
}