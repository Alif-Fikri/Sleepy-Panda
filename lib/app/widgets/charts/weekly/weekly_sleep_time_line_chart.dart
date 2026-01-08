import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepLineChart extends StatefulWidget {
  const SleepLineChart({
    super.key,
    required this.data,
    required this.startDate,
  });

  final List<double?> data;
  final DateTime startDate;

  @override
  State<SleepLineChart> createState() => _SleepLineChartState();
}

class _SleepLineChartState extends State<SleepLineChart> {
  static const double _minY = 20.0;
  static const double _maxY = 30.0;

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

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
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
                      reservedSize: 40,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        var hours = value.toInt();
                        final minutes = ((value - hours) * 60).toInt();

                        if (hours >= 24) {
                          hours -= 24;
                        }

                        final text =
                            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              text,
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
                    color: const Color(0xFFFF5999),
                    barWidth: 2,
                    isStrokeCapRound: false,
                    preventCurveOverShooting: true,
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
                      final originalY = _getOriginalYValue(spot.x.toInt());
                      var hours = originalY.toInt();
                      final minutes = ((originalY - hours) * 60).toInt();

                      if (hours >= 24) {
                        hours -= 24;
                      }

                      final timeText =
                          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

                      return LineTooltipItem(
                        '$timeText\n',
                        const TextStyle(
                          color: Colors.pink,
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

      if (yValue < 6) {
        yValue += 24;
      }

      if (yValue < _minY) {
        yValue = _minY;
      } else if (yValue > _maxY) {
        yValue = _maxY;
      }

      spots.add(FlSpot(i.toDouble(), yValue));
    }

    return spots;
  }

  double _getOriginalYValue(int index) {
    final originalY = widget.data[index];

    if (originalY == null) {
      return _minY;
    }

    if (originalY < 6) {
      return originalY + 24;
    }

    return originalY;
  }
}
