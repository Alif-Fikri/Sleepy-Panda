import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'weightpage.dart';
import 'package:sleepys/helper/note_card.dart';
import 'package:sleepys/helper/api_endpoints.dart';

class HeightSelection extends StatelessWidget {
  final String name;
  final String email;
  final String gender;
  final String work;
  final String date_of_birth;

  const HeightSelection({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.work,
    required this.date_of_birth,
  });

  @override
  Widget build(BuildContext context) {
    return HeightSelectionPage(
      name: name,
      email: email,
      gender: gender,
      work: work,
      date_of_birth: date_of_birth,
    );
  }
}

class HeightSelectionPage extends StatefulWidget {
  final String name;
  final String email;
  final String gender;
  final String work;
  final String date_of_birth;

  const HeightSelectionPage({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.work,
    required this.date_of_birth,
  });

  @override
  _HeightSelectionPageState createState() => _HeightSelectionPageState();
}

class _HeightSelectionPageState extends State<HeightSelectionPage> {
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  int selectedItem = 100;
  Timer? _timer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    selectedItem = 100;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveHeight(int height) async {
    try {
      final response = await http.patch(
        ApiEndpoints.usersPatch(widget.email),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.email,
          'name': widget.name,
          'gender': widget.gender,
          'work': widget.work,
          'date_of_birth': widget.date_of_birth,
          'height': height,
        }),
      );

      if (response.statusCode == 200) {
        print('Height saved successfully: ${jsonDecode(response.body)}');
      } else {
        print('Failed to save height: ${response.body}');
        throw Exception('Failed to save height');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _onItemChanged(int index) {
    setState(() {
      selectedItem = index + 100;
    });
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () async {
      if (!mounted || _isNavigating) {
        return;
      }
      _isNavigating = true;
      final int height = selectedItem;
      try {
        await saveHeight(height);
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Weightpage(
              name: widget.name,
              email: widget.email,
              gender: widget.gender,
              work: widget.work,
              date_of_birth: widget.date_of_birth,
              height: height,
              userEmail: widget.email,
            ),
          ),
        );
      } catch (error) {
        print('Error: $error');
      } finally {
        _isNavigating = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = deviceWidth * 0.06;
    final double subtitleFontSize = deviceWidth * 0.045;
    final double pickerItemHeight = deviceWidth * 0.15;
    final double pickerContainerWidth = deviceWidth * 0.25;
    final double paddingHorizontal = deviceWidth * 0.05;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF20223F),
        ),
        backgroundColor: const Color(0xFF20223F),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selanjutnya,',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.02),
                  Text(
                    'Berapa tinggi badan mu?',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.02),
                  NoteCard(
                      text:
                          'Lakukan Scrolling untuk menentukan Tinggi Badan kamu dan tunggu 2 detik untuk lanjut ke halaman berikutnya!')
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onPanEnd: (details) {
                          _resetTimer();
                        },
                        child: Container(
                          height: pickerItemHeight,
                          width: pickerContainerWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFF272E49),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: ListWheelScrollView.useDelegate(
                            controller: _controller,
                            itemExtent: pickerItemHeight,
                            physics: const FixedExtentScrollPhysics(),
                            overAndUnderCenterOpacity: 0.5,
                            onSelectedItemChanged: _onItemChanged,
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    '${index + 100}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: subtitleFontSize * 1.5,
                                    ),
                                  ),
                                );
                              },
                              childCount: 200,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth * 0.02),
                      Text(
                        'Cm',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: subtitleFontSize * 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
