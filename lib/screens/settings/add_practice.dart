import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speed_cube_timer/components/common/text_button.dart';
import 'package:speed_cube_timer/components/containers/add_pratice_warning_modal.dart';
import 'package:speed_cube_timer/components/containers/browse_scrambles_modal.dart';
import 'package:speed_cube_timer/components/custom/custom_input.dart';
import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/custom/custom_modal.dart';
import 'package:speed_cube_timer/components/custom/custom_spacer.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';

class AddPractice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPracticeState();
}

class _AddPracticeState extends State<AddPractice> {
  TextEditingController scrambleNameController = TextEditingController();
  TextEditingController scrambleMovesController = TextEditingController();

  String name;
  String scrambleName;
  String scrambleMoves;

  void updateScrambleName(String text) {
    scrambleNameController.text = text;
    setState(() => scrambleName = text);
  }

  void updateScrambleMoves(String text) {
    scrambleMovesController.text = text;
    setState(() => scrambleMoves = text);
  }

  void save(BuildContext context, Function close) {
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    List<String> names = options.map((option) => GenScramble.getOptionName(option)).toList();
    List<String> newOptions = options.map((option) => option).toList();

    if (!names.contains(name)) {
      if (name.length > 2) {
        if (scrambleName.length > 2) {
          if (scrambleMoves.length > 2) {
            newOptions.add("$name:$scrambleName:$scrambleMoves");
            settings.put("options", newOptions);
            close();
          } else {
            Navigator.of(context).push(CustomModal.createRoute(AddPracticeWarningModal("Scramble moves needs to be at least 3 characters long!")));
          }
        } else {
          Navigator.of(context).push(CustomModal.createRoute(AddPracticeWarningModal("Scramble name needs to be at least 3 characters long!")));
        }
      } else {
        Navigator.of(context).push(CustomModal.createRoute(AddPracticeWarningModal("The name needs to be at least 3 characters long!")));
      }
    } else {
      Navigator.of(context).push(CustomModal.createRoute(AddPracticeWarningModal("Practice with the name $name already exists!")));
    }
  }

  @override
  void initState() {
    name = "";
    scrambleName = "";
    scrambleMoves = "";
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
            TopNavbar("Add Item", "assets/icons/plus-circle.svg", "plus circle icon"),
            CustomListView(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05),
                children: <Widget>[
                  CustomText("Name: $name", size: 18),
                  CustomInput(width: width, placeholder: "Name", maxLength: 12, onChange: (text) {
                    setState(() => name = text);
                  }),
                  CustomSpacer(width),

                  CustomText("Scramble Name: $scrambleName", size: 18),
                  CustomInput(width: width, placeholder: "Scramble Name", maxLength: 12, controller: scrambleNameController, onChange: (text) {
                    setState(() => scrambleName = text);
                  }),
                  CustomSpacer(width),

                  CustomText("Scramble Moves:", size: 18),
                  CustomText("$scrambleMoves", size: 18),
                  CustomInput(width: width, placeholder: "Scramble Moves", controller: scrambleMovesController, onChange: (text) {
                    setState(() => scrambleMoves = text);
                  }),
                  CustomText("Note: Separate the moves using ',' with no spaces.", size: 10, color: Colors.white70),
                  CustomSpacer(width),

                  TextButton("Browse Scrambles", width, 
                    () => Navigator.of(context).push(CustomModal.createRoute(BrowseScramblesModal(
                      (text) => updateScrambleName(text), (text) => updateScrambleMoves(text)
                    ))), 
                    margin: EdgeInsets.only(bottom: 10.0)
                  ),
                  TextButton("Save", width, () => save(context, () => Navigator.of(context).pop()))
                ]
              )
            )
          ],
        ),
      )
    );
  }
}