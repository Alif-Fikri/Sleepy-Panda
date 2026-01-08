import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/session_service.dart';
import '../../../data/repositories/sleep_repository.dart';
import '../../home/home_controller.dart';

class JournalMonthlyController extends GetxController {
  JournalMonthlyController({
    SleepRepository? sleepRepository,
    SessionService? sessionService,
  })  : _sleepRepository = sleepRepository ?? Get.find<SleepRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final SleepRepository _sleepRepository;
  final SessionService _sessionService;

  final currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final monthlyData = Rxn<Map<String, dynamic>>();
  final isBackButtonActive = false.obs;
  final isNextButtonActive = false.obs;

  late final String email;

  String get yearLabel => DateFormat('yyyy').format(currentDate.value);
  String get monthLabel => DateFormat('MMMM', 'id').format(currentDate.value);

  List<double> get weeklyDurations {
    final data = monthlyData.value;
    if (data == null) return List<double>.filled(4, 0);
    final raw = data['weekly_sleep_durations'];
    if (raw is List) {
      return List<double>.generate(4, (index) {
        final value = index < raw.length ? raw[index] : 0;
        if (value == null) return 0;
        return (value as num).toDouble();
      });
    }
    return List<double>.filled(4, 0);
  }

  List<double?> get weeklySleepStartTimes =>
      _extractWeeklyTimeSeries('weekly_sleep_start_times');

  List<double?> get weeklyWakeTimes =>
      _extractWeeklyTimeSeries('weekly_wake_times');

  bool get hasMonthlySleepData {
    final data = monthlyData.value;
    if (data == null) return false;
    final raw = data['daily_sleep_durations'];
    if (raw is! List) return false;
    return raw.isNotEmpty &&
        raw.every((element) => element != null && (element as num) > 0);
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
    _fetchMonthlyData();
  }

  Future<void> refreshData() => _fetchMonthlyData();

  Future<void> previousMonth() async {
    currentDate.value =
        DateTime(currentDate.value.year, currentDate.value.month - 1, 1);
    isBackButtonActive.value = !isBackButtonActive.value;
    isNextButtonActive.value = false;
    await _fetchMonthlyData();
  }

  Future<void> nextMonth() async {
    currentDate.value =
        DateTime(currentDate.value.year, currentDate.value.month + 1, 1);
    isNextButtonActive.value = !isNextButtonActive.value;
    isBackButtonActive.value = false;
    await _fetchMonthlyData();
  }

  Future<void> _fetchMonthlyData() async {
    if (email.isEmpty) {
      errorMessage.value = 'Email tidak ditemukan.';
      monthlyData.value = null;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final data = await _sleepRepository.fetchMonthlyData(
        email: email,
        month: currentDate.value.month,
        year: currentDate.value.year,
      );
      monthlyData.value = data;
    } on FormatException catch (error) {
      errorMessage.value = error.message;
      monthlyData.value = null;
    } catch (_) {
      errorMessage.value =
          'Terjadi kesalahan saat mengambil data tidur bulanan.';
      monthlyData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  String _stringValue(String key) {
    final data = monthlyData.value;
    if (data == null) return 'N/A';
    final value = data[key];
    if (value == null) return 'N/A';
    return value.toString();
  }

  List<double?> _extractWeeklyTimeSeries(String key) {
    final data = monthlyData.value;
    if (data == null) return List<double?>.filled(4, null);

    final raw = data[key];
    if (raw is! Map) return List<double?>.filled(4, null);

    return List<double?>.generate(4, (index) {
      final values = raw[index.toString()];
      if (values is List && values.isNotEmpty) {
        final time = values.last.toString();
        final parts = time.split(':');
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
