import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/api_client.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../shared/widgets/app_snackbar.dart';

enum ForgotPasswordStep { email, otp, reset }

class ForgotPasswordController extends GetxController {
  ForgotPasswordController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? Get.find<AuthRepository>();

  final AuthRepository _authRepository;

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  final step = ForgotPasswordStep.email.obs;
  final isLoading = false.obs;

  final emailError = RxnString();
  final otpError = RxnString();
  final passwordError = RxnString();
  final email = RxnString();

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> sendOtp(BuildContext context) async {
    final input = emailController.text.trim();
    emailError.value = null;

    if (input.isEmpty) {
      emailError.value = 'Email tidak boleh kosong';
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.requestOtp(input);
      email.value = input;
      step.value = ForgotPasswordStep.otp;
      AppSnackbar.show(context, 'OTP berhasil dikirim');
    } on ApiClientException catch (error) {
      emailError.value = error.payload is Map<String, dynamic>
          ? error.payload['detail']?.toString() ?? error.message
          : error.message;
    } catch (error) {
      emailError.value = 'Terjadi kesalahan, coba lagi nanti.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (email.value == null) {
      emailError.value = 'Email tidak valid';
      step.value = ForgotPasswordStep.email;
      return;
    }

    final otp = otpController.text.trim();
    otpError.value = null;

    if (otp.isEmpty) {
      otpError.value = 'OTP tidak boleh kosong';
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.verifyOtp(email: email.value!, otp: otp);
      step.value = ForgotPasswordStep.reset;
      AppSnackbar.show(context, 'OTP berhasil diverifikasi');
    } on ApiClientException catch (error) {
      otpError.value = error.payload is Map<String, dynamic>
          ? error.payload['detail']?.toString() ?? error.message
          : error.message;
    } catch (error) {
      otpError.value = 'Kode OTP salah atau sudah kedaluwarsa';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    if (email.value == null) {
      emailError.value = 'Email tidak valid';
      step.value = ForgotPasswordStep.email;
      return;
    }

    final newPassword = passwordController.text;
    passwordError.value = null;

    if (newPassword.isEmpty) {
      passwordError.value = 'Password tidak boleh kosong';
      return;
    }

    if (!_isValidPassword(newPassword)) {
      passwordError.value =
          'Password harus minimal 8 karakter, mengandung huruf kapital dan angka';
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.resetPassword(
        email: email.value!,
        newPassword: newPassword,
      );
      AppSnackbar.show(context, 'Password berhasil direset');
      Get.back();
    } on ApiClientException catch (error) {
      passwordError.value = error.payload is Map<String, dynamic>
          ? error.payload['detail']?.toString() ?? error.message
          : error.message;
    } catch (error) {
      passwordError.value = 'Terjadi kesalahan, coba lagi nanti.';
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }
}
