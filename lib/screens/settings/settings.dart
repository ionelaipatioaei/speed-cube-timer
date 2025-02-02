import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/common/text_button.dart';
import 'package:speed_cube_timer/components/containers/buy_iap_button.dart';
import 'package:speed_cube_timer/components/containers/item_view.dart';
import 'package:speed_cube_timer/components/custom/custom_button.dart';

import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/custom/custom_slider.dart';
import 'package:speed_cube_timer/components/custom/custom_spacer.dart';
import 'package:speed_cube_timer/components/custom/custom_switch.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/screens/info/credits.dart';
import 'package:speed_cube_timer/screens/info/privacy_policy.dart';
import 'package:speed_cube_timer/screens/settings/select_practice.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Box settings = Hive.box("settings");

  bool liveStopwatch;
  bool allowInspectionTime;
  int inspectionTime;
  bool showScramblingSequence;
  int scramblingSequenceLength;

  @override
  void initState() {
    liveStopwatch = settings.get("live_stopwatch", defaultValue: true);
    allowInspectionTime = settings.get("allow_inspection_time", defaultValue: false);
    inspectionTime = settings.get("inspection_time", defaultValue: 15000);
    showScramblingSequence = settings.get("show_scrambling_sequence", defaultValue: true);
    scramblingSequenceLength = settings.get("scrambling_sequence_length", defaultValue: 16);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double sliderOffset = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Settings", "assets/icons/settings.svg", "settings icon"),
            CustomListView(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05),
                children: <Widget>[
                  WatchBoxBuilder(
                    box: Hive.box("settings"),
                    watchKeys: ["options", "selected_option"],
                    builder: (BuildContext context, Box box) {
                      List<String> options = box.get("options", defaultValue: GenScramble.defaultOptions);
                      int selectedOption = box.get("selected_option", defaultValue: 0);
                      String optionName = GenScramble.getOptionName(options[selectedOption]);
                      return ItemView(width: width, children: <Widget>[
                        CustomText("Practicing", size: 18),
                        CustomButton(
                          action: () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => SelectPractice())),
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          borderRadius: 20.0,
                          child: CustomText(optionName, color: Colors.white),
                        )
                      ]);
                    }
                  ),
                  CustomSpacer(width),

                  ItemView(width: width, children: <Widget>[
                    CustomText("Live Stopwatch", size: 18),
                    CustomSwitch(value: liveStopwatch, useValueToUpdate: false, disabled: false, onChange: (bool value) {
                      settings.put("live_stopwatch", !value);
                      setState(() => liveStopwatch = value);
                    })
                  ]),
                  CustomSpacer(width),

                  ItemView(width: width, children: <Widget>[
                    CustomText("Inspection Time", size: 18),
                    CustomSwitch(value: allowInspectionTime, useValueToUpdate: false, disabled: false, onChange: (bool value) {
                      settings.put("allow_inspection_time", !value);
                      setState(() => allowInspectionTime = !allowInspectionTime);
                    })
                  ]),
                  CustomSlider(value: inspectionTime ~/ 1000, minValue: 0, maxValue: 60, width: width, disabled: !allowInspectionTime, offset: sliderOffset, onChange: (int value) {
                    settings.put("inspection_time", value * 1000);
                    print(value.toString());
                  }),
                  CustomSpacer(width),

                  ItemView(width: width, children: <Widget>[
                    CustomText("Scrambling Sequence", size: 18),
                    CustomSwitch(value: showScramblingSequence, useValueToUpdate: false, disabled: false, onChange: (bool value) {
                      settings.put("show_scrambling_sequence", !value);
                      setState(() => showScramblingSequence = !showScramblingSequence);
                    })
                  ]),
                  CustomSlider(value: scramblingSequenceLength, minValue: 0, maxValue: 32, width: width, disabled: !showScramblingSequence, offset: sliderOffset, onChange: (int value) {
                    settings.put("scrambling_sequence_length", value);
                    print(value.toString());
                  }),
                  CustomSpacer(width),

                  TextButton("Privacy Policy", width, () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => PrivacyPolicy())), margin: EdgeInsets.only(bottom: 10.0)),
                  TextButton("Credits", width, () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => Credits()))),

                  BuyIAPButton()
                ]
              )
            )
          ],
        )
      )
    );
  }
}