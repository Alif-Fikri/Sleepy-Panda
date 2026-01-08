import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class LoginController extends GetxController {
  LoginController({
    AuthRepository? authRepository,
    UserRepository? userRepository,
    SessionService? sessionService,
  })  : _authRepository = authRepository ?? Get.find<AuthRepository>(),
        _userRepository = userRepository ?? Get.find<UserRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final SessionService _sessionService;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  bool _isValidEmail(String value) {
    const pattern =
        r'^[a-zA-Z0-9.!#%&"*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$';
    return RegExp(pattern).hasMatch(value);
  }

  Future<void> submit(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.show(context, 'Email dan password harus diisi');
      return;
    }

    if (!_isValidEmail(email)) {
      AppSnackbar.show(context, 'Format email tidak valid');
      return;
    }

    isLoading.value = true;
    try {
      final token =
          await _authRepository.login(email: email, password: password);

      await _sessionService.saveToken(token);
      await _sessionService.saveEmail(email);

      final profile = await _userRepository.fetchProfile(token: token);
      await _persistProfile(profile);

      AppSnackbar.show(context, 'Login berhasil');
      _navigateToNext(profile);
    } on ApiClientException catch (error) {
      final message = error.payload is Map<String, dynamic>
          ? (error.payload['detail']?.toString() ?? error.message)
          : error.message;
      AppSnackbar.show(context, message);
    } catch (error) {
      AppSnackbar.show(context, 'Terjadi kesalahan. Silakan coba lagi.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _persistProfile(UserProfile profile) async {
    final normalizedGender = _normalizeGender(profile.gender);

    final payload = <String, dynamic>{
      'name': profile.name ?? '',
      'gender': normalizedGender ?? '',
      'work': profile.work ?? '',
      'date_of_birth': profile.dateOfBirth ?? '',
    };

    if (profile.height != null) {
      payload['height'] = profile.height;
    }

    if (profile.weight != null) {
      payload['weight'] = profile.weight;
    }

    await _sessionService.saveProfile(payload);
  }

  void _navigateToNext(UserProfile profile) {
    final name = profile.name ?? '';
    final gender = _normalizeGender(profile.gender);
    final work = profile.work ?? '';
    final dateOfBirth = profile.dateOfBirth ?? '';
    final height = (profile.height ?? 0).toDouble();
    final weight = (profile.weight ?? 0).toDouble();

    if (name.isEmpty) {
      Get.offAllNamed(AppRoutes.onboardingName, arguments: {
        'email': profile.email,
      });
      return;
    }

    if (gender == null || gender.isEmpty) {
      Get.offAllNamed(AppRoutes.onboardingGender, arguments: {
        'email': profile.email,
        'name': name,
      });
      return;
    }

    if (work.isEmpty) {
      Get.offAllNamed(AppRoutes.onboardingWork, arguments: {
        'email': profile.email,
        'name': name,
        'gender': gender,
      });
      return;
    }

    if (dateOfBirth.isEmpty) {
      Get.offAllNamed(AppRoutes.onboardingDate, arguments: {
        'email': profile.email,
        'name': name,
        'gender': gender,
        'work': work,
      });
      return;
    }

    if (height <= 0) {
      Get.offAllNamed(AppRoutes.onboardingHeight, arguments: {
        'email': profile.email,
        'name': name,
        'gender': gender,
        'work': work,
        'date_of_birth': dateOfBirth,
        'height': height.toInt(),
        'weight': weight.toInt(),
      });
      return;
    }

    if (weight <= 0) {
      Get.offAllNamed(AppRoutes.onboardingWeight, arguments: {
        'email': profile.email,
        'name': name,
        'gender': gender,
        'work': work,
        'date_of_birth': dateOfBirth,
        'height': height.toInt(),
        'weight': weight.toInt(),
      });
      return;
    }

    Get.offAllNamed(AppRoutes.home, arguments: {
      'email': profile.email,
    });
  }

  String? _normalizeGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return null;
    }

    if (gender == '0' || gender.toLowerCase() == 'female') {
      return 'female';
    }

    if (gender == '1' || gender.toLowerCase() == 'male') {
      return 'male';
    }

    return gender;
  }
}
