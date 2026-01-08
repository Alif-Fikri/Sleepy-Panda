import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/metrics_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class HeartRateController extends GetxController {
  HeartRateController({
    MetricsRepository? metricsRepository,
    SessionService? sessionService,
  })  : _metricsRepository = metricsRepository ?? Get.find<MetricsRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final MetricsRepository _metricsRepository;
  final SessionService _sessionService;

  final heartRateController = TextEditingController();
  final isButtonEnabled = false.obs;
  final isSubmitting = false.obs;

  late final String email;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '').toString();

    if (email.isEmpty) {
      throw ArgumentError('Email diperlukan untuk mencatat detak jantung');
    }

    heartRateController.addListener(_updateButtonState);
  }

  @override
  void onClose() {
    heartRateController.removeListener(_updateButtonState);
    heartRateController.dispose();
    super.onClose();
  }

  void increment() {
    final current = int.tryParse(heartRateController.text) ?? 0;
    heartRateController.text = (current + 1).toString();
  }

  void decrement() {
    final current = int.tryParse(heartRateController.text) ?? 0;
    if (current <= 0) return;
    heartRateController.text = (current - 1).toString();
  }

  void _updateButtonState() {
    isButtonEnabled.value = heartRateController.text.trim().isNotEmpty;
  }

  Future<void> submit(BuildContext context) async {
    if (!isButtonEnabled.value || isSubmitting.value) {
      return;
    }

    final heartRate = int.tryParse(heartRateController.text.trim());
    if (heartRate == null) {
      AppSnackbar.show(context, 'Detak jantung tidak valid');
      return;
    }

    isSubmitting.value = true;
    try {
      await _metricsRepository.updateUserMetrics(
        email: email,
        metrics: {
          'heartRate': heartRate,
        },
        token: _sessionService.token,
      );

      AppSnackbar.show(context, 'Detak jantung tersimpan');
      Get.toNamed(
        AppRoutes.metricsSleep,
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
