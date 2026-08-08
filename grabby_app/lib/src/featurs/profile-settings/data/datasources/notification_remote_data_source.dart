import '../../../../src_export.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<ApiResponse<List<NotificationModel>>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService _apiService;

  NotificationRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotifications() async {
    return await _apiService.get<List<NotificationModel>>(
      ApiEndpoints.notifications,
      fromJson: (json) {
        final data = json['data'];
        if (data is List) {
          return data.map((e) => NotificationModel.fromJson(e)).toList();
        }
        return [];
      },
    );
  }
}
