import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/metrics_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class BloodPressureController extends GetxController {
  BloodPressureController({
    MetricsRepository? metricsRepository,
    SessionService? sessionService,
  })  : _metricsRepository = metricsRepository ?? Get.find<MetricsRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final MetricsRepository _metricsRepository;
  final SessionService _sessionService;

  final upperController = TextEditingController();
  final lowerController = TextEditingController();
  final isSubmitting = false.obs;
  final isButtonEnabled = false.obs;

  late final String email;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '').toString();

    if (email.isEmpty) {
      throw ArgumentError('Email diperlukan untuk mencatat tekanan darah');
    }

    upperController.addListener(_updateButtonState);
    lowerController.addListener(_updateButtonState);
  }

  @override
  void onClose() {
    upperController.removeListener(_updateButtonState);
    lowerController.removeListener(_updateButtonState);
    upperController.dispose();
    lowerController.dispose();
    super.onClose();
  }

  void increment(TextEditingController controller) {
    final current = int.tryParse(controller.text) ?? 0;
    controller.text = (current + 1).toString();
  }

  void decrement(TextEditingController controller) {
    final current = int.tryParse(controller.text) ?? 0;
    if (current <= 0) return;
    controller.text = (current - 1).toString();
  }

  void _updateButtonState() {
    isButtonEnabled.value = upperController.text.trim().isNotEmpty &&
        lowerController.text.trim().isNotEmpty;
  }

  Future<void> submit(BuildContext context) async {
    if (!isButtonEnabled.value || isSubmitting.value) {
      return;
    }

    final upper = int.tryParse(upperController.text.trim());
    final lower = int.tryParse(lowerController.text.trim());

    if (upper == null || lower == null) {
      AppSnackbar.show(context, 'Nilai tekanan darah tidak valid');
      return;
    }

    isSubmitting.value = true;
    try {
      await _metricsRepository.updateUserMetrics(
        email: email,
        metrics: {
          'upperPressure': upper,
          'lowerPressure': lower,
        },
        token: _sessionService.token,
      );

      AppSnackbar.show(context, 'Tekanan darah tersimpan');
      Get.toNamed(
        AppRoutes.metricsDailySteps,
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
