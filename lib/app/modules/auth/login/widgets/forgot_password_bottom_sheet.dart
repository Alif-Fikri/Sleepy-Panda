import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../forgot_password_controller.dart';

class ForgotPasswordBottomSheet extends GetView<ForgotPasswordController> {
  const ForgotPasswordBottomSheet({super.key});

  static Future<T?> show<T>() {
    Get.put(ForgotPasswordController());
    return Get.bottomSheet<T>(
      const ForgotPasswordBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).whenComplete(() {
      if (Get.isRegistered<ForgotPasswordController>()) {
        Get.delete<ForgotPasswordController>();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(
      () => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          height: viewInsets +
              (controller.step.value == ForgotPasswordStep.email ? 350 : 400),
          decoration: const BoxDecoration(
            color: Color(0xFF272E49),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(27),
              topRight: Radius.circular(27),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: screenWidth * 0.1,
                height: 4,
                color: const Color(0xFF009090),
              ),
              const SizedBox(height: 10),
              Text(
                'Lupa Password?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.06,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _instructionText(controller.step.value),
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: screenWidth * 0.04,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenWidth * 0.05),
              if (controller.step.value == ForgotPasswordStep.email) ...[
                if (controller.emailError.value != null)
                  _buildErrorText(controller.emailError.value!, screenWidth),
                _buildFilledField(
                  width: screenWidth * 0.85,
                  height: screenWidth * 0.12,
                  controller: controller.emailController,
                  hintText: 'Email',
                  prefix: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.035),
                    child: Image.asset('assets/images/email1.png'),
                  ),
                ),
                SizedBox(height: screenWidth * 0.03),
                _buildButton(
                  label: 'Kirim',
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.sendOtp(context),
                  screenWidth: screenWidth,
                ),
              ] else if (controller.step.value == ForgotPasswordStep.otp) ...[
                if (controller.otpError.value != null)
                  _buildErrorText(controller.otpError.value!, screenWidth),
                _buildFilledField(
                  width: screenWidth * 0.85,
                  height: screenWidth * 0.12,
                  controller: controller.otpController,
                  hintText: 'OTP',
                  prefix: const Icon(Icons.lock, color: Color(0xFF333333)),
                ),
                SizedBox(height: screenWidth * 0.03),
                _buildButton(
                  label: 'Verifikasi',
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.verifyOtp(context),
                  screenWidth: screenWidth,
                ),
              ] else ...[
                if (controller.passwordError.value != null)
                  _buildErrorText(controller.passwordError.value!, screenWidth),
                _buildFilledField(
                  width: screenWidth * 0.85,
                  height: screenWidth * 0.12,
                  controller: controller.passwordController,
                  hintText: 'Password Baru',
                  obscureText: true,
                  prefix: const Icon(Icons.lock, color: Color(0xFF333333)),
                ),
                SizedBox(height: screenWidth * 0.03),
                _buildButton(
                  label: 'Reset Password',
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.resetPassword(context),
                  screenWidth: screenWidth,
                ),
              ],
              if (controller.isLoading.value) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: Color(0xFF009090)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorText(String text, double screenWidth) {
    return Container(
      width: screenWidth * 0.85,
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.red,
          fontFamily: 'Urbanist',
          fontSize: screenWidth * 0.04,
        ),
      ),
    );
  }

  Widget _buildFilledField({
    required double width,
    required double height,
    required TextEditingController controller,
    required String hintText,
    Widget? prefix,
    bool obscureText = false,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF333333),
            fontFamily: 'Urbanist',
          ),
          prefixIcon: prefix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(
          color: Color(0xFF333333),
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback? onPressed,
    required double screenWidth,
  }) {
    return SizedBox(
      width: screenWidth * 0.85,
      height: screenWidth * 0.12,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF009090),
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Urbanist',
            color: Colors.white,
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
    );
  }

  static String _instructionText(ForgotPasswordStep step) {
    switch (step) {
      case ForgotPasswordStep.email:
        return 'Kode OTP akan dikirim melalui email yang kamu gunakan untuk mendaftar.';
      case ForgotPasswordStep.otp:
        return 'Masukkan kode OTP yang telah kami kirim ke email Anda untuk verifikasi.';
      case ForgotPasswordStep.reset:
        return 'Masukkan password baru Anda untuk mereset password.';
    }
  }
}
