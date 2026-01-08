import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/session_service.dart';
import '../../data/providers/api_client.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../core/utils/api_endpoints.dart';

class FeedbackController extends GetxController {
  FeedbackController({
    ApiClient? apiClient,
    SessionService? sessionService,
  })  : _apiClient = apiClient ?? Get.find<ApiClient>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final ApiClient _apiClient;
  final SessionService _sessionService;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final feedbackController = TextEditingController();
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final email = _sessionService.email;
    if (email != null && email.isNotEmpty) {
      emailController.text = email;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    feedbackController.dispose();
    super.onClose();
  }

  Future<void> submit(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isSubmitting.value = true;
    try {
      await _apiClient.post(
        ApiEndpoints.feedback(),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'feedback': feedbackController.text.trim(),
        }),
      );

      AppSnackbar.show(context, 'Terima kasih atas feedback kamu!');
      feedbackController.clear();
    } on ApiClientException catch (error) {
      AppSnackbar.show(context, error.message);
    } catch (_) {
      AppSnackbar.show(context, 'Gagal mengirim feedback. Coba lagi.');
    } finally {
      isSubmitting.value = false;
    }
  }
}
