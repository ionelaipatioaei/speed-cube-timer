import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/components/settings/input_with_submit.dart';
import 'package:speed_cube_timer/components/svg_icon_button.dart';
import 'package:speed_cube_timer/components/text_button.dart';
import 'package:speed_cube_timer/screens/add_practice.dart';
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
  Box settings = Hive.box("settings");

  List<Widget> genOptions(double width, List<String> names, int selected) {
    List<Widget> practicingOptions = List<Widget>();

    void removeOption(String name) {
      if (names.length > 1) {
        if (names[selected] == name) {
          settings.put("selected_option", 0);
          List<String> newOptions = names.where((option) => option != name).toList();
          settings.put("options", newOptions);
        } else {
          settings.put("selected_option", selected - 1);
          List<String> newOptions = names.where((option) => option != name).toList();
          settings.put("options", newOptions);
        }
      }
    }

    for (int i = 0; i < names.length; i++) {
      practicingOptions.add(
        TextSwitch(text: names[i], value: (i == selected), width: width, disabled: false, useValueToUpdate: true, 
        button: SvgIconButton("assets/icons/x.svg", "close icon", () => removeOption(names[i]), animate: true, margin: EdgeInsets.only(left: 8.0)), 
        onChange: (bool value) {
          if (!value) {
            settings.put("selected_option", i);
          }
        })
      );
    }
    return practicingOptions;
  }

  void addOption(String name) {
    List<String> names = settings.get("options", defaultValue: ["2x2x2", "3x3x3", "4x4x4", "5x5x5", "6x6x6", "7x7x7"]);
    // int selected = settings.get("selected_option", defaultValue: 0);

    List<String> newOptions = names.map((option) => option).toList();
    newOptions.add(name);

    settings.put("options", newOptions);
    print("works?");
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
            TopNavbar("Practicing", "assets/icons/crosshair.svg", "crosshair icon"),
            CustomListView(
              fixedWidget: TextButton("Add New Item", "", () => Navigator.push(context, CupertinoPageRoute(builder: (context) => AddPractice())), width: width),
              child: WatchBoxBuilder(
                box: Hive.box("settings"),
                watchKeys: ["options", "selected_option"],
                builder: (BuildContext context, Box box) {
                  return ListView(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05 + 8),
                    children: genOptions(width, box.get("options", defaultValue: ["2x2x2", "3x3x3", "4x4x4", "5x5x5", "6x6x6", "7x7x7"]), box.get("selected_option", defaultValue: 0))
                  );
                }
              )
            )
          ],
        )
      )
    );
  }
}