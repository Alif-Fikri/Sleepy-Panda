import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class SignupController extends GetxController {
  SignupController({
    AuthRepository? authRepository,
    SessionService? sessionService,
  })  : _authRepository = authRepository ?? Get.find<AuthRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final AuthRepository _authRepository;
  final SessionService _sessionService;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool _isValidEmail(String email) {
    const allowedDomains = {
      'gmail.com',
      'yahoo.com',
      'outlook.com',
      'hotmail.com',
    };

    final regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );

    if (!regex.hasMatch(email)) {
      return false;
    }

    final domain = email.split('@').last;
    return allowedDomains.contains(domain);
  }

  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  Future<void> submit(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (!_isValidEmail(email)) {
      AppSnackbar.show(context, 'Format email tidak valid');
      return;
    }

    if (password.isEmpty) {
      AppSnackbar.show(context, 'Password tidak boleh kosong');
      return;
    }

    if (!_isValidPassword(password)) {
      AppSnackbar.show(
        context,
        'Password harus minimal 8 karakter, mengandung huruf kapital dan angka',
      );
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.show(context, 'Password tidak cocok');
      return;
    }

    isLoading.value = true;
    try {
      final token = await _authRepository.register({
        'email': email,
        'password': password,
      });

      await _sessionService.saveToken(token);
      await _sessionService.saveEmail(email);

      AppSnackbar.show(context, 'Pendaftaran berhasil');
      Get.offAllNamed(AppRoutes.onboardingName, arguments: {
        'email': email,
      });
    } on ApiClientException catch (error) {
      final message = error.payload is Map<String, dynamic>
          ? error.payload['detail']?.toString() ?? error.message
          : error.message;
      AppSnackbar.show(context, message);
    } catch (error) {
      AppSnackbar.show(context, 'Terjadi kesalahan saat mendaftar');
    } finally {
      isLoading.value = false;
    }
  }
}
