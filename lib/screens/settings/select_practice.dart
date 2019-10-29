import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speed_cube_timer/components/common/text_button.dart';
import 'package:speed_cube_timer/components/containers/delete_item_modal.dart';
import 'package:speed_cube_timer/components/containers/item_view.dart';
import 'package:speed_cube_timer/components/custom/custom_button.dart';
import 'package:speed_cube_timer/components/custom/custom_icon.dart';
import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/custom/custom_modal.dart';
import 'package:speed_cube_timer/components/custom/custom_switch.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/screens/settings/add_practice.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class SelectPractice extends StatelessWidget {
  Box settings = Hive.box("settings");

  List<Widget> genOptions(BuildContext context, double width, List<String> options, int selected) {
    List<Widget> practicingOptions = List<Widget>();

    void removeOption(String name) {
      if (options.length > 1) {
        settings.put("selected_option", selected - 1 >= 0 ? selected - 1 : 0);
        List<String> newOptions = options.where((option) => GenScramble.getOptionName(option) != name).toList();
        settings.put("options", newOptions);
      }
    }

    for (int i = 0; i < options.length; i++) {
      practicingOptions.add(
        ItemView(width: width, children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomText(GenScramble.getOptionName(options[i]), size: 18),
              SizedBox(width: 4.0),
              CustomText(GenScramble.getScrambleName(options[i]), size: 10, color: Colors.white54),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomSwitch(value: (i == selected), disabled: false, useValueToUpdate: true, onChange: (bool value) {
                if (!value) {
                  settings.put("selected_option", i);
                }
              }),
              CustomButton(
                action: () => Navigator.of(context).push(CustomModal.createRoute(DeleteItemModal(
                  "Do you want to delete ${GenScramble.getOptionName(options[i])}?", () => removeOption(GenScramble.getOptionName(options[i]))
                ))),
                constraints: BoxConstraints.expand(
                  height: 26,
                  width: 26
                ),
                borderRadius: 26,
                startOpacity: 0.0,
                endOpacity: 0.2,
                margin: EdgeInsets.only(left: 4.0),
                child: CustomIcon("assets/icons/x.svg", "close icon", 26)
              )
            ],
          )
        ])
      );
    }
    return practicingOptions;
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
              fixedWidget: TextButton("Add New Item", width, () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => AddPractice())), margin: EdgeInsets.only(top: 16.0, bottom: 8.0)),
              child: WatchBoxBuilder(
                box: Hive.box("settings"),
                watchKeys: ["options", "selected_option"],
                builder: (BuildContext context, Box box) {
                  return ListView(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05 + 8),
                    children: genOptions(context, width, box.get("options", defaultValue: GenScramble.defaultOptions), box.get("selected_option", defaultValue: 0))
                  );
                }
              )
            )
          ],
        ),
      )
    );
  }
}