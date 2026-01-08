import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                          height: screenSize.width * 0.35,
                          width: screenSize.width * 0.35,
                        ),
                        Text(
                          'Daftar menggunakan email yang valid',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.05,
                            fontFamily: 'Urbanist',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        _buildField(
                          height: screenSize.height * 0.07,
                          controller: controller.emailController,
                          hintText: 'Email',
                          screenSize: screenSize,
                          prefixAsset: 'assets/images/email.png',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        _buildField(
                          height: screenSize.height * 0.07,
                          controller: controller.passwordController,
                          hintText: 'Password',
                          screenSize: screenSize,
                          prefixAsset: 'assets/images/lock.png',
                          obscureText: true,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        _buildField(
                          height: screenSize.height * 0.07,
                          controller: controller.confirmPasswordController,
                          hintText: 'Confirm Password',
                          screenSize: screenSize,
                          prefixAsset: 'assets/images/lock.png',
                          obscureText: true,
                        ),
                        SizedBox(height: screenSize.height * 0.1),
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: screenSize.height * 0.06,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.submit(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF009090),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        color: Colors.white,
                                        fontSize: screenSize.width * 0.045,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        RichText(
                          text: TextSpan(
                            text: 'Sudah memiliki akun? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                            ),
                            children: [
                              TextSpan(
                                text: 'Masuk sekarang',
                                style: TextStyle(
                                  color: const Color(0xFF00D0C0),
                                  fontFamily: 'Urbanist',
                                  fontSize: screenSize.width * 0.04,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.login);
                                  },
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildField({
    required double height,
    required TextEditingController controller,
    required String hintText,
    required Size screenSize,
    String? prefixAsset,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF2D2C4E),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Urbanist',
            fontSize: screenSize.width * 0.04,
          ),
          prefixIcon: prefixAsset == null
              ? null
              : Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.035),
                  child: Image.asset(
                    prefixAsset,
                    height: screenSize.width * 0.06,
                    width: screenSize.width * 0.06,
                  ),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Urbanist',
          fontSize: screenSize.width * 0.04,
        ),
      ),
    );
  }
}
