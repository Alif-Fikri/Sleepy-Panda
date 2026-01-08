import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/models/prediction.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/prediction_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class PredictionAgreementController extends GetxController {
  PredictionAgreementController({
    required this.period,
    PredictionRepository? predictionRepository,
    SessionService? sessionService,
  })  : _predictionRepository =
            predictionRepository ?? Get.find<PredictionRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final PredictionPeriod period;
  final PredictionRepository _predictionRepository;
  final SessionService _sessionService;

  final isLoading = false.obs;
  String email = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '') as String;
  }

  Future<void> requestPrediction(BuildContext context) async {
    if (isLoading.value) {
      return;
    }

    if (email.isEmpty) {
      AppSnackbar.show(context, 'Email tidak ditemukan.');
      return;
    }

    isLoading.value = true;
    try {
      final label = await _runPrediction();
      await _savePrediction(label);
      Get.toNamed(
        AppRoutes.predictionResult,
        arguments: {
          'email': email,
          'label': label,
          'period': period,
        },
      );
    } on ApiClientException catch (error) {
      AppSnackbar.show(context, error.message);
    } on FormatException catch (error) {
      AppSnackbar.show(context, error.message);
    } catch (_) {
      AppSnackbar.show(context, 'Terjadi kesalahan. Silakan coba lagi.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<PredictionLabel> _runPrediction() {
    switch (period) {
      case PredictionPeriod.daily:
        return _predictionRepository.runDaily(email: email);
      case PredictionPeriod.weekly:
        return _predictionRepository.runWeekly(email: email);
      case PredictionPeriod.monthly:
        return _predictionRepository.runMonthly(email: email);
    }
  }

  Future<void> _savePrediction(PredictionLabel label) {
    switch (period) {
      case PredictionPeriod.daily:
        return _predictionRepository.saveDaily(email: email, label: label);
      case PredictionPeriod.weekly:
        return _predictionRepository.saveWeekly(email: email, label: label);
      case PredictionPeriod.monthly:
        return _predictionRepository.saveMonthly(email: email, label: label);
    }
  }
}
