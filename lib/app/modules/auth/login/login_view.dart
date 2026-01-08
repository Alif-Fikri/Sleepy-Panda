import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import 'login_controller.dart';
import 'widgets/forgot_password_bottom_sheet.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          'Masuk menggunakan akun yang \nsudah kamu daftarkan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.05,
                            fontFamily: 'Urbanist',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        SizedBox(
                          height: screenSize.height * 0.07,
                          child: TextField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.width * 0.035),
                                child: Image.asset(
                                  'assets/images/email.png',
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
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        SizedBox(
                          height: screenSize.height * 0.07,
                          child: TextField(
                            controller: controller.passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF2D2C4E),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.all(screenSize.width * 0.035),
                                child: Image.asset(
                                  'assets/images/lock.png',
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
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => ForgotPasswordBottomSheet.show(),
                            child: Text(
                              'Lupa password?',
                              style: TextStyle(
                                color: const Color(0xFF00D0C0),
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.15),
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
                                      'Masuk',
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
                            text: 'Belum memiliki akun? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: screenSize.width * 0.04,
                            ),
                            children: [
                              TextSpan(
                                text: 'Daftar sekarang',
                                style: TextStyle(
                                  color: const Color(0xFF00D0C0),
                                  fontFamily: 'Urbanist',
                                  fontSize: screenSize.width * 0.04,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.signup);
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
}
