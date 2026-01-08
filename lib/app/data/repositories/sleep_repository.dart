import 'package:intl/intl.dart';

import '../../core/utils/api_endpoints.dart';
import '../providers/api_client.dart';

class SleepRepository {
  SleepRepository(ApiClient apiClient) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> fetchDailyRecords(
      {required String email}) async {
    final response =
        await _apiClient.get(ApiEndpoints.sleepRecordsByEmail(email));

    if (response is List) {
      return response.map<Map<String, dynamic>>((dynamic item) {
        if (item is Map<String, dynamic>) {
          return Map<String, dynamic>.from(item);
        }
        throw const FormatException('Format catatan tidur tidak valid');
      }).toList();
    }

    throw const FormatException('Format respons data tidur harian tidak valid');
  }

  Future<Map<String, dynamic>> fetchWeeklyData({
    required String email,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final formatter = DateFormat('yyyy-MM-dd');
    final inclusiveEndDate = endDate.add(const Duration(days: 1));
    final response = await _apiClient.get(
      ApiEndpoints.sleepWeekly(
        email,
        startDate: formatter.format(startDate),
        endDate: formatter.format(inclusiveEndDate),
      ),
    );

    if (response is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response);
    }

    throw const FormatException(
        'Format respons data tidur mingguan tidak valid');
  }

  Future<Map<String, dynamic>> fetchMonthlyData({
    required String email,
    required int month,
    required int year,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.sleepMonthly(
        email,
        month: month.toString().padLeft(2, '0'),
        year: year.toString(),
      ),
    );

    if (response is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response);
    }

    throw const FormatException(
        'Format respons data tidur bulanan tidak valid');
  }
}
