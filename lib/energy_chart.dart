import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'energy_data.dart';

class EnergyChart extends ConsumerWidget {
  const EnergyChart({Key? key, required this.isLandscape, required this.isDarkMode}) : super(key: key);
  final bool isLandscape;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energyData = ref.watch(energyDataProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Time (Hr)'),
                  sideTitles: SideTitles(getTitlesWidget: (val, meta) => _getXAxis(val, energyData.hours), showTitles: true),
                ),
                rightTitles: const AxisTitles(axisNameWidget: Text('Energy (MW)'))
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: _getGraphData(energyData.loadGeneration),
                  isCurved: true,
                  barWidth: 5,
                  belowBarData: BarAreaData(show: true),
                  dotData: const FlDotData(show: false),
                  color: Colors.blue,
                ),
                LineChartBarData(
                  spots: _getGraphData(energyData.loadForecast),
                  isCurved: true,
                  barWidth: 1,
                  dotData: const FlDotData(show: false),
                  color: Colors.red,
                ),
                LineChartBarData(
                  spots: _getGraphData(energyData.windForecast),
                  isCurved: true,
                  barWidth: 1,
                  dotData: const FlDotData(show: false),
                  color: Colors.cyan,
                ),
                LineChartBarData(
                  spots: _getGraphData(energyData.solarForecast),
                  isCurved: true,
                  barWidth: 1,
                  dotData: const FlDotData(show: false),
                  color: Colors.yellow,
                ),
              ],
              extraLinesData: ExtraLinesData(
                verticalLines: [
                  VerticalLine(
                    x: DateTime.now().hour.toDouble(), // Add vertical line at current time
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getGraphData(List<double> data)
  {
    return data.asMap().map((index, value) =>
        MapEntry(index, FlSpot(index.toDouble(), value))).values.toList();
  }

  Widget _getXAxis(double val, List<double> hours) {
    int index = val.toInt();
    String str = '';

    if (hours.isNotEmpty && (isLandscape || index % 2 == 0)) {
      str = '${hours[index].toInt()}:00';
    }

    return Text(str);
  }
}
