import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/components/settings/setting_practice.dart';
import 'package:speed_cube_timer/shared/custom_list_view.dart';
import 'package:speed_cube_timer/shared/custom_slider.dart';
import 'package:speed_cube_timer/components/settings/text_switch.dart';
import 'package:speed_cube_timer/components/text_button.dart';
import 'package:speed_cube_timer/screens/privacy_policy.dart';
import 'package:speed_cube_timer/screens/select_practice.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/components/settings/setting_spacer.dart';

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
                      List<String> options = box.get("options", defaultValue: ["2x2x2", "3x3x3", "4x4x4", "5x5x5", "6x6x6", "7x7x7"]);
                      int selectedOption = box.get("selected_option", defaultValue: 0);
                      return SettingPractice("Practicing", options[selectedOption], width, () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SelectPractice())));
                    }
                  ),
                  SettingSpacer(width),

                  TextSwitch(text: "Live Stopwatch", value: liveStopwatch, width: width, disabled: false, onChange: (bool value) {
                    // the values seems to be inversed, too lazy to fix
                    settings.put("live_stopwatch", !value);
                    setState(() => liveStopwatch = value);
                  }),
                  SettingSpacer(width),

                  TextSwitch(text: "Inspection Time", value: allowInspectionTime, width: width, disabled: false, onChange: (bool value) {
                    settings.put("allow_inspection_time", !value);
                    setState(() => allowInspectionTime = !allowInspectionTime);
                  }),
                  CustomSlider(value: inspectionTime ~/ 1000, minValue: 0, maxValue: 60, width: width, disabled: !allowInspectionTime, offset: sliderOffset, onChange: (int value) {
                    settings.put("inspection_time", value * 1000);
                    print(value.toString());
                  }),
                  SettingSpacer(width),

                  TextSwitch(text: "Scrambling Sequence", value: showScramblingSequence, width: width, disabled: false, onChange: (bool value) {
                    settings.put("show_scrambling_sequence", !value);
                    setState(() => showScramblingSequence = !showScramblingSequence);
                  }),
                  CustomSlider(value: scramblingSequenceLength, minValue: 0, maxValue: 32, width: width, disabled: !showScramblingSequence, offset: sliderOffset, onChange: (int value) {
                    settings.put("scrambling_sequence_length", value);
                    print(value.toString());
                  }),
                  SettingSpacer(width),

                  TextButton("Privacy Policy", "", () => Navigator.push(context, CupertinoPageRoute(builder: (context) => PrivacyPolicy())), width: width),
                  TextButton("Remove Ads &", "Unlock All Customizations", () => null, width: width)
                ],
              )
            )
          ],
        )
      )
    );
  }
}