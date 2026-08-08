import '../../../../src_export.dart';
import '../../domain/repositories/promotion_repository.dart';
import '../datasources/promotion_remote_data_source.dart';
import '../models/promotion_model.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  final PromotionRemoteDataSource remoteDataSource;

  PromotionRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<PromotionModel>> createPromotion(Map<String, dynamic> data) {
    return remoteDataSource.createPromotion(data);
  }

  @override
  Future<ApiResponse<PromotionListResponse>> getPromotions({
    String? searchTerm,
    int? page,
    int? limit,
  }) {
    return remoteDataSource.getPromotions(
      searchTerm: searchTerm ?? '',
      page: page ?? 1,
      limit: limit ?? 10,
    );
  }

  @override
  Future<ApiResponse<void>> updatePromotion(String id, Map<String, dynamic> data) {
    return remoteDataSource.updatePromotion(id, data);
  }

  @override
  Future<ApiResponse<void>> deletePromotion(String id) {
    return remoteDataSource.deletePromotion(id);
  }

  @override
  Future<ApiResponse<List<UpcomingEventModel>>> getUpcomingEvents() {
    return remoteDataSource.getUpcomingEvents();
  }
}