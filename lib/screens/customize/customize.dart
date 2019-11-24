import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/containers/buy_iap_button.dart';
import 'package:speed_cube_timer/components/containers/mesh_thumbnail.dart';
import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/utils/iap_config.dart';

class Customize extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomizeState();
}

class _CustomizeState extends State<Customize> {
  bool canWatchAd = false;

  Column genThumbnails() {
    List<Widget> thumbnails = List<Widget>();
    const int itemsPerRow = 3;
    int totalRows = (IAPConfig.totalBackgrounds + 1) ~/ itemsPerRow;
    int currentThumbnail = 0;

    for (int i = 0; i < totalRows; i++) {
      List<Widget> temp = List<Widget>();
      for (int j = 0; j < itemsPerRow; j++) {
        print("current thumbnail: $currentThumbnail");
        temp.add(MeshThumbnail("assets/gradients/mesh/gradient${currentThumbnail}_small.jpg", currentThumbnail, (int i) => handleRewardedAd(i)));
        currentThumbnail++;
      }
      thumbnails.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: temp
      ));
      // temp.clear();
    }

    return Column(
      children: thumbnails,
    );
  }

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>[]
  );

  void handleRewardedAd(int index) {
    if (canWatchAd) {
      RewardedVideoAd.instance.show();
    }
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        IAPConfig.updateBackground(index);
        setState(() => canWatchAd = false);
        // print("Background ${widget.index} was fucking updated!");
      }

      if (event == RewardedVideoAdEvent.loaded) {
        if (mounted) {
          setState(() => canWatchAd = true);
        }
      }

      if (event == RewardedVideoAdEvent.closed) {
        RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
      }
    };
  }

  @override
  void initState() {
    RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Customize", "assets/icons/sliders.svg", "sliders icon"),
            CustomListView(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05),
                children: <Widget>[
                  BuyIAPButton(bottomSpacer: true),
                  genThumbnails()
                ]
              )
            )
          ],
        ),
      )
    );
  }
}