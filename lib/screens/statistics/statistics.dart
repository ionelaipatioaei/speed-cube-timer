import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speed_cube_timer/components/custom/custom_list_view.dart';
import 'package:speed_cube_timer/components/custom/custom_text.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/utils/format_time.dart';
import 'package:speed_cube_timer/utils/gen_scramble.dart';
import 'package:speed_cube_timer/utils/sizes.dart';
import 'package:speed_cube_timer/utils/solve.dart';

class Statistics extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatisticsState();
} 

class _StatisticsState extends State<Statistics> {
  Box statistics = Hive.box("statistics");
  Box settings = Hive.box("settings");

  List<int> stats;
  double minValue;
  double maxValue;
  List<FlSpot> spots;
  double interval;

  void init() async {
    List<int> temp = await Solve.getStats(30);
    Future.delayed(Duration(milliseconds: 300), () =>
      setState(() {
        if (temp.length >= 2) {
          stats = temp;
          minValue = stats.reduce(min) / 1000;
          maxValue = stats.reduce(max) / 1000;
          spots = genSpots(stats);
          interval = (maxValue - minValue) / stats.length;
        }
      })
    );
    print(stats);
  }

  @override
  void initState() {
    Box statistics = Hive.box("statistics");
    Box settings = Hive.box("settings");
    List<String> options = settings.get("options", defaultValue: GenScramble.defaultOptions);
    int selected = settings.get("selected_option", defaultValue: 0);
    String name = GenScramble.getOptionName(options[selected]);

    stats = [statistics.get("stats_${name}_worst_time", defaultValue: 1000), statistics.get("stats_${name}_best_time", defaultValue: 0)];
    minValue = stats.reduce(min) / 1000;
    maxValue = stats.reduce(max) / 1000;
    spots = genSpots(stats);
    interval = (maxValue - minValue) / stats.length;
    init();
    super.initState();
  }

  List<FlSpot> genSpots(List<int> data) {
    List<FlSpot> temp = List<FlSpot>();
    data.asMap().forEach((int i, int value) {
      // print("i: $i | value: $value");
      temp.add(FlSpot(i.toDouble(), value / 1000));
    });
    return temp;
  }

  String getSideTime(double value) {
    // print("VALUE: $value");
    return msToMinutes((value * 1000).toInt(), small: true) + "   ";
  }

  @override
  Widget build(BuildContext context) {
    const double sideTimeWidth = 28.0;
    const double horizontalPadding = 32;
    double graphWidth = MediaQuery.of(context).size.width - ((horizontalPadding - sideTimeWidth) + horizontalPadding);
    double topPadding = 16.0;
    double bottomPadding = MediaQuery.of(context).size.height - (graphWidth + NAVBAR_HEIGHT + MediaQuery.of(context).padding.vertical + topPadding + 0.0);

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Statistics", "assets/icons/pie-chart.svg", "pie chart icon"),
            AdjustedContainer(
              padding: EdgeInsets.fromLTRB(horizontalPadding - sideTimeWidth, topPadding, horizontalPadding, bottomPadding),
              child: FlChart(
                chart: LineChart(LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalGrid: true,
                    drawHorizontalGrid: true,
                    horizontalInterval: interval,
                    getDrawingVerticalGridLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.5),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingHorizontalGridLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.5),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: false
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 6,
                        fontFamily: "OpenSans"
                      ),
                      getTitles: (double value) => getSideTime(value),
                      reservedSize: sideTimeWidth,
                      margin: 0,
                    ),
                  ),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white, width: 1)
                  ),
                  minX: 0.0,
                  maxX: stats.length.toDouble() - 1,
                  minY: minValue,
                  // the maxY need to be a bit bigger than the actual value because sometimes it won't show
                  // on the left titles date
                  maxY: maxValue + 0.001,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      // curveSmoothness: 0.1,
                      colors: [Colors.white],
                      barWidth: 1.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(
                        show: false,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.white.withOpacity(0.3)],
                      ),
                    ),
                  ],
                )),
              ),
            )
          ],
        ),
      )
    );
  }
}