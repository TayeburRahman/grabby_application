
import 'package:grabby_app/src/featurs/home/data/datasources/home_remote_data_source.dart';
import 'package:grabby_app/src/featurs/home/data/models/shop_ad_model.dart';
import 'package:grabby_app/src/featurs/home/data/models/shop_dashboard_model.dart';

import '../../../../core/core_export.dart';

abstract class HomeRepository {
  Future<ApiResponse<ShopDashboardModel>> getShopDashboardStats();
  Future<ApiResponse<List<ShopAdModel>>> getPromotedAds(double lat, double lon);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<ShopDashboardModel>> getShopDashboardStats() =>
      remoteDataSource.getShopDashboardStats();

  @override
  Future<ApiResponse<List<ShopAdModel>>> getPromotedAds(
          double lat, double lon) =>
      remoteDataSource.getPromotedAds(lat, lon);
}
