import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_choice_controller.dart';

class AuthChoiceView extends GetView<AuthChoiceController> {
  const AuthChoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1D42),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: screenSize.width * 0.1,
          ),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/sleepypanda.png',
                        height: screenSize.width * 0.4,
                        width: screenSize.width * 0.4,
                      ),
                      Text(
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
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.2),
                        child: Text(
                          'Mulai dengan masuk atau \nmendaftar untuk melihat analisa tidur mu.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.05,
                            fontFamily: 'Urbanist',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      ElevatedButton(
                        onPressed: controller.goToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF009090),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(
                            double.infinity,
                            screenSize.height * 0.06,
                          ),
                        ),
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: screenSize.width * 0.045,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      ElevatedButton(
                        onPressed: controller.goToSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(
                            double.infinity,
                            screenSize.height * 0.06,
                          ),
                        ),
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: screenSize.width * 0.045,
                            color: const Color(0xFF009090),
                          ),
                        ),
                      ),
                    ],
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
