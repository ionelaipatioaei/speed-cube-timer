import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/common/text_button.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

class AddPracticeWarningModal extends StatelessWidget {
  final String message;
  AddPracticeWarningModal(this.message);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9 - 16.0;

    return Container(
      constraints: BoxConstraints.expand(
        // height: 250.0,
        height: 120,
        width: MediaQuery.of(context).size.width * 0.9
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.black.withOpacity(0.12)
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomText(message, align: TextAlign.center),
          TextButton("OK", width, () => Navigator.of(context).pop())
        ],
      )
    );
  }
}