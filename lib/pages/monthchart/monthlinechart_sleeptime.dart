import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthLineChart extends StatefulWidget {
  final List<double?> data;
  final DateTime startDate;

  MonthLineChart({required this.data, required this.startDate});

  @override
  _MonthLineChartState createState() => _MonthLineChartState();
}

class _MonthLineChartState extends State<MonthLineChart> {
  List<double> originalYValues =
      []; 

  @override
  Widget build(BuildContext context) {
    final double minY = 20.0; 
    final double maxY = 30.0; 

    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth = constraints.maxWidth * 0.9;
        double chartHeight = constraints.maxHeight * 0.5;

        if (constraints.maxHeight.isInfinite) {
          chartHeight = 200;
        }

        double fontSize = MediaQuery.of(context).size.width * 0.02;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: false,
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
                          padding: const EdgeInsets.only(left: 15.0),
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
                        int hours = value.toInt();
                        int minutes = ((value - hours) * 60).toInt();

                        if (hours >= 24) {
                          hours -= 24;
                        }

                        String text =
                            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(text,
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
                    color: Color(0xFFFF5999),
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
                    preventCurveOverShooting: true,
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        int index = spot.x.toInt();

                        
                        if (index < originalYValues.length) {
                          double originalY = originalYValues[index];

                          if (originalY.isNaN) {
                            return LineTooltipItem(
                              'Data tidak tersedia\n',
                              const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          int hours = originalY.toInt();
                          int minutes = ((originalY - hours) * 60).toInt();

                          if (hours >= 24) {
                            hours -= 24;
                          }

                          String timeText =
                              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

                          return LineTooltipItem(
                            '$timeText\n',
                            const TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return LineTooltipItem(
                            'Invalid\n',
                            const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      }).toList();
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

  List<FlSpot> _createSpots() {
    double minY = 20.0;
    double maxY = 30.0;

    List<FlSpot> spots = [];
    originalYValues.clear(); 

    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i] != null) {
        double yValue = widget.data[i]!;
        originalYValues.add(yValue); 

        
        if (yValue < 6) {
          
          yValue += 24;
        }

        
        yValue = yValue.clamp(minY, maxY);

        spots.add(FlSpot(i.toDouble(), yValue));
      } else {
        
        originalYValues.add(double.nan);
      }
    }

    return spots;
  }
}
