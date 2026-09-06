abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException(
      [super.message =
          'No internet connection. Please check your network and try again.']);
}

class ApiTimeoutException extends ApiException {
  const ApiTimeoutException(
      [super.message = 'The request timed out. Please try again.']);
}

class ServerException extends ApiException {
  const ServerException(
      [super.message = 'Server error occurred. Please try again later.',
      super.statusCode]);
}

class ClientException extends ApiException {
  const ClientException(
      [super.message = 'Invalid request.', super.statusCode]);
}

class AuthException extends ApiException {
  const AuthException(
      [super.message = 'Invalid credentials.', super.statusCode]);
}

class ParseException extends ApiException {
  const ParseException(
      [super.message = 'Failed to parse server response.']);
}
