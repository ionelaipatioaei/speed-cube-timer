import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

class Home extends StatefulWidget {
  final String text;
  Home(this.text);
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['rubik cube', 'beautiful apps'],
  );

  BannerAd myBanner = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  @override
  Widget build(BuildContext context) {
    myBanner..load()..show();
    return Scaffold(
      body: Center(
        child: Text(widget.text)
      ),
    );
  }
}