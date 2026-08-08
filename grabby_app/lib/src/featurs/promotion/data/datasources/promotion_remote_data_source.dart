import '../../../../core/core_export.dart';
import '../models/promotion_model.dart';
import '../models/upcoming_event_model.dart';

abstract class PromotionRemoteDataSource {
  Future<ApiResponse<PromotionModel>> createPromotion(Map<String, dynamic> data);
  Future<ApiResponse<PromotionListResponse>> getPromotions({
    String searchTerm = '',
    int page = 1,
    int limit = 10,
  });
  Future<ApiResponse<void>> updatePromotion(String id, Map<String, dynamic> data);
  Future<ApiResponse<void>> deletePromotion(String id);
  Future<ApiResponse<List<UpcomingEventModel>>> getUpcomingEvents();
}

class PromotionRemoteDataSourceImpl implements PromotionRemoteDataSource {
  final ApiService _apiService;

  PromotionRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<PromotionModel>> createPromotion(Map<String, dynamic> data) async {
    return await _apiService.post<PromotionModel>(
      '/event-offer/create',
      data: data,
      fromJson: (json) => PromotionModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<PromotionListResponse>> getPromotions({
    String searchTerm = '',
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<PromotionListResponse>(
      '/event-offer/shop',
      queryParameters: {
        'searchTerm': searchTerm,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: (json) => PromotionListResponse.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> updatePromotion(String id, Map<String, dynamic> data) async {
    return await _apiService.patch<void>(
      '/event-offer/shop/$id',
      data: data,
    );
  }

  @override
  Future<ApiResponse<void>> deletePromotion(String id) async {
    return await _apiService.delete<void>(
      '/event-offer/shop/$id',
    );
  }

  @override
  Future<ApiResponse<List<UpcomingEventModel>>> getUpcomingEvents() async {
    return await _apiService.get<List<UpcomingEventModel>>(
      ApiEndpoints.upcomingEvents,
      queryParameters: {'limit': '100'},
      fromJson: (json) {
        final data = json['data'] as List;
        return data
            .map((e) => UpcomingEventModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}