import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/chartPoints.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  final List<ChartPoints> points;
  LineChartWidget(this.points, {Key? key}) : super(key: key);
  final List<Color> gradientColors = [
    const Color(0xfffff502),
    const Color(0xff92ff00),
  ];
  @override
  Widget build(BuildContext context) {

    Widget bottomTitleWidgets(double value, TitleMeta meta) {
      var now = DateTime.now();
      var day2 = DateFormat.E().format(now.add(const Duration(days: 1)));
      var day3 = DateFormat.E().format(now.add(const Duration(days: 2)));
      var day4 = DateFormat.E().format(now.add(const Duration(days: 3)));
      var day5 = DateFormat.E().format(now.add(const Duration(days: 4)));
      const style = TextStyle(
        fontSize: 16,
        color: Color(0xffd2d2d2),
      );
      Widget text;
      switch (value.toInt()) {
        case 0:
          text = const Text('Today', style: style);
          break;
        case 1:
          text = Text(day2, style: style);
          break;
        case 2:
          text = Text(day3, style: style);
          break;
        case 3:
          text = Text(day4, style: style);
          break;
        case 4:
          text = Text(day5, style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(
        fontSize: 14,
        color: Color(0xffd2d2d2),
      );
      String text;
      switch (value.toInt()) {
        case 1:
          text = 'Sunny';
          break;
        case 2:
          text = 'Light';
          break;
        case 3:
          text = 'Moderate';
          break;
        case 4:
          text = 'Heavy';
          break;
        default:
          return Container();
      }

      return Text(text, style: style, textAlign: TextAlign.left);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: LineChart(
          LineChartData(
            minX: 0,
            minY: 0,
            maxX: 4,
            maxY: 5,

            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),

              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 65,
                ),
              ),
            ),

            gridData: const FlGridData(
              show: false,
              drawHorizontalLine: false,
              drawVerticalLine: false,
            ),

            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.grey.shade700,
                width: 2,
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
                gradient: const LinearGradient(
                colors: [Colors.white, Colors.white70,Colors.white70,Color(0xff1F1D36)],
                ),
                isCurved: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  colors: gradientColors
                    .map((color) => color.withOpacity(0.3)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
