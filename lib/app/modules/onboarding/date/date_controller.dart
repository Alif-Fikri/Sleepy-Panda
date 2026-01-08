import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class OnboardingDateController extends GetxController {
  OnboardingDateController({
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

  final selectedDate = DateTime.now().obs;
  final isSaving = false.obs;

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

    if (email.isEmpty) {
      throw ArgumentError('Email tidak tersedia untuk proses onboarding');
    }
  }

  Future<void> pickDate(BuildContext context) async {
    if (isSaving.value) {
      return;
    }

    final picked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      dateFormat: 'dd-MMMM-yyyy',
      locale: DateTimePickerLocale.en_us,
      looping: true,
    );

    if (picked == null) {
      return;
    }

    selectedDate.value = picked;
    await _saveDate(context, picked);
  }

  Future<void> _saveDate(BuildContext context, DateTime date) async {
    if (isSaving.value) {
      return;
    }

    isSaving.value = true;
    final formattedDate = _formatDate(date);

    try {
      final profile = await _userRepository.updateProfile(
        email: email,
        payload: {
          'email': email,
          'name': name,
          'gender': _normalizeGenderForPayload(gender),
          'work': work,
          'date_of_birth': formattedDate,
        },
        token: _sessionService.token,
      );

      await _sessionService.saveProfile({
        'name': profile.name ?? name,
        'gender': profile.gender ?? _normalizeGenderForPayload(gender),
        'work': profile.work ?? work,
        'date_of_birth': profile.dateOfBirth ?? formattedDate,
      });

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed(
        AppRoutes.onboardingHeight,
        arguments: {
          'email': email,
          'name': profile.name ?? name,
          'gender': profile.gender ?? _normalizeGenderForPayload(gender),
          'work': profile.work ?? work,
          'date_of_birth': profile.dateOfBirth ?? formattedDate,
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

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
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
