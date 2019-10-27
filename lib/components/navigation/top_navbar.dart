import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_icon.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/utils/sizes.dart';

class TopNavbar extends StatelessWidget {
  final String title;

  final String src;
  final String alt;
  TopNavbar(this.title, this.src, this.alt);

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CustomIcon(src, alt, iconSize)
            ),
            Container(
              constraints: BoxConstraints.expand(
                width: MediaQuery.of(context).size.width - (iconSize * 2) - (28 + 8)
              ),
              margin: EdgeInsets.only(right: iconSize),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: CustomIcon(src, alt, 28),
                  ),
                  CustomText(title, size: 24)
                ],
              )
            )
          ],
        ),
      )
    );
  }
}