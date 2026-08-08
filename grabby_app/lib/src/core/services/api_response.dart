class ApiResponse<T> {
  final int statusCode;
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: fromJsonT != null ? fromJsonT(json) : null,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T?)? toJsonT) {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': toJsonT != null ? toJsonT(data) : data,
    };
  }

  @override
  String toString() =>
      'ApiResponse(statusCode: $statusCode, success: $success, message: $message, data: $data)';
}
