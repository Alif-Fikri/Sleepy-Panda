import 'dart:convert';

import 'package:sleepys/app/core/utils/api_endpoints.dart';
import 'package:sleepys/app/data/models/user_profile.dart';
import 'package:sleepys/app/data/providers/api_client.dart';

class UserRepository {
  UserRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<UserProfile> fetchProfile({required String token}) async {
    final response = await _apiClient.get(
      ApiEndpoints.usersMeProfile(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ) as Map<String, dynamic>;

    return UserProfile.fromJson(response);
  }

  Future<UserProfile> updateProfile({
    required String email,
    required Map<String, dynamic> payload,
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _apiClient.patch(
      ApiEndpoints.usersPatch(email),
      headers: headers,
      body: jsonEncode(payload),
    ) as Map<String, dynamic>;

    return UserProfile.fromJson(response);
  }

  Future<UserProfile> updateWork({
    required String email,
    required Map<String, dynamic> payload,
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _apiClient.put(
      ApiEndpoints.usersWork(email),
      headers: headers,
      body: jsonEncode(payload),
    ) as Map<String, dynamic>;

    return UserProfile.fromJson(response);
  }
}
