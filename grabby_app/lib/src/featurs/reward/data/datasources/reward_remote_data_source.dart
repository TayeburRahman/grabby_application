import '../../../../src_export.dart';
import '../models/wallet_model.dart';

abstract class RewardRemoteDataSource {
  Future<ApiResponse<WalletModel>> getWallet();
  Future<ApiResponse<void>> convertPoints(int points);
}

class RewardRemoteDataSourceImpl implements RewardRemoteDataSource {
  final ApiService apiService;

  RewardRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<WalletModel>> getWallet() async {
    return await apiService.get<WalletModel>(
      ApiEndpoints.wallet,
      fromJson: (json) =>
          WalletModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> convertPoints(int points) async {
    return await apiService.post<void>(
      ApiEndpoints.convertPoints,
      data: {"points": points},
    );
  }
}
