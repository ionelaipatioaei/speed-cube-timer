import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speed_cube_timer/components/common/double_text_button.dart';
import 'package:speed_cube_timer/components/common/text_button.dart';
import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/custom/custom_spacer.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class BrowseScramblesModal extends StatelessWidget {
  final Function changeScrambleName;
  final Function changeScrambleMoves;
  BrowseScramblesModal(this.changeScrambleName, this.changeScrambleMoves);

  List<Widget> genButtons(double width, Function close) {
    Box settings = Hive.box("settings");
    List<Widget> temp = List<Widget>();
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    List<String> defaultOptions = GenScramble.defaultOptions.where((option) => !options.contains(option)).toList();

    for (int i = 0; i < defaultOptions.length; i++) {
      String optionName = GenScramble.getOptionName(defaultOptions[i]);
      String name = GenScramble.getScrambleName(defaultOptions[i]);
      String moves = GenScramble.getScrambleMoves(defaultOptions[i]).join(",");
      temp.add(DoubleTextButton(name, "From: ${optionName}", width, () {
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
      temp.add(DoubleTextButton(name, "From: ${optionName}", width, () {
        changeScrambleName(name);
        changeScrambleMoves(moves);
        close();
      }, margin: EdgeInsets.only(bottom: 8.0), text0Size: 17, text1Size: 10));
    }
    temp.add(CustomSpacer(width, margin: EdgeInsets.only(bottom: 8.0)));

    temp.add(TextButton("Close", width, close));
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9 - 16.0;
    double marginSize = MediaQuery.of(context).size.width * 0.05;
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.black.withOpacity(0.12)
      ),
      margin: EdgeInsets.fromLTRB(marginSize, MediaQuery.of(context).padding.top + marginSize, marginSize, MediaQuery.of(context).padding.bottom + marginSize),
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          CustomListView(
            child: ListView(
              padding: EdgeInsets.only(top: 0.0),
              children: genButtons(width, () => Navigator.of(context).pop())
            )
          )
        ],
      )
    );
  }
}