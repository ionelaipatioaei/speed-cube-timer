import 'package:flutter/material.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

import 'package:speed_cube_timer/components/svg_icon_button.dart';
import 'package:speed_cube_timer/shared/svg_icon.dart';

class TopNavbar extends StatelessWidget {
  final String _title;
  final String _iconSrc;
  final String _iconAlt;
  TopNavbar(this._title, this._iconSrc, this._iconAlt);

  @override
  Widget build(BuildContext context) {
    const double navbarHeight = 54;
    const double iconHeight = 40;
    print(MediaQuery.of(context).padding.top);
    return Container(
      // height: navbarHeight,
      // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        constraints: BoxConstraints.expand(
          height: navbarHeight + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width
        ),
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.12)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgIconButton("assets/icons/chevron-left.svg", "chevron left icon", () => Navigator.pop(context), iconHeight: iconHeight),
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