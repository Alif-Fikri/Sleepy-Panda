import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/card_sleepprofile.dart';
import 'package:sleepys/app/widgets/charts/weekly/weekly_bar_chart.dart';
import 'package:sleepys/app/widgets/charts/weekly/weekly_sleep_time_line_chart.dart';
import 'package:sleepys/app/widgets/charts/weekly/weekly_wake_time_line_chart.dart';
import 'journal_weekly_controller.dart';

class JournalWeeklyView extends GetView<JournalWeeklyController> {
  const JournalWeeklyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF20223F),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = controller.errorMessage.value;
        final data = controller.weeklyData.value;
        final hasWeekData = data != null && data.isNotEmpty;
        final hasChartsData = controller.hasFullWeekData;

        final screenWidth = MediaQuery.of(context).size.width;
        final baseFontSize = screenWidth * 0.04;

        return ListView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          children: [
            WeeklySleepProfile(
              email: controller.email,
              hasSleepData: hasChartsData,
            ),
            SizedBox(height: screenWidth * 0.02),
            Center(
              child: Text(
                controller.yearLabel,
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/back.png',
                    height: 35,
                    width: 35,
                    color: controller.isBackButtonActive.value
                        ? Colors.white
                        : Colors.grey,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.previousWeek,
                ),
                Text(
                  controller.rangeLabel,
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
                    color: controller.isNextButtonActive.value
                        ? Colors.white
                        : Colors.grey,
                  ),
                  onPressed:
                      controller.isLoading.value ? null : controller.nextWeek,
                ),
              ],
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
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else if (!hasWeekData)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Belum ada catatan tidur untuk minggu ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              _WeeklySleepEntryGrid(
                averageDuration: controller.averageDuration,
                totalDuration: controller.totalDuration,
                averageSleepTime: controller.averageSleepTime,
                averageWakeTime: controller.averageWakeTime,
              ),
            SizedBox(height: screenWidth * 0.02),
            _SectionTitle(title: 'Durasi Tidur', fontSize: baseFontSize),
            _ChartContainer(
              child: hasWeekData
                  ? WeekBarChart(
                      sleepData: controller.sleepDurations,
                      startDate: controller.startDate.value,
                    )
                  : _EmptyChartMessage(fontSize: baseFontSize),
            ),
            SizedBox(height: screenWidth * 0.02),
            _SectionTitle(title: 'Mulai Tidur', fontSize: baseFontSize),
            _ChartContainer(
              child: hasWeekData
                  ? SleepLineChart(
                      data: controller.sleepStartTimes,
                      startDate: controller.startDate.value,
                    )
                  : _EmptyChartMessage(fontSize: baseFontSize),
            ),
            SizedBox(height: screenWidth * 0.02),
            _SectionTitle(title: 'Bangun Tidur', fontSize: baseFontSize),
            _ChartContainer(
              child: hasWeekData
                  ? SleepLineChart1(
                      data: controller.wakeUpTimes,
                      startDate: controller.startDate.value,
                    )
                  : _EmptyChartMessage(fontSize: baseFontSize),
            ),
          ],
        );
      }),
    );
  }
}

class _WeeklySleepEntryGrid extends StatelessWidget {
  const _WeeklySleepEntryGrid({
    required this.averageDuration,
    required this.totalDuration,
    required this.averageSleepTime,
    required this.averageWakeTime,
  });

  final String averageDuration;
  final String totalDuration;
  final String averageSleepTime;
  final String averageWakeTime;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double maxItemWidth = (screenWidth - 60) / 2;
    final double itemHeight = maxItemWidth * 0.55;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxItemWidth,
        childAspectRatio: maxItemWidth / itemHeight,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _WeeklySleepEntry(
              label: 'Average',
              title: 'Durasi tidur',
              value: averageDuration,
              asset: 'assets/images/clock.png',
            );
          case 1:
            return _WeeklySleepEntry(
              label: 'Total',
              title: 'Durasi tidur',
              value: totalDuration,
              asset: 'assets/images/wakeup.png',
            );
          case 2:
            return _WeeklySleepEntry(
              label: 'Average',
              title: 'Mulai tidur',
              value: averageSleepTime,
              asset: 'assets/images/bed.png',
            );
          case 3:
            return _WeeklySleepEntry(
              label: 'Average',
              title: 'Bangun tidur',
              value: averageWakeTime,
              asset: 'assets/images/sun.png',
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _WeeklySleepEntry extends StatelessWidget {
  const _WeeklySleepEntry({
    required this.label,
    required this.title,
    required this.value,
    required this.asset,
  });

  final String label;
  final String title;
  final String value;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
      color: const Color(0xFF272E49),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.025),
        child: Stack(
          children: [
            Positioned(
              left: imageLeft,
              top: imageTop,
              child: Image.asset(
                asset,
                height: imageHeight,
                width: imageWidth,
              ),
            ),
            Positioned(
              left: contentLeft,
              top: contentTop,
              child: Text(
                label,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.fontSize,
  });

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ChartContainer extends StatelessWidget {
  const _ChartContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF272E49)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(15),
      constraints: const BoxConstraints(minHeight: 200),
      child: child,
    );
  }
}

class _EmptyChartMessage extends StatelessWidget {
  const _EmptyChartMessage({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Belum ada catatan tidur untuk minggu ini.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
