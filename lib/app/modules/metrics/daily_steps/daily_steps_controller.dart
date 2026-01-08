import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/metrics_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class DailyStepsController extends GetxController {
  DailyStepsController({
    MetricsRepository? metricsRepository,
    SessionService? sessionService,
  })  : _metricsRepository = metricsRepository ?? Get.find<MetricsRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final MetricsRepository _metricsRepository;
  final SessionService _sessionService;

  final stepsController = TextEditingController();
  final isButtonEnabled = false.obs;
  final isSubmitting = false.obs;

  late final String email;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '').toString();

    if (email.isEmpty) {
      throw ArgumentError('Email diperlukan untuk mencatat langkah harian');
    }

    stepsController.addListener(_updateButtonState);
  }

  @override
  void onClose() {
    stepsController.removeListener(_updateButtonState);
    stepsController.dispose();
    super.onClose();
  }

  void increment() {
    final current = int.tryParse(stepsController.text) ?? 0;
    stepsController.text = (current + 1).toString();
  }

  void decrement() {
    final current = int.tryParse(stepsController.text) ?? 0;
    if (current <= 0) return;
    stepsController.text = (current - 1).toString();
  }

  void _updateButtonState() {
    isButtonEnabled.value = stepsController.text.trim().isNotEmpty;
  }

  Future<void> submit(BuildContext context) async {
    if (!isButtonEnabled.value || isSubmitting.value) {
      return;
    }

    final steps = int.tryParse(stepsController.text.trim());
    if (steps == null) {
      AppSnackbar.show(context, 'Jumlah langkah tidak valid');
      return;
    }

    isSubmitting.value = true;
    try {
      await _metricsRepository.updateUserMetrics(
        email: email,
        metrics: {
          'dailySteps': steps,
        },
        token: _sessionService.token,
      );

      AppSnackbar.show(context, 'Langkah harian tersimpan');
      Get.toNamed(
        AppRoutes.metricsHeartRate,
        arguments: {'email': email},
      );
    } on ApiClientException catch (error) {
      AppSnackbar.show(context, error.message);
    } catch (_) {
      AppSnackbar.show(context, 'Gagal menyimpan data. Coba lagi.');
    } finally {
      isSubmitting.value = false;
    }
  }
}
