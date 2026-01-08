import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekBarChart extends StatefulWidget {
  const WeekBarChart({
    super.key,
    required this.sleepData,
    required this.startDate,
  });

  final List<double> sleepData;
  final DateTime startDate;

  @override
  State<WeekBarChart> createState() => _WeekBarChartState();
}

class _WeekBarChartState extends State<WeekBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth * 0.9;
        var chartHeight = constraints.maxHeight * 0.5;
        final barWidth = chartWidth / (7 * 1.5);

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        final fontSize = MediaQuery.of(context).size.width * 0.02;

        const minY = 2.0;
        const maxY = 12.0;

        return Center(
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: BarChart(
              BarChartData(
                minY: minY,
                maxY: maxY,
                barGroups: _createBarGroups(barWidth),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date =
                            widget.startDate.add(Duration(days: value.toInt()));
                        final dayText = DateFormat('EEE').format(date);

                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            dayText,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        if (value < minY || value > maxY) {
                          return const SizedBox.shrink();
                        }

                        final hourText =
                            '${value.toInt().toString().padLeft(2, '0')}j';
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            hourText,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: fontSize,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barTouchData: BarTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (response != null && response.spot != null) {
                        touchedIndex = response.spot!.touchedBarGroupIndex;
                      } else {
                        touchedIndex = -1;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(5),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final originalValue = widget.sleepData[group.x];
                      return BarTooltipItem(
                        '${originalValue.toInt()}j',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<BarChartGroupData> _createBarGroups(double barWidth) {
    return List.generate(7, (index) {
      final value = widget.sleepData[index];
      final displayedValue = value > 12.0 ? 12.0 : value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: displayedValue,
            color: index == touchedIndex ? Colors.red : const Color(0xFF60354A),
            width: barWidth,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ],
      );
    });
  }
}
