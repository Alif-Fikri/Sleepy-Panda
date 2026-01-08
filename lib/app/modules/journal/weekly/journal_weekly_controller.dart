import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/session_service.dart';
import '../../../data/repositories/sleep_repository.dart';
import '../../../modules/home/home_controller.dart';

class JournalWeeklyController extends GetxController {
  JournalWeeklyController({
    SleepRepository? sleepRepository,
    SessionService? sessionService,
  })  : _sleepRepository = sleepRepository ?? Get.find<SleepRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final SleepRepository _sleepRepository;
  final SessionService _sessionService;

  final startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)).obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final weeklyData = Rxn<Map<String, dynamic>>();
  final isBackButtonActive = false.obs;
  final isNextButtonActive = false.obs;

  late final String email;

  DateTime get endDate => startDate.value.add(const Duration(days: 6));

  String get yearLabel => DateFormat('yyyy').format(startDate.value);

  String get rangeLabel {
    final formatter = DateFormat('d MMMM', 'id');
    return '${formatter.format(startDate.value)} - ${formatter.format(endDate)}';
  }

  List<double> get sleepDurations {
    final data = weeklyData.value;
    if (data == null) return List<double>.filled(7, 0);
    final raw = data['daily_sleep_durations'];
    if (raw is List) {
      return List<double>.generate(7, (index) {
        final value = index < raw.length ? raw[index] : 0;
        if (value == null) return 0;
        return (value as num).toDouble();
      });
    }
    return List<double>.filled(7, 0);
  }

  List<double?> get sleepStartTimes =>
      _extractTimeSeries('daily_sleep_start_times');

  List<double?> get wakeUpTimes => _extractTimeSeries('daily_wake_times');

  bool get hasFullWeekData {
    final data = weeklyData.value;
    if (data == null) return false;
    final raw = data['daily_sleep_durations'];
    if (raw is! List) return false;
    if (raw.length != 7) return false;
    return raw.every((element) => element != null && (element as num) > 0);
  }

  String get averageDuration => _stringValue('avg_duration');
  String get totalDuration => _stringValue('total_duration');
  String get averageSleepTime => _stringValue('avg_sleep_time');
  String get averageWakeTime => _stringValue('avg_wake_time');

  @override
  void onInit() {
    super.onInit();
    final home =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    email = home?.email ?? _sessionService.email ?? '';
    _fetchWeeklyData();
  }

  Future<void> refreshData() => _fetchWeeklyData();

  Future<void> previousWeek() async {
    startDate.value = startDate.value.subtract(const Duration(days: 7));
    isBackButtonActive.value = !isBackButtonActive.value;
    isNextButtonActive.value = false;
    await _fetchWeeklyData();
  }

  Future<void> nextWeek() async {
    startDate.value = startDate.value.add(const Duration(days: 7));
    isNextButtonActive.value = !isNextButtonActive.value;
    isBackButtonActive.value = false;
    await _fetchWeeklyData();
  }

  Future<void> _fetchWeeklyData() async {
    if (email.isEmpty) {
      errorMessage.value = 'Email tidak ditemukan.';
      weeklyData.value = null;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final data = await _sleepRepository.fetchWeeklyData(
        email: email,
        startDate: startDate.value,
        endDate: endDate,
      );
      weeklyData.value = data;
    } on FormatException catch (error) {
      errorMessage.value = error.message;
      weeklyData.value = null;
    } catch (_) {
      errorMessage.value =
          'Terjadi kesalahan saat mengambil data tidur mingguan.';
      weeklyData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  String _stringValue(String key) {
    final data = weeklyData.value;
    if (data == null) return 'N/A';
    final value = data[key];
    if (value == null) return 'N/A';
    return value.toString();
  }

  List<double?> _extractTimeSeries(String key) {
    final data = weeklyData.value;
    if (data == null) return List<double?>.filled(7, null);
    final raw = data[key];
    if (raw is! Map) {
      return List<double?>.filled(7, null);
    }

    return List<double?>.generate(7, (index) {
      final values = raw[index.toString()];
      if (values is List && values.isNotEmpty) {
        final latest = values.last.toString();
        final parts = latest.split(':');
        if (parts.length == 2) {
          final hours = double.tryParse(parts[0]);
          final minutes = double.tryParse(parts[1]);
          if (hours != null && minutes != null) {
            return hours + (minutes / 60);
          }
        }
      }
      return null;
    });
  }
}
