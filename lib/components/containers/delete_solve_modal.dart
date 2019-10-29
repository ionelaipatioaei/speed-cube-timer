import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';

class DeleteSolveModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints.expand(
      //   // height: 250.0,
      //   height: MediaQuery.of(context).size.height * 0.9,
      //   width: MediaQuery.of(context).size.width * 0.9
      // ),
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: 100.0
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.black.withOpacity(0.12)
      ),
      child: Column(
        children: <Widget>[
          CustomText("Delete?")
        ],
      )
    );
  }
}