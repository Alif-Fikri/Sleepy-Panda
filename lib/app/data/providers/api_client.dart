import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<dynamic> get(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    final response = await _httpClient.get(uri, headers: headers);
    return _decodeResponse(response);
  }

  Future<dynamic> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _httpClient.post(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _decodeResponse(response);
  }

  Future<dynamic> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _httpClient.patch(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _decodeResponse(response);
  }

  Future<dynamic> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _httpClient.put(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _decodeResponse(response);
  }

  Future<dynamic> delete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await _httpClient.delete(
      uri,
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return _decodeResponse(response);
  }

  dynamic _decodeResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isEmpty ? null : jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    }

    throw ApiClientException(
      statusCode: statusCode,
      message: body is Map<String, dynamic> && body['message'] != null
          ? body['message'].toString()
          : 'Unexpected error',
      payload: body,
    );
  }

  void close() {
    _httpClient.close();
  }
}

class ApiClientException implements Exception {
  ApiClientException(
      {required this.statusCode, required this.message, this.payload});

  final int statusCode;
  final String message;
  final dynamic payload;

  @override
  String toString() =>
      'ApiClientException(statusCode: $statusCode, message: $message)';
}
