import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: controller.fadeAnimation,
              child: Image.asset(
                'assets/images/sleepypanda.png',
                height: screenSize.width * 0.4,
                width: screenSize.width * 0.4,
              ),
            ),
            FadeTransition(
              opacity: controller.fadeAnimation,
              child: Text(
                'Sleepy Panda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.1,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Urbanist',
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
