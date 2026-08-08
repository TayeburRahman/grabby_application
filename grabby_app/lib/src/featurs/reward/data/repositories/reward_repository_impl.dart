import '../../../../core/services/api_response.dart';
import '../models/wallet_model.dart';
import '../datasources/reward_remote_data_source.dart';

abstract class RewardRepository {
  Future<ApiResponse<WalletModel>> getWallet();
  Future<ApiResponse<void>> convertPoints(int points);
}

class RewardRepositoryImpl implements RewardRepository {
  final RewardRemoteDataSource remoteDataSource;

  RewardRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<WalletModel>> getWallet() {
    return remoteDataSource.getWallet();
  }

  @override
  Future<ApiResponse<void>> convertPoints(int points) {
    return remoteDataSource.convertPoints(points);
  }
}
