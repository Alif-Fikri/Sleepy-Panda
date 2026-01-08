import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthLineChart1 extends StatefulWidget {
  const MonthLineChart1({
    super.key,
    required this.data,
    required this.startDate,
  });

  final List<double?> data;
  final DateTime startDate;

  @override
  State<MonthLineChart1> createState() => _MonthLineChart1State();
}

class _MonthLineChart1State extends State<MonthLineChart1> {
  static const double _minY = 2.0;
  static const double _maxY = 12.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth * 0.9;
        var chartHeight = constraints.maxHeight * 0.5;

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        final fontSize = MediaQuery.of(context).size.width * 0.02;
        final yAxisLabels = List<double>.generate(
          ((_maxY - _minY) + 1).toInt(),
          (index) => _minY + index,
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 3,
                minY: _minY,
                maxY: _maxY,
                gridData: FlGridData(
                  show: false,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final weekIndex = value.toInt();
                        final weekText = 'Week ${weekIndex + 1}';
                        return Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            weekText,
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
                      reservedSize: 40,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        if (!yAxisLabels.contains(value)) {
                          return const SizedBox.shrink();
                        }

                        final hourText =
                            '${value.toInt().toString().padLeft(2, '0')}:00';
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              hourText,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: fontSize,
                              ),
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
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _createSpots(),
                    isCurved: false,
                    color: const Color(0xFFFFC754),
                    barWidth: 2,
                    isStrokeCapRound: false,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 2,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                      final hours = spot.y.toInt();
                      final minutes = ((spot.y - hours) * 60).toInt();
                      final timeText =
                          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

                      return LineTooltipItem(
                        '$timeText\n',
                        const TextStyle(
                          color: Color(0xFFFFC754),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<FlSpot> _createSpots() {
    final spots = <FlSpot>[];

    for (var i = 0; i < widget.data.length; i++) {
      final value = widget.data[i];
      if (value == null) {
        continue;
      }

      var yValue = value;

      if (yValue < _minY) {
        yValue = _minY;
      } else if (yValue > _maxY) {
        yValue = _maxY;
      }

      spots.add(FlSpot(i.toDouble(), yValue));
    }

    return spots;
  }
}
