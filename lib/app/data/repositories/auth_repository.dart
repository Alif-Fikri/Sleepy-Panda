import 'dart:convert';

import 'package:sleepys/app/core/utils/api_endpoints.dart';
import 'package:sleepys/app/data/providers/api_client.dart';

class AuthRepository {
  AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<String> login(
      {required String email, required String password}) async {
    final response = await _apiClient.post(
      ApiEndpoints.authLogin(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ) as Map<String, dynamic>;

    final token = response['access_token']?.toString();
    if (token == null) {
      throw const FormatException('Token tidak ditemukan pada respon');
    }

    return token;
  }

  Future<void> logout(String token) async {
    await _apiClient.post(
      ApiEndpoints.authLogout(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<String> register(Map<String, dynamic> payload) async {
    final response = await _apiClient.post(
      ApiEndpoints.authRegister(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    ) as Map<String, dynamic>;

    final token = response['access_token']?.toString();
    if (token == null) {
      throw const FormatException('Token tidak ditemukan pada respon');
    }

    return token;
  }

  Future<void> requestOtp(String email) async {
    await _apiClient.post(
      ApiEndpoints.authRequestOtp(email),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await _apiClient.post(
      ApiEndpoints.authVerifyOtp(email, otp),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await _apiClient.post(
      ApiEndpoints.authResetPassword(email, newPassword),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
