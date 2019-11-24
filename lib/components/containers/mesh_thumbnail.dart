import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/containers/small_text_button.dart';

class MeshThumbnail extends StatefulWidget {
  final String src;
  final int index;
  final Function showAd;

  MeshThumbnail(this.src, this.index, this.showAd);

  @override
  State<StatefulWidget> createState() => _MeshThumbnailState();
}

class _MeshThumbnailState extends State<MeshThumbnail> {
  double overlayOpacity = 0.0;

  void animatePress() {
    setState(() => overlayOpacity = 0.26);
    Timer(Duration(milliseconds: 200), () => setState(() => overlayOpacity = 0.0));
    bool unlocked = Hive.box("unlocked").get("backgrounds")[widget.index];
    if (unlocked) {
      Hive.box("customize").put("mesh_gradient", widget.index);
    }
    // widget.action();
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
          child: WatchBoxBuilder(
            box: Hive.box("unlocked"),
            watchKeys: ["backgrounds"],
            builder: (BuildContext context, Box box) {
              bool unlocked = box.get("backgrounds")[widget.index];

              return !unlocked ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SmallTextButton("Unlock With Ad", () => widget.showAd(widget.index))
                ],
              ) : SizedBox(width: 0, height: 0);
            },
          )
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     SmallTextButton("Unlock With Ad", () => null)
          //   ],
          // ),
        )
      )
    );
  }
}