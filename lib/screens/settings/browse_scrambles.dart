import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speed_cube_timer/components/common/double_text_button.dart';
import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/custom/custom_spacer.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class BrowseScrambles extends StatelessWidget {
  final Function changeScrambleName;
  final Function changeScrambleMoves;
  BrowseScrambles(this.changeScrambleName, this.changeScrambleMoves);

  List<Widget> genButtons(double width, Function close) {
    Box settings = Hive.box("settings");
    List<Widget> temp = List<Widget>();
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    List<String> defaultOptions = GenScramble.defaultOptions.where((option) => !options.contains(option)).toList();

    for (int i = 0; i < defaultOptions.length; i++) {
      String optionName = GenScramble.getOptionName(defaultOptions[i]);
      String name = GenScramble.getScrambleName(defaultOptions[i]);
      String moves = GenScramble.getScrambleMoves(defaultOptions[i]).join(",");
      temp.add(DoubleTextButton(name, "From: $optionName", width, () {
        changeScrambleName(name);
        changeScrambleMoves(moves);
        close();
      }, margin: EdgeInsets.only(bottom: 8.0), text0Size: 17, text1Size: 10));
    }
    if (defaultOptions.isNotEmpty) {
      temp.add(CustomSpacer(width, margin: EdgeInsets.only(bottom: 8.0)));
    }

    for (int i = 0; i < options.length; i++) {
      String optionName = GenScramble.getOptionName(options[i]);
      String name = GenScramble.getScrambleName(options[i]);
      String moves = GenScramble.getScrambleMoves(options[i]).join(",");
      temp.add(DoubleTextButton(name, "From: $optionName", width, () {
        changeScrambleName(name);
        changeScrambleMoves(moves);
        close();
      }, margin: EdgeInsets.only(bottom: 8.0), text0Size: 17, text1Size: 10));
    }
    return temp;
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
            TopNavbar("Scrambles", "assets/icons/layers.svg", "layers icon"),
            CustomListView(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05),
                children: genButtons(width, () => Navigator.of(context).pop())
              )
            )
          ],
        ),
      )
    );
  }
}