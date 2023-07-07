import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/chartPoints.dart';


class LineChartWidget extends StatelessWidget {
  final List<ChartPoints> points;
  LineChartWidget(this.points, {Key? key}) : super(key: key);
  final List<Color> gradientColors =[ Color(0xffff0000),  Color(0xfff1e704)];
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4/3,
      child: LineChart(LineChartData(
          minX: 0,
          minY: 0,
          maxX: 5,
          maxY: 5,

          titlesData: const FlTitlesData(show: false) ,//LineTitleData.getTitleData() ,

          gridData:  const FlGridData(
              show: false, drawHorizontalLine: false, drawVerticalLine: false,
          ),

          borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.shade700, width: 1,),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              dotData: const FlDotData(show: false),
              // belowBarData: BarAreaData(
              //   show: true,
              //   colors: gradientColors
              //       .map((color) => color.withOpacity(0.4))
              //       .toList(),
              // ),
            ),

          ],
        ),
      ),
    );
  }
}

