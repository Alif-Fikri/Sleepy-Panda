import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class OnboardingNameController extends GetxController {
  OnboardingNameController({
    UserRepository? userRepository,
    SessionService? sessionService,
  })  : _userRepository = userRepository ?? Get.find<UserRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final UserRepository _userRepository;
  final SessionService _sessionService;

  late final String email;

  final nameController = TextEditingController();
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final sessionEmail = _sessionService.email;
    email = (args['email'] ?? sessionEmail ?? '') as String;

    if (email.isEmpty) {
      throw ArgumentError('Email tidak tersedia untuk proses onboarding');
    }

    final storedProfile = _sessionService.loadProfile();
    final initialName = (args['name'] ?? storedProfile['name'] ?? '') as String;
    if (initialName.isNotEmpty) {
      nameController.text = initialName;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> submit(BuildContext context) async {
    final name = nameController.text.trim();

    if (name.length < 3) {
      AppSnackbar.show(context, 'Nama harus minimal 3 karakter.');
      return;
    }

    if (isSaving.value) {
      return;
    }

    isSaving.value = true;
    try {
      final profile = await _userRepository.updateProfile(
        email: email,
        payload: {
          'email': email,
          'name': name,
        },
        token: _sessionService.token,
      );

      await _sessionService.saveProfile({
        'name': profile.name ?? name,
      });

      Get.offNamed(
        AppRoutes.onboardingGender,
        arguments: {
          'email': email,
          'name': profile.name ?? name,
        },
      );
    } on ApiClientException catch (error) {
      AppSnackbar.show(context, error.message);
    } catch (_) {
      AppSnackbar.show(context, 'Terjadi kesalahan. Silakan coba lagi.');
    } finally {
      isSaving.value = false;
    }
  }
}
