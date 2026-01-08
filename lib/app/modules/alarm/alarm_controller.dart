import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/services/session_service.dart';
import '../../data/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class AlarmController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AlarmController({
    UserRepository? userRepository,
    SessionService? sessionService,
  })  : _userRepository = userRepository ?? Get.find<UserRepository>(),
        _sessionService = sessionService ?? Get.find<SessionService>();

  final UserRepository _userRepository;
  final SessionService _sessionService;

  final currentTime = '--:--'.obs;
  final isWakeUpTime = false.obs;
  final userName = ''.obs;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer? _clockTimer;
  Timer? _alarmTimer;

  late final AnimationController arrowAnimationController;
  late final Animation<double> arrowOffsetAnimation;
  late final Animation<Color?> arrowColorAnimation;

  late final String wakeUpTime;
  late final String email;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? const {};
    wakeUpTime = _normalizeTime(args['wakeUpTime'] ?? args['wake_up_time']);
    email = args['email']?.toString() ?? _sessionService.email ?? '';

    _initAnimation();
    _initNotifications();
    _startClock();
    _loadUserName();
  }

  void _initAnimation() {
    arrowAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    arrowOffsetAnimation =
        Tween<double>(begin: 20, end: 0).animate(arrowAnimationController);
    arrowColorAnimation =
        ColorTween(begin: Colors.white, end: Colors.grey).animate(
      arrowAnimationController,
    );
  }

  Future<void> _initNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
  }

  void _startClock() {
    _updateCurrentTime();
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCurrentTime();
    });
  }

  void _updateCurrentTime() {
    final now = DateTime.now();
    final formatted = DateFormat('HH:mm').format(now);
    currentTime.value = formatted;

    if (!isWakeUpTime.value &&
        wakeUpTime.isNotEmpty &&
        formatted == wakeUpTime) {
      isWakeUpTime.value = true;
      _startRepeatingAlarm();
    }
  }

  Future<void> _loadUserName() async {
    final storedProfile = _sessionService.loadProfile();
    final storedName = storedProfile['name']?.toString();
    if (storedName != null && storedName.isNotEmpty) {
      userName.value = storedName;
      return;
    }

    final token = _sessionService.token;
    if (token == null) {
      return;
    }

    try {
      final profile = await _userRepository.fetchProfile(token: token);
      final fetchedName = profile.name?.trim() ?? '';
      if (fetchedName.isNotEmpty) {
        userName.value = fetchedName;
        await _sessionService.saveProfile({'name': fetchedName});
      }
    } catch (_) {
      // Dibiarkan kosong, gunakan nama default
    }
  }

  Future<void> _startRepeatingAlarm() async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm',
      channelDescription: 'Alarm Notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    _alarmTimer?.cancel();
    _alarmTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _notificationsPlugin.show(
        0,
        'Waktu Bangun',
        'Ini saatnya untuk bangun!',
        notificationDetails,
        payload: 'alarm_payload',
      );
    });
  }

  Future<void> stopAlarm() async {
    _alarmTimer?.cancel();
    await _notificationsPlugin.cancelAll();
    isWakeUpTime.value = false;
  }

  Future<void> onSwipeUp() async {
    if (!isWakeUpTime.value) return;
    await stopAlarm();
    Get.offAllNamed(
      AppRoutes.home,
      arguments: {
        'email': email,
      },
    );
  }

  String _normalizeTime(dynamic raw) {
    if (raw == null) return '';
    if (raw is DateTime) {
      return DateFormat('HH:mm').format(raw);
    }
    final text = raw.toString();
    final parts = text.split(':');
    if (parts.length >= 2) {
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return '$hour:$minute';
    }
    return text;
  }

  @override
  void onClose() {
    arrowAnimationController.dispose();
    _clockTimer?.cancel();
    _alarmTimer?.cancel();
    super.onClose();
  }
}
