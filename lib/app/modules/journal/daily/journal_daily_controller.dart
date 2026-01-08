import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/session_service.dart';
import '../../../data/repositories/sleep_repository.dart';
import '../../../modules/home/home_controller.dart';

class JournalDailyController extends GetxController {
  JournalDailyController({
    SleepRepository? sleepRepository,
    SessionService? sessionService,
  })  : _sleepRepository = sleepRepository ?? Get.find<SleepRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final SleepRepository _sleepRepository;
  final SessionService _sessionService;

  final records = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  late final String email;

  @override
  void onInit() {
    super.onInit();
    final home =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    email = home?.email ?? _sessionService.email ?? '';
    _loadSleepData();
  }

  Future<void> refreshData() async {
    await _loadSleepData();
  }

  bool get hasSleepData => records.isNotEmpty;

  Future<void> _loadSleepData() async {
    if (email.isEmpty) {
      errorMessage.value = 'Email tidak ditemukan.';
      records.clear();
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _sleepRepository.fetchDailyRecords(email: email);
      final filtered = result.where(_hasValidWakeUpTime).map((record) {
        return Map<String, dynamic>.from(record);
      }).toList();

      records.assignAll(filtered);
    } on FormatException catch (error) {
      errorMessage.value = error.message;
      records.clear();
    } catch (_) {
      errorMessage.value = 'Terjadi kesalahan saat mengambil data tidur.';
      records.clear();
    } finally {
      isLoading.value = false;
    }
  }

  bool _hasValidWakeUpTime(Map<String, dynamic> record) {
    final date = record['date']?.toString() ?? '';
    final timeRange = record['time']?.toString() ?? '';

    final wakeUp = _calculateWakeUpDateTime(date, timeRange);
    if (wakeUp == null) {
      return false;
    }

    return DateTime.now().isAfter(wakeUp);
  }

  DateTime? _calculateWakeUpDateTime(String date, String timeRange) {
    if (date.isEmpty || timeRange.isEmpty || !timeRange.contains('-')) {
      return null;
    }

    try {
      final parts = timeRange.split('-');
      if (parts.length != 2) {
        return null;
      }

      final sleepTime = _parseTime(parts.first.trim());
      final wakeTime = _parseTime(parts.last.trim());
      final sleepDate = _parseDate(date);

      if (sleepTime == null || wakeTime == null || sleepDate == null) {
        return null;
      }

      var wakeDate = DateTime(
        sleepDate.year,
        sleepDate.month,
        sleepDate.day,
        wakeTime.hour,
        wakeTime.minute,
      );

      if (wakeDate.isBefore(DateTime(
        sleepDate.year,
        sleepDate.month,
        sleepDate.day,
        sleepTime.hour,
        sleepTime.minute,
      ))) {
        wakeDate = wakeDate.add(const Duration(days: 1));
      }

      return wakeDate;
    } catch (_) {
      return null;
    }
  }

  DateTime? _parseTime(String value) {
    try {
      final time = DateFormat('HH:mm').parseStrict(value);
      return DateTime(0, 1, 1, time.hour, time.minute);
    } catch (_) {
      return null;
    }
  }

  DateTime? _parseDate(String value) {
    try {
      final formatter = DateFormat('d MMMM yyyy', 'id');
      return formatter.parseLoose(value);
    } catch (_) {
      return null;
    }
  }
}
