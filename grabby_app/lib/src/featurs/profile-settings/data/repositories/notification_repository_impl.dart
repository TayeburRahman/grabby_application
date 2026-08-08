import '../../../../src_export.dart';
import '../models/notification_model.dart';
import '../datasources/notification_remote_data_source.dart';

abstract class NotificationRepository {
  Future<ApiResponse<List<NotificationModel>>> getNotifications();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotifications() async {
    try {
      return await _remoteDataSource.getNotifications();
    } on ApiException catch (e) {
      return ApiResponse(
         statusCode: 500,
        success: false,
        message: e.message,
      );
    } catch (e) {
      return ApiResponse(
         statusCode: 500,
        success: false,
        message: 'Unexpected error: $e',
      );
    }
  }
}
