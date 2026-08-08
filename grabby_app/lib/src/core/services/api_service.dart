import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'local_storage_service.dart';

class ApiService {
  late final Dio _dio;
  final LocalStorageService? _localStorageService;

  ApiService({
    required String baseUrl,
    LocalStorageService? localStorageService,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    List<Interceptor>? interceptors,
  }) : _localStorageService = localStorageService {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for Authorization header
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _localStorageService?.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // Add default logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => print(o),
      ),
    );

    // Add any custom interceptors
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  /// Set or update the auth token in headers
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear the auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // ─── Core Request Handler ──────────────────────────────────────────────────

  Future<ApiResponse<T>> _request<T>({
    required String method,
    required String path,
    T? Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
      );

      final responseData = response.data as Map<String, dynamic>;
      return ApiResponse<T>.fromJson(responseData, fromJson);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  // ─── HTTP Methods ──────────────────────────────────────────────────────────

  Future<ApiResponse<T>> get<T>(
    String path, {
    T? Function(dynamic)? fromJson,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request<T>(
      method: 'GET',
      path: path,
      fromJson: fromJson,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    T? Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request<T>(
      method: 'POST',
      path: path,
      fromJson: fromJson,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    T? Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request<T>(
      method: 'PUT',
      path: path,
      fromJson: fromJson,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    T? Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request<T>(
      method: 'PATCH',
      path: path,
      fromJson: fromJson,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    T? Function(dynamic)? fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _request<T>(
      method: 'DELETE',
      path: path,
      fromJson: fromJson,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // ─── Multipart / File Upload ───────────────────────────────────────────────

  Future<ApiResponse<T>> uploadFile<T>(
    String path, {
    required FormData formData,
    T? Function(dynamic)? fromJson,
    void Function(int sent, int total)? onSendProgress,
  }) {
    return _request<T>(
      method: 'POST',
      path: path,
      fromJson: fromJson,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        extra: {'onSendProgress': onSendProgress},
      ),
    );
  }

  // ─── Error Handling ────────────────────────────────────────────────────────

  ApiException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          statusCode: 408,
          message: 'Request timed out. Please try again.',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        // Try to extract server message from our standard response format
        if (responseData is Map<String, dynamic>) {
          return ApiException(
            statusCode: statusCode,
            message: responseData['message'] ?? 'An error occurred.',
            success: responseData['success'] ?? false,
          );
        }

        return ApiException(
          statusCode: statusCode,
          message: _defaultMessageForStatus(statusCode),
        );

      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled.');

      case DioExceptionType.connectionError:
        return ApiException(
          statusCode: 503,
          message: 'No internet connection. Please check your network.',
        );

      default:
        return ApiException(message: e.message ?? 'Something went wrong.');
    }
  }

  String _defaultMessageForStatus(int? statusCode) {
    switch (statusCode) {
      case 400: return 'Bad request.';
      case 401: return 'Unauthorized. Please log in again.';
      case 403: return 'Access forbidden.';
      case 404: return 'Resource not found.';
      case 409: return 'Conflict with current state.';
      case 422: return 'Validation failed.';
      case 500: return 'Internal server error.';
      case 502: return 'Bad gateway.';
      case 503: return 'Service unavailable.';
      default:  return 'An unexpected error occurred.';
    }
  }
}
