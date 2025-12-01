import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthLineChart1 extends StatefulWidget {
  final List<double?> data;
  final DateTime startDate;

  MonthLineChart1({required this.data, required this.startDate});

  @override
  _MonthLineChart1State createState() => _MonthLineChart1State();
}

class _MonthLineChart1State extends State<MonthLineChart1> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double chartWidth = constraints.maxWidth * 0.9; 
      double chartHeight =
          constraints.maxHeight * 0.5; 

      if (constraints.maxHeight.isInfinite) {
        chartHeight = 200;
      }

      double fontSize = MediaQuery.of(context).size.width * 0.02;

      
      double minY = 2.0;
      double maxY = 12.0;

      
      List<double> yAxisLabels = [];
      for (double i = minY; i <= maxY; i += 1) {
        yAxisLabels.add(i);
      }

      return Padding(
        padding: const EdgeInsets.all(16), 
        child: SizedBox(
          width: chartWidth, 
          height: chartHeight, 
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: false,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (value, meta) {
                      String weekText = '';
                      if (value == 0) {
                        weekText = 'Week 1';
                      } else if (value == 1) {
                        weekText = 'Week 2';
                      } else if (value == 2) {
                        weekText = 'Week 3';
                      } else if (value == 3) {
                        weekText = 'Week 4';
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0), 
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
                      if (!yAxisLabels.contains(value)) return Container();

                      String hourText =
                          '${value.toInt().toString().padLeft(2, '0')}:00';
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(hourText,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: fontSize,
                              )),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), 
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false), 
                ),
              ),
              borderData: FlBorderData(
                show: false,
                border: Border.all(
                  color: const Color(0xff37434d),
                ),
              ),
              minX: 0,
              maxX: 3, 
              minY: minY, 
              maxY: maxY, 
              lineBarsData: [
                LineChartBarData(
                  spots: _createSpots(),
                  isCurved: false,
                  color: Color(0xFFFFC754),
                  barWidth: 2,
                  isStrokeCapRound: false,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (FlSpot spot, double xPercentage,
                        LineChartBarData bar, int index) {
                      return FlDotCirclePainter(
                        radius: 2,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Color.fromARGB(255, 255, 255, 255),
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      int hours = spot.y.toInt();
                      int minutes = ((spot.y - hours) * 60).toInt();

                      String timeText =
                          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

                      return LineTooltipItem(
                        '$timeText\n',
                        const TextStyle(
                          color: Color(0xFFFFC754),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  List<FlSpot> _createSpots() {
    List<FlSpot> spots = [];

    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i] != null) {
        double yValue = widget.data[i]!;

        
        if (yValue < 2.0) {
          yValue = 2.0; 
        } else if (yValue > 12.0) {
          yValue = 12.0; 
        }

        print(
            'Week $i: Adjusted yValue = $yValue'); 
        spots.add(FlSpot(i.toDouble(), yValue));
      }
    }

    return spots;
  }
}
