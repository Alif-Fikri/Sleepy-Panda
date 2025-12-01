import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleepys/helper/card_sleepprofile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleepys/pages/weekchart/weekbarchart.dart';
import 'package:sleepys/pages/weekchart/weeklinechart_sleeptime.dart';
import 'package:sleepys/pages/weekchart/weeklinechart_wakeuptime.dart';
import 'package:sleepys/helper/api_endpoints.dart';

class WeekPage extends StatefulWidget {
  final String email;

  WeekPage({required this.email});
  @override
  _WeekPageState createState() => _WeekPageState();
}

Future<Map<String, dynamic>> fetchWeeklySleepData(
    String email, String startDate, String endDate) async {
  final response = await http.get(
    ApiEndpoints.sleepWeekly(
      email,
      startDate: startDate,
      endDate: endDate,
    ),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load weekly sleep data');
  }
}

class _WeekPageState extends State<WeekPage> {
  bool _isBackButtonPressed = false;
  bool _isNextButtonPressed = false;
  DateTime startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime endDate = DateTime.now().add(Duration(days: 6));

  Map<String, dynamic> weeklyData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndSetWeeklyData();
  }

  void _previousWeek() {
    setState(() {
      
      startDate = startDate.subtract(Duration(days: 7));
      endDate = startDate.add(Duration(days: 6));
      fetchAndSetWeeklyData(); 
    });
  }

  void _nextWeek() {
    setState(() {
      
      startDate = startDate.add(Duration(days: 7));
      endDate = startDate.add(Duration(days: 6));
      fetchAndSetWeeklyData(); 
    });
  }

  void fetchAndSetWeeklyData() async {
    final startDateStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endDateStr = DateFormat('yyyy-MM-dd').format(endDate);

    setState(() {
      isLoading = true; 
      weeklyData.clear(); 
    });

    try {
      final data =
          await fetchWeeklySleepData(widget.email, startDateStr, endDateStr);
      print('Fetched Data: $data'); 
      setState(() {
        weeklyData = data;
        isLoading = false; 
      });
    } catch (e) {
      setState(() {
        weeklyData = {}; 
        isLoading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime endDate = startDate.add(Duration(days: 6));
    String year = DateFormat('yyyy').format(startDate);
    final sleepData = (weeklyData.containsKey('daily_sleep_durations') &&
            weeklyData['daily_sleep_durations'] is List)
        ? List<double>.generate(
            7,
            (index) =>
                (weeklyData['daily_sleep_durations'][index] ?? 0.0).toDouble())
        : List<double>.filled(7, 0.0);
    print("Weekly Data: ${weeklyData['daily_sleep_start_times']}");

    
    final sleepStartTimes =
        (weeklyData.containsKey('daily_sleep_start_times') &&
                weeklyData['daily_sleep_start_times'] is Map)
            ? List<double?>.generate(7, (index) {
                List<dynamic>? times =
                    weeklyData['daily_sleep_start_times'][index.toString()];
                if (times != null && times.isNotEmpty) {
                  String latestTime = times.last as String;
                  print(
                      'Sleep Start Time on day $index: $latestTime'); 
                  double hours = double.parse(latestTime.split(":")[0]);
                  double minutes = double.parse(latestTime.split(":")[1]) / 60;
                  return hours + minutes;
                } else {
                  return null;
                }
              })
            : List<double?>.filled(7, null);


    final wakeUpTimes = (weeklyData.containsKey('daily_wake_times') &&
            weeklyData['daily_wake_times'] is Map)
        ? List<double?>.generate(7, (index) {
            List<dynamic>? times =
                weeklyData['daily_wake_times'][index.toString()];
            if (times != null && times.isNotEmpty) {
              
              String latestTime = times.last as String;
              double hours = double.parse(latestTime.split(":")[0]);
              double minutes = double.parse(latestTime.split(":")[1]) / 60;
              return hours + minutes;
            } else {
              return null; 
            }
          })
        : List<double?>.filled(
            7, null); 

    final dateFormat = DateFormat('d MMMM', 'id');
    double baseFontSize = MediaQuery.of(context).size.width * 0.04;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF20223F),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    bool hasFullWeekData = weeklyData.containsKey('daily_sleep_durations') &&
        weeklyData['daily_sleep_durations'] is List &&
        (weeklyData['daily_sleep_durations'] as List).length == 7 &&
        (weeklyData['daily_sleep_durations'] as List)
            .every((duration) => duration != null && duration > 0);

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WeeklySleepProfile(
                email: widget.email,
                hasSleepData: hasFullWeekData, 
              ),
              SizedBox(height: 10),
              Text(
                year,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/back.png',
                      height: 35,
                      width: 35,
                      color: _isBackButtonPressed ? Colors.white : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isBackButtonPressed = !_isBackButtonPressed;
                        _isNextButtonPressed =
                            false; 
                        _previousWeek();
                      });
                    },
                  ),
                  Text(
                    '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/next.png',
                      height: 35,
                      width: 35,
                      color: _isNextButtonPressed ? Colors.white : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNextButtonPressed = !_isNextButtonPressed;
                        _isBackButtonPressed =
                            false; 
                        _nextWeek();
                      });
                    },
                  ),
                ],
              ),
              weeklyData.isNotEmpty
                  ? SleepEntryGrid(weeklyData: weeklyData)
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Belum ada catatan tidur untuk minggu ini.',
                        style: TextStyle(
                          fontSize: baseFontSize,
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(right: 200, bottom: 20),
                child: Text(
                  'Durasi Tidur',
                  style: TextStyle(
                    fontSize: baseFontSize,
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: weeklyData.isNotEmpty
                      ? WeekBarChart(
                          sleepData: sleepData,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(right: 200, top: 10),
                child: Text(
                  'Mulai Tidur',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: weeklyData.isNotEmpty
                      ? SleepLineChart(
                          data: sleepStartTimes,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 200, top: 10),
                child: Text(
                  'Bangun Tidur',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF272E49)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(15),
                  child: weeklyData.isNotEmpty
                      ? SleepLineChart1(
                          data: wakeUpTimes,
                          startDate: startDate,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Belum ada catatan tidur untuk minggu ini.',
                            style: TextStyle(
                              fontSize: baseFontSize,
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

class SleepEntry extends StatelessWidget {
  final String title;
  final String value;
  final String content;
  final String imageAsset;

  SleepEntry({
    required this.title,
    required this.value,
    required this.content,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;

    
    final double imageHeight = screenWidth * 0.06; 
    final double imageWidth = screenWidth * 0.06; 
    final double fontSizeContent = screenWidth * 0.035; 
    final double fontSizeTitle = screenWidth * 0.03; 
    final double fontSizeValue = screenWidth * 0.03; 

    final double imageTop = screenWidth * 0.05; 
    final double imageLeft = screenWidth * 0.025; 
    final double contentLeft = screenWidth * 0.1; 
    final double contentTop = screenWidth * 0.0125; 
    final double titleTop = screenWidth * 0.05; 
    final double valueTop = screenWidth * 0.0875; 

    return Card(
      color: Color(0xFF272E49),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.025), 
        child: Stack(
          children: [
            Positioned(
              left: imageLeft,
              top: imageTop,
              child: Image.asset(
                imageAsset,
                height: imageHeight,
                width: imageWidth,
              ),
            ),
            Positioned(
              left: contentLeft,
              top: contentTop,
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontSize: fontSizeContent,
                ),
              ),
            ),
            Positioned(
              left: contentLeft,
              top: titleTop,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            Positioned(
              left: contentLeft,
              top: valueTop,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: fontSizeValue,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SleepEntryGrid extends StatelessWidget {
  final Map<String, dynamic> weeklyData;

  SleepEntryGrid({required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxItemWidth = constraints.maxWidth / 2 - 10;
        double itemHeight = maxItemWidth * 0.55;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxItemWidth,
                childAspectRatio: maxItemWidth / itemHeight,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Durasi tidur',
                      value: weeklyData['avg_duration'] ?? 'N/A',
                      imageAsset: 'assets/images/clock.png',
                    );
                  case 1:
                    return SleepEntry(
                      content: 'Total',
                      title: 'Durasi tidur',
                      value: weeklyData['total_duration'] ?? 'N/A',
                      imageAsset: 'assets/images/wakeup.png',
                    );
                  case 2:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Mulai tidur',
                      value: weeklyData['avg_sleep_time'] ?? 'N/A',
                      imageAsset: 'assets/images/bed.png',
                    );
                  case 3:
                    return SleepEntry(
                      content: 'Average',
                      title: 'Bangun tidur',
                      value: weeklyData['avg_wake_time'] ?? 'N/A',
                      imageAsset: 'assets/images/sun.png',
                    );
                  default:
                    return SizedBox.shrink();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
