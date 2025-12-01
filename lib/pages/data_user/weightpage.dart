import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../home.dart';
import 'package:sleepys/helper/note_card.dart';
import 'package:sleepys/helper/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Weightpage extends StatefulWidget {
  final String name;
  final String email;
  final String gender;
  final String work;
  final String date_of_birth;
  final int height;
  final String userEmail;

  const Weightpage({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.work,
    required this.date_of_birth,
    required this.height,
    required this.userEmail,
  });

  @override
  _WeightpageState createState() => _WeightpageState();
}

class _WeightpageState extends State<Weightpage> {
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  int selectedItem = 0;
  Timer? _timer;
  bool _isNavigating = false;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  String _normalizeGender(String gender) {
    final lower = gender.toLowerCase();
    if (lower == 'male' || gender == '1') {
      return '1';
    }
    if (lower == 'female' || gender == '0') {
      return '0';
    }
    return gender;
  }

  Future<void> saveWeight(int weight) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia untuk menyimpan berat badan');
      }

      final normalizedGender = _normalizeGender(widget.gender);
      final payload = <String, dynamic>{
        'email': widget.email,
        'name': widget.name,
        'gender': normalizedGender,
        'work': widget.work,
        'date_of_birth': widget.date_of_birth,
        'height': widget.height,
        'weight': weight,
      };

      final response = await http.patch(
        ApiEndpoints.usersPatch(widget.email),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Weight saved successfully: ${jsonDecode(response.body)}');
        await prefs.setDouble('weight', weight.toDouble());
        await prefs.setDouble('height', widget.height.toDouble());
      } else {
        print('Failed to save weight: ${response.body}');
        throw Exception('Failed to save weight');
      }
    } catch (error) {
      print('Error saving weight: $error');
      rethrow;
    }
  }

  void _onItemChanged(int index) {
    setState(() {
      selectedItem = index;
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
      final int weight = selectedItem;

      try {
        await saveWeight(weight);
        if (!mounted) {
          return;
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(userEmail: widget.email),
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
          automaticallyImplyLeading: false,
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
                    'Berapa berat badan mu?',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.02),
                  NoteCard(
                      text:
                          'Lakukan Scrolling untuk menentukan Berat Badan kamu dan tunggu 2 detik untuk lanjut ke halaman berikutnya!!')
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
                                    '$index',
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
                        'Kg',
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
