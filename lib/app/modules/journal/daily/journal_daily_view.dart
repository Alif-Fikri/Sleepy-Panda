import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/card_sleepprofile.dart';
import 'journal_daily_controller.dart';

class JournalDailyView extends GetView<JournalDailyController> {
  const JournalDailyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF20223F),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = controller.errorMessage.value;
        final records = controller.records;
        final hasData = controller.hasSleepData;

        return ListView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          children: [
            DailySleepProfile(
              email: controller.email,
              hasSleepData: hasData,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else if (!hasData)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Belum ada catatan tidur untuk hari ini.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              ...records.map(
                (record) => _DailySleepEntry(
                  date: record['date']?.toString() ?? 'Tanggal tidak tersedia',
                  duration:
                      record['duration']?.toString() ?? 'Durasi tidak tersedia',
                  time: record['time']?.toString() ?? 'Waktu tidak tersedia',
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _DailySleepEntry extends StatelessWidget {
  const _DailySleepEntry({
    required this.date,
    required this.duration,
    required this.time,
  });

  final String date;
  final String duration;
  final String time;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double imageHeight = screenWidth * 0.05;
    final double imageWidth = screenWidth * 0.05;
    final double fontSizeTitle = screenWidth * 0.03;
    final double fontSizeValue = screenWidth * 0.025;
    final double imageTop = screenWidth * 0.065;
    final double imageLeft = screenWidth * 0.032;
    final double imageRight = screenWidth * 0.27;
    final double contentTop = screenWidth * 0.05;
    final double contentRight = screenWidth * 0.10;

    return Card(
      color: const Color(0xFF272E49),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                    fontSize: fontSizeTitle,
                  ),
                ),
                SizedBox(height: screenWidth * 0.1),
              ],
            ),
            Positioned(
              left: contentRight,
              top: contentTop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Durasi tidur',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: fontSizeTitle,
                    ),
                  ),
                  Text(
                    duration,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: fontSizeValue,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: contentRight,
              top: contentTop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waktu tidur',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: fontSizeTitle,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: fontSizeValue,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: imageLeft,
              top: imageTop,
              child: Image.asset(
                'assets/images/clock.png',
                height: imageHeight,
                width: imageWidth,
              ),
            ),
            Positioned(
              right: imageRight,
              top: imageTop,
              child: Image.asset(
                'assets/images/wakeup.png',
                height: imageHeight,
                width: imageWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
