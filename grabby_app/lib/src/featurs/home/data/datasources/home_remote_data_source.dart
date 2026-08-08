
import '../../../../src_export.dart';
import '../models/shop_ad_model.dart';
import '../models/shop_dashboard_model.dart';

abstract class HomeRemoteDataSource {
  Future<ApiResponse<ShopDashboardModel>> getShopDashboardStats();
  Future<ApiResponse<List<ShopAdModel>>> getPromotedAds(double lat, double lon);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;
  HomeRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<ShopDashboardModel>> getShopDashboardStats() async {
    return await apiService.get<ShopDashboardModel>(
      ApiEndpoints.shopDashboard,
      fromJson: (json) =>
          ShopDashboardModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<ShopAdModel>>> getPromotedAds(
      double lat, double lon) async {
    return await apiService.get<List<ShopAdModel>>(
      ApiEndpoints.promotedAds(lat, lon),
      fromJson: (json) =>
          (json['data'] as List).map((e) => ShopAdModel.fromJson(e)).toList(),
    );
  }
}
