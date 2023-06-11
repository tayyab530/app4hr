import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.points}) : super(key: key);

  final List<GraphPoint> points;

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late List<GraphPoint> points;

  @override
  void initState() {
    points = widget.points;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      height: mediaQuery.size.height * 0.5,
      child: AspectRatio(
        aspectRatio: 2,
        child: BarChart(
          BarChartData(
            barGroups: _chartGroups(),
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitles),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    return points.map((point) =>
        BarChartGroupData(
            x: point.x.toInt(),
            barRods: [
              BarChartRodData(
                  toY: point.y,
                  color: point.y > 0 ? Colors.blue : Colors.red,
              )
            ]
        )

    ).toList();
  }

  SideTitles get _bottomTitles =>
      SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          var label = points.firstWhere((e) => e.x == value.toInt()).label;
          // var listOfLabels = label.split("_");
          // return Column(
          //   children: listOfLabels.map((l) => Text(l),).toList()
          // );
          return Text(label);
        },
      );

  SideTitles get _leftTitles =>
      SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return Text(value.toInt().toString(),style: TextStyle(fontSize: 10),);
        },
      );
}

class GraphPoint {
  final double x;
  final double y;
  final String label;

  GraphPoint(this.x, this.y, this.label);

}