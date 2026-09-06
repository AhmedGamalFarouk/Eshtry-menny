import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_exceptions.dart';

class ApiClient {
  final http.Client _httpClient;
  final Duration timeoutDuration;
  final int defaultMaxRetries;

  ApiClient({
    http.Client? httpClient,
    this.timeoutDuration = const Duration(seconds: 15),
    this.defaultMaxRetries = 3,
  }) : _httpClient = httpClient ?? http.Client();

  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Performs an HTTP GET request with automatic retries on transient errors.
  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    int? maxRetries,
  }) async {
    final retries = maxRetries ?? defaultMaxRetries;
    return _executeWithRetry(
      () => _httpClient
          .get(
            Uri.parse(url),
            headers: {..._defaultHeaders, if (headers != null) ...headers},
          )
          .timeout(timeoutDuration),
      maxRetries: retries,
    );
  }

  /// Performs an HTTP POST request with automatic retries on transient errors.
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    int? maxRetries,
  }) async {
    final retries = maxRetries ?? defaultMaxRetries;
    final encodedBody = body is String ? body : json.encode(body);
    return _executeWithRetry(
      () => _httpClient
          .post(
            Uri.parse(url),
            headers: {..._defaultHeaders, if (headers != null) ...headers},
            body: encodedBody,
          )
          .timeout(timeoutDuration),
      maxRetries: retries,
    );
  }

  /// Executes an HTTP operation with exponential backoff on transient failures.
  Future<dynamic> _executeWithRetry(
    Future<http.Response> Function() requestFn, {
    required int maxRetries,
  }) async {
    int attempts = 0;
    while (true) {
      attempts++;
      try {
        final response = await requestFn();
        return _handleResponse(response);
      } on SocketException catch (_) {
        if (attempts >= maxRetries) {
          throw const NetworkException();
        }
        await _delayBackoff(attempts);
      } on http.ClientException catch (_) {
        if (attempts >= maxRetries) {
          throw const NetworkException();
        }
        await _delayBackoff(attempts);
      } on TimeoutException catch (_) {
        if (attempts >= maxRetries) {
          throw const ApiTimeoutException();
        }
        await _delayBackoff(attempts);
      } on ServerException catch (_) {
        if (attempts >= maxRetries) {
          rethrow;
        }
        await _delayBackoff(attempts);
      }
    }
  }

  /// Exponential backoff delay: 300ms, 600ms, 1200ms...
  Future<void> _delayBackoff(int attempt) async {
    final milliseconds = 300 * (1 << (attempt - 1));
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Validates HTTP status code and parses JSON body.
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return json.decode(response.body);
      } catch (_) {
        throw const ParseException();
      }
    } else if (statusCode == 401 || statusCode == 403) {
      throw AuthException(
        'Authentication failed: invalid credentials.',
        statusCode,
      );
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ClientException(
        'Request failed with status $statusCode.',
        statusCode,
      );
    } else if (statusCode >= 500) {
      throw ServerException(
        'Server error with status $statusCode.',
        statusCode,
      );
    } else {
      throw ClientException('Unexpected status code $statusCode.', statusCode);
    }
  }

  void close() {
    _httpClient.close();
  }
}
