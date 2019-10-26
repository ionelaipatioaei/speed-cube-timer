import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

import 'package:speed_cube_timer/components/svg_icon_button.dart';
import 'package:speed_cube_timer/shared/svg_icon.dart';
import 'package:speed_cube_timer/utils/sizes.dart';

class TopNavbar extends StatelessWidget {
  final String _title;
  final String _iconSrc;
  final String _iconAlt;
  TopNavbar(this._title, this._iconSrc, this._iconAlt);

  @override
  Widget build(BuildContext context) {
    const double iconHeight = 40;
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgIconButton("assets/icons/chevron-left.svg", "chevron left icon", () => Navigator.pop(context), iconHeight: iconHeight, animate: false),
            Container(
              constraints: BoxConstraints.expand(
                width: MediaQuery.of(context).size.width - (iconHeight * 2) - (28 + 8)
              ),
              margin: EdgeInsets.only(right: iconHeight),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: SvgIcon(_iconSrc, _iconAlt, 28),
                  ),
                  CustomText(_title, size: 24)
                ],
              )
            )
          ],
        ),
      )
    );
  }
}