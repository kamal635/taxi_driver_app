abstract final class NetworkConstants {
  const NetworkConstants._();

  static const String baseUrl = 'https://taxi-backend.laithroom.com';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  static const Map<String, String> defaultJsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String refreshEndpoint = '/api/auth/refresh';
}
