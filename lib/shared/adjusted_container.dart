import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AdjustedContainer extends StatelessWidget {  
  final Widget child;
  final EdgeInsets padding;

  AdjustedContainer({this.child, this.padding});
  @override
  Widget build(BuildContext context) {
    const double bottomBannerAdHeight = 50.0;
    return Expanded(
      child: WatchBoxBuilder(
        box: Hive.box("unlocked"),
        watchKeys: ["remove_all_ads_unlock_all_customizations"],
        builder: (BuildContext context, Box box) {
          bool purchased = box.get("remove_all_ads_unlock_all_customizations", defaultValue: false);
          return Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width
            ),
            padding: padding,
            margin: EdgeInsets.only(bottom: purchased ? 0.0 : (bottomBannerAdHeight + MediaQuery.of(context).padding.bottom)),
            child: child
          );
        }
      )
    );
  }
}