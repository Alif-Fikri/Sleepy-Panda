import 'dart:convert';

import 'package:sleepys/app/core/utils/api_endpoints.dart';

import '../models/prediction.dart';
import '../providers/api_client.dart';

class PredictionRepository {
  PredictionRepository(ApiClient apiClient) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Map<String, String> get _jsonHeaders => const {
        'Content-Type': 'application/json',
      };

  Future<PredictionLabel> runDaily({required String email}) async {
    return _fetchPrediction(
      uri: ApiEndpoints.predictionsRun(),
      email: email,
      responseField: 'prediction',
    );
  }

  Future<PredictionLabel> runWeekly({required String email}) async {
    return _fetchPrediction(
      uri: ApiEndpoints.predictionsWeekly(),
      email: email,
      responseField: 'weekly_prediction',
    );
  }

  Future<PredictionLabel> runMonthly({required String email}) async {
    return _fetchPrediction(
      uri: ApiEndpoints.predictionsMonthly(),
      email: email,
      responseField: 'monthly_prediction',
    );
  }

  Future<void> saveDaily({
    required String email,
    required PredictionLabel label,
  }) {
    return _savePrediction(
      uri: ApiEndpoints.predictionsSave(),
      email: email,
      label: label,
    );
  }

  Future<void> saveWeekly({
    required String email,
    required PredictionLabel label,
  }) {
    return _savePrediction(
      uri: ApiEndpoints.predictionsWeeklySave(),
      email: email,
      label: label,
    );
  }

  Future<void> saveMonthly({
    required String email,
    required PredictionLabel label,
  }) {
    return _savePrediction(
      uri: ApiEndpoints.predictionsMonthlySave(),
      email: email,
      label: label,
    );
  }

  Future<PredictionLabel> _fetchPrediction({
    required Uri uri,
    required String email,
    required String responseField,
  }) async {
    final response = await _apiClient.post(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode({'email': email}),
    );

    if (response is! Map<String, dynamic>) {
      throw const FormatException('Format data prediksi tidak valid');
    }

    final rawValue = response[responseField];
    if (rawValue == null) {
      throw const FormatException('Hasil prediksi tidak tersedia');
    }

    final label = tryParsePredictionLabel(rawValue.toString());
    if (label == null) {
      throw FormatException('Label prediksi tidak dikenal: $rawValue');
    }

    return label;
  }

  Future<void> _savePrediction({
    required Uri uri,
    required String email,
    required PredictionLabel label,
  }) async {
    await _apiClient.post(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode({
        'email': email,
        'prediction_result': label.resultCode,
      }),
    );
  }
}
