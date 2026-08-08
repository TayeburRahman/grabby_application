class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final bool success;

  ApiException({
    this.statusCode,
    required this.message,
    this.success = false,
  });

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}
