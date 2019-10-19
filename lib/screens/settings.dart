import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/components/settings/setting_practice.dart';
import 'package:speed_cube_timer/shared/custom_slider.dart';
import 'package:speed_cube_timer/components/settings/text_switch.dart';
import 'package:speed_cube_timer/components/text_button.dart';
import 'package:speed_cube_timer/screens/privacy_policy.dart';
import 'package:speed_cube_timer/screens/select_practice.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/components/settings/setting_spacer.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool liveStopwatch;
  bool inspectionTime;
  bool inspectionTimeAutostart;
  bool scramblingSequence;

  @override
  void initState() {
    liveStopwatch = true;
    inspectionTime = true;
    inspectionTimeAutostart = true;
    scramblingSequence = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Settings", "assets/icons/settings.svg", "settings icon"),
            AdjustedContainer(
              child: Column(
                children: <Widget>[
                  SettingPractice("Practicing", "3x3x3", width, () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SelectPractice()))),
                  SettingSpacer(width),

                  TextSwitch(text: "Live Stopwatch", value: liveStopwatch, width: width, disabled: false, onChange: (bool value) {
                    setState(() => liveStopwatch = value);
                  }),
                  SettingSpacer(width),

                  TextSwitch(text: "Inspection Time", value: inspectionTime, width: width, disabled: false, onChange: (bool value) {
                    setState(() => inspectionTime = !inspectionTime);
                  }),
                  TextSwitch(text: "Autostart", value: inspectionTimeAutostart, width: width, disabled: !inspectionTime, onChange: (bool value) {
                    setState(() => inspectionTimeAutostart = !inspectionTimeAutostart);
                  }),
                  CustomSlider(value: 15, minValue: 0, maxValue: 60, width: width, disabled: !inspectionTime, onChange: (int value) {
                    print(value.toString());
                  }),
                  SettingSpacer(width),

                  TextSwitch(text: "Scrambling Sequence", value: scramblingSequence, width: width, disabled: false, onChange: (bool value) {
                    setState(() => scramblingSequence = !scramblingSequence);
                  }),
                  CustomSlider(value: 16, minValue: 0, maxValue: 32, width: width, disabled: !scramblingSequence, onChange: (int value) {
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