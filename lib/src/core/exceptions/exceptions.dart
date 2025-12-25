class ServerException implements Exception {
  final String message;
  final String? statusCode;

  ServerException({required this.message, this.statusCode});
}

class GoogleAuthException implements Exception {
  final String message;

  GoogleAuthException({required this.message});
}
