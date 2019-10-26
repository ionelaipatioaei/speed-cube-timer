import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/customize/small_text_button.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

class MeshThumbnail extends StatefulWidget {
  final String src;

  final Function action;

  MeshThumbnail(this.src, this.action);

  @override
  State<StatefulWidget> createState() => _MeshThumbnailState();
}

class _MeshThumbnailState extends State<MeshThumbnail> {
  double overlayOpacity = 0.0;

  void animatePress() {
    setState(() => overlayOpacity = 0.26);
    Timer(Duration(milliseconds: 200), () => setState(() => overlayOpacity = 0.0));
    widget.action();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.3 - 12;
    double width = MediaQuery.of(context).size.width * 0.3 - 12;

    return GestureDetector(
      onTap: animatePress,
      child: Container(
        constraints: BoxConstraints.expand(
          height: height,
          width: width
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.src),
            fit: BoxFit.fill,
            // colorFilter: ColorFilter.mode(Colors.black.withOpacity(overlayOpacity), BlendMode.saturation)
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0))
        ),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.black.withOpacity(overlayOpacity),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SmallTextButton("Unlock With Ad", () => null),
              SmallTextButton("Buy All", () => null),
            ],
          ),
        )
      )
    );
  }
}