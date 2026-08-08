import '../../../../core/core_export.dart';
import '../../data/models/promotion_model.dart';
import '../../data/models/upcoming_event_model.dart';

abstract class PromotionRepository {
  Future<ApiResponse<PromotionModel>> createPromotion(Map<String, dynamic> data);
  Future<ApiResponse<PromotionListResponse>> getPromotions({
    String? searchTerm,
    int? page,
    int? limit,
  });
  Future<ApiResponse<void>> updatePromotion(String id, Map<String, dynamic> data);
  Future<ApiResponse<void>> deletePromotion(String id);
  Future<ApiResponse<List<UpcomingEventModel>>> getUpcomingEvents();
}