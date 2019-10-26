import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/components/settings/input_with_submit.dart';
import 'package:speed_cube_timer/components/svg_icon_button.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/shared/custom_list_view.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';
import 'package:speed_cube_timer/components/settings/text_switch.dart';

class SelectPractice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectPracticeState();
}

class _SelectPracticeState extends State<SelectPractice>{

  bool x3 = true;

  List<String> names = ["3x3x3", "2x2x2", "4x4x4", "5x5x5", "6x6x6", "3x3x3", "2x2x2", "4x4x4", "5x5x5", "6x6x6", "2x2x2", "4x4x4", "5x5x5", "6x6x6", "5x5x5", "6x6x6", "2x2x2", "4x4x4", "5x5x5", "6x6x6"];
  List<bool> selected = [true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

  @override
  void initState() {
    print(selected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;

    List<Widget> practicingOptions = List<Widget>();
    // practicingOptions.add(InputWithSubmit(width: width));
    for (int i = 0; i < selected.length; i++) {
      practicingOptions.add(
        TextSwitch(text: names[i], value: selected[i], width: width, disabled: false, useValueToUpdate: true, 
        button: SvgIconButton("assets/icons/x.svg", "close icon", () => null, animate: true, margin: EdgeInsets.only(left: 8.0)), 
        onChange: (bool value) {
          for (int j = 0; j < selected.length; j++) {
            if (i == j) {
              setState(() => selected[i] = !value);
            } else {
              setState(() => selected[j] = false);
            }
          }
          print(selected);
        })
      );
    }

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Practicing", "assets/icons/crosshair.svg", "crosshair icon"),
            CustomListView(
              fixedWidget: InputWithSubmit(width: width),
              child: ListView(
                // shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05 + 8),
                children: practicingOptions
              ),
            )
          ],
        )
      )
    );
  }
}