import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'alarm_controller.dart';

class AlarmView extends GetView<AlarmController> {
  const AlarmView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -1000) {
            controller.onSwipeUp();
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.userName.value.isNotEmpty
                        ? 'Selamat tidur, ${controller.userName.value}'
                        : 'Selamat tidur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.12),
                Obx(
                  () => Center(
                    child: Text(
                      controller.currentTime.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Center(
                  child: Text(
                    'Waktu bangun: ${controller.wakeUpTime.isNotEmpty ? controller.wakeUpTime : '--:--'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.045,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.08),
                  child: Image.asset('assets/images/line.png'),
                ),
                Obx(
                  () => controller.isWakeUpTime.value
                      ? Padding(
                          padding: EdgeInsets.only(top: size.height * 0.12),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: controller.arrowAnimationController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      controller.arrowOffsetAnimation.value,
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: controller
                                              .arrowColorAnimation.value ??
                                          Colors.white,
                                      size: size.width * 0.1,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: size.height * 0.015),
                              Text(
                                'Geser ke atas untuk bangun',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.width * 0.035,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
