import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthLineChart extends StatefulWidget {
  const MonthLineChart({
    super.key,
    required this.data,
    required this.startDate,
  });

  final List<double?> data;
  final DateTime startDate;

  @override
  State<MonthLineChart> createState() => _MonthLineChartState();
}

class _MonthLineChartState extends State<MonthLineChart> {
  static const double _minY = 20.0;
  static const double _maxY = 30.0;

  final List<double> _originalYValues = <double>[];

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
                maxX: 3,
                minY: _minY,
                maxY: _maxY,
                gridData: FlGridData(show: false),
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
                      final index = spot.x.toInt();

                      if (index >= _originalYValues.length) {
                        return const LineTooltipItem(
                          'Invalid\n',
                          TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }

                      final originalY = _originalYValues[index];

                      if (originalY.isNaN) {
                        return const LineTooltipItem(
                          'Data tidak tersedia\n',
                          TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }

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
    _originalYValues
      ..clear()
      ..addAll(List<double>.filled(widget.data.length, double.nan));

    for (var i = 0; i < widget.data.length; i++) {
      final value = widget.data[i];
      if (value == null) {
        continue;
      }

      var yValue = value;
      _originalYValues[i] = yValue;

      if (yValue < 6) {
        yValue += 24;
      }

      yValue = yValue.clamp(_minY, _maxY);

      spots.add(FlSpot(i.toDouble(), yValue));
    }

    return spots;
  }
}
