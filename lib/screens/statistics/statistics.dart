import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/utils/solve.dart';

class Statistics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatisticsState();
} 

class _StatisticsState extends State<Statistics> {
  List<int> stats;

  void init() async {
    List<int> temp = await Solve.getStats(6);
    setState(() => stats = temp);
    print(stats);
    await Solve.updateBottomStats();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Statistics", "assets/icons/pie-chart.svg", "pie chart icon"),
            CustomListView(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05),
                children: <Widget>[
                  CustomText("Statistics")
                ]
              )
            )
          ],
        ),
      )
    );
  }
}