import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/session_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/repositories/metrics_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';

class SleepScheduleController extends GetxController {
  SleepScheduleController({
    MetricsRepository? metricsRepository,
    SessionService? sessionService,
  })  : _metricsRepository = metricsRepository ?? Get.find<MetricsRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final MetricsRepository _metricsRepository;
  final SessionService _sessionService;

  final selectedHour = RxnInt();
  final selectedMinute = RxnInt();
  final isSaving = false.obs;

  late final String email;

  bool get canSave =>
      selectedHour.value != null &&
      selectedMinute.value != null &&
      !isSaving.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '').toString();

    if (email.isEmpty) {
      throw ArgumentError('Email diperlukan untuk menyimpan jadwal tidur');
    }
  }

  @override
  void onReady() {
    super.onReady();
    ensureNotificationPermission();
  }

  void setHour(int value) {
    selectedHour.value = value;
  }

  void setMinute(int value) {
    selectedMinute.value = value;
  }

  Future<void> ensureNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return;

    final result = await Permission.notification.request();
    if (!result.isGranted) {
      _showPermissionDialog();
    }
  }

  Future<void> save(BuildContext context) async {
    if (!canSave) {
      return;
    }

    final hour = selectedHour.value!;
    final minute = selectedMinute.value!;

    final now = DateTime.now();
    final sleepTime = now;
    final wakeTime = DateTime(now.year, now.month, now.day, hour, minute);

    isSaving.value = true;
    try {
      await _metricsRepository.saveSleepSchedule(
        email: email,
        sleepTime: sleepTime,
        wakeTime: wakeTime,
        token: _sessionService.token,
      );

      final formatted = _formatTime(hour, minute);
      AppSnackbar.show(context, 'Jadwal tidur tersimpan');
      Get.offAllNamed(
        AppRoutes.alarm,
        arguments: {
          'wakeUpTime': formatted,
          'email': email,
        },
      );
    } on ApiClientException catch (error) {
      AppSnackbar.show(context, error.message);
    } catch (_) {
      AppSnackbar.show(context, 'Gagal menyimpan jadwal tidur. Coba lagi.');
    } finally {
      isSaving.value = false;
    }
  }

  void skip() {
    Get.offAllNamed(
      AppRoutes.home,
      arguments: {'email': email},
    );
  }

  void _showPermissionDialog() {
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Izin Notifikasi Diperlukan'),
        content:
            const Text('Aplikasi ini membutuhkan izin notifikasi untuk alarm.'),
        actions: [
          TextButton(
            onPressed: () async {
              Get.back<void>();
              await openAppSettings();
            },
            child: const Text('Pengaturan'),
          ),
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Tutup'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  String _formatTime(int hour, int minute) {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
