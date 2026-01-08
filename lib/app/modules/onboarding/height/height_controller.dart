import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class OnboardingHeightController extends GetxController {
  OnboardingHeightController({
    UserRepository? userRepository,
    SessionService? sessionService,
  })  : _userRepository = userRepository ?? Get.find<UserRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final UserRepository _userRepository;
  final SessionService _sessionService;

  String email = '';
  String name = '';
  String gender = '';
  String work = '';
  String dateOfBirth = '';

  final selectedHeight = 100.obs;
  final isSaving = false.obs;

  Timer? _debounceTimer;
  bool _isNavigating = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '') as String;
    name =
        (args['name'] ?? _sessionService.loadProfile()['name'] ?? '') as String;
    gender = (args['gender'] ?? _sessionService.loadProfile()['gender'] ?? '')
        as String;
    gender = _normalizeGenderForPayload(gender);
    work =
        (args['work'] ?? _sessionService.loadProfile()['work'] ?? '') as String;
    dateOfBirth = (args['date_of_birth'] ??
        _sessionService.loadProfile()['date_of_birth'] ??
        '') as String;
    final initialHeight = args['height'];
    if (initialHeight is int && initialHeight > 0) {
      selectedHeight.value = initialHeight;
    } else if (initialHeight is double && initialHeight > 0) {
      selectedHeight.value = initialHeight.round();
    }

    if (email.isEmpty) {
      throw ArgumentError('Email tidak tersedia untuk proses onboarding');
    }
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }

  void onHeightChanged(int height, BuildContext context) {
    selectedHeight.value = height;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _saveHeight(context);
    });
  }

  Future<void> _saveHeight(BuildContext context) async {
    if (isSaving.value || _isNavigating) {
      return;
    }

    isSaving.value = true;
    try {
      final profile = await _userRepository.updateProfile(
        email: email,
        payload: {
          'email': email,
          'name': name,
          'gender': gender,
          'work': work,
          'date_of_birth': dateOfBirth,
          'height': selectedHeight.value,
        },
        token: _sessionService.token,
      );

      final updatedGender =
          _normalizeGenderForPayload(profile.gender ?? gender);

      await _sessionService.saveProfile({
        'name': profile.name ?? name,
        'gender': updatedGender,
        'work': profile.work ?? work,
        'date_of_birth': profile.dateOfBirth ?? dateOfBirth,
        'height': profile.height ?? selectedHeight.value.toDouble(),
      });

      _isNavigating = true;
      Get.offNamed(
        AppRoutes.onboardingWeight,
        arguments: {
          'email': email,
          'name': profile.name ?? name,
          'gender': updatedGender,
          'work': profile.work ?? work,
          'date_of_birth': profile.dateOfBirth ?? dateOfBirth,
          'height': (profile.height ?? selectedHeight.value.toDouble()).round(),
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
