import 'dart:convert';

import '../../core/utils/api_endpoints.dart';
import '../providers/api_client.dart';

class MetricsRepository {
  MetricsRepository(ApiClient apiClient) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<void> updateUserMetrics({
    required String email,
    required Map<String, dynamic> metrics,
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    await _apiClient.patch(
      ApiEndpoints.usersMetrics(email),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'upper_pressure': metrics['upperPressure'],
        'lower_pressure': metrics['lowerPressure'],
        if (metrics['daily_steps'] != null)
          'daily_steps': metrics['daily_steps'],
        if (metrics['heart_rate'] != null) 'heart_rate': metrics['heart_rate'],
      }),
    );
  }

  Future<void> saveSleepSchedule({
    required String email,
    required DateTime sleepTime,
    required DateTime wakeTime,
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    await _apiClient.post(
      ApiEndpoints.sleepRecords(),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'sleep_time': sleepTime.toIso8601String(),
        'wake_time': wakeTime.toIso8601String(),
      }),
    );
  }
}
