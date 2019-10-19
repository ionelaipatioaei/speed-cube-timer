import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/shared/adjusted_container.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/shared/custom_text.dart';

class Stats extends StatelessWidget {
    List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          children: <Widget>[
            TopNavbar("Statistics", "assets/icons/pie-chart.svg", "pie chart icon"),
            AdjustedContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.90
                    ),
                    decoration: BoxDecoration(
                      // color: Colors.black.withOpacity(0.24)
                    ),
                    margin: EdgeInsets.only(right: 30),
                    child: FlChart(
                      chart: LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalGrid: true,
        drawHorizontalGrid: true,
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
          showTitles: false,
          reservedSize: 22,
          textStyle: TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 8,
            fontFamily: "OpenSans"
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0: return '10.23';
              case 3: return '15.23';
              case 6: return '20.43';
              case 9: return '20.43';
              case 12: return '49.88';
            }
            return '';
          },
          reservedSize: 24,
          margin: 4,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1)),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 12,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 12),
            FlSpot(1, 11.5),
            FlSpot(2, 11),
            FlSpot(3.6, 11.1),
            FlSpot(4, 10.6),
            FlSpot(5, 11),
            FlSpot(6, 10.2),
            FlSpot(7.6, 9.8),
            FlSpot(8, 10.4),
            FlSpot(9, 11),
            FlSpot(10, 10),
            FlSpot(11, 9),
            FlSpot(12, 5),
            FlSpot(13, 4.3),
            FlSpot(14, 5),
            FlSpot(15, 4.3),
            FlSpot(16, 5),
            FlSpot(17, 4.3),
            FlSpot(18, 5),
            FlSpot(19, 4.3),
            FlSpot(20, 5),
            FlSpot(21, 4.3),
            FlSpot(22, 5),
            FlSpot(23, 4.3),
            FlSpot(24, 5),
          ],
          isCurved: true,
          colors: [Colors.white],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                [Colors.white].map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(0, 10),
            FlSpot(1, 10.5),
            FlSpot(2, 9),
            FlSpot(3.6, 8.1),
            FlSpot(4, 9.6),
            FlSpot(5, 10),
            FlSpot(6, 9.2),
            FlSpot(7.6, 9.8),
            FlSpot(8, 9.4),
            FlSpot(9, 9),
            FlSpot(10, 8),
            FlSpot(11, 7),
            FlSpot(12, 5),
            FlSpot(13, 4.3),
            FlSpot(14, 5),
            FlSpot(15, 4.3),
            FlSpot(16, 5),
            FlSpot(17, 4.3),
            FlSpot(18, 5),
            FlSpot(19, 4.3),
            FlSpot(20, 5),
            FlSpot(21, 4.3),
            FlSpot(22, 5),
            FlSpot(23, 4.3),
            FlSpot(24, 5),
          ],
          isCurved: true,
          colors: [Colors.red],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                [Colors.red].map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    )),
                    )
                  ),
                  CustomText("activity")
                ],
              )
            )
          ],
        )
       )
    );
  }
}