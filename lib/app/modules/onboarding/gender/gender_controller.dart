import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class OnboardingGenderController extends GetxController {
  OnboardingGenderController({
    UserRepository? userRepository,
    SessionService? sessionService,
  })  : _userRepository = userRepository ?? Get.find<UserRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final UserRepository _userRepository;
  final SessionService _sessionService;

  String email = '';
  String name = '';

  final selectedGender = RxnString();
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '') as String;
    name =
        (args['name'] ?? _sessionService.loadProfile()['name'] ?? '') as String;

    if (email.isEmpty) {
      throw ArgumentError('Email tidak tersedia untuk proses onboarding');
    }
  }

  Future<void> selectGender(String gender, BuildContext context) async {
    if (isSaving.value) {
      return;
    }

    selectedGender.value = gender;
    isSaving.value = true;
    try {
      final profile = await _userRepository.updateProfile(
        email: email,
        payload: {
          'email': email,
          'name': name,
          'gender': gender,
        },
        token: _sessionService.token,
      );

      final updatedGender =
          _normalizeGenderForPayload(profile.gender ?? gender);

      await _sessionService.saveProfile({
        'name': profile.name ?? name,
        'gender': updatedGender,
      });

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed(
        AppRoutes.onboardingWork,
        arguments: {
          'email': email,
          'name': profile.name ?? name,
          'gender': updatedGender,
        },
      );
    } on ApiClientException catch (error) {
      AppSnackbar.show(context, error.message);
      isSaving.value = false;
    } catch (_) {
      AppSnackbar.show(context, 'Terjadi kesalahan. Silakan coba lagi.');
      isSaving.value = false;
    }
  }

  String _normalizeGenderForPayload(String value) {
    if (value.isEmpty) {
      return value;
    }

    final lower = value.toLowerCase();
    if (lower == 'female' || value == '0') {
      return '0';
    }
    if (lower == 'male' || value == '1') {
      return '1';
    }
    return value;
  }
}
