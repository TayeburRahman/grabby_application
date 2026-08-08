import '../../../../src_export.dart';
import '../datasources/branch_remote_data_source.dart';

abstract class BranchRepository {
  Future<ApiResponse<List<CustomerBranchModel>>> getBranches({
    String? query,
    double? lat,
    double? lng,
  });
  Future<ApiResponse<CustomerBranchModel>> getBranchDetail(String id);
}

class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource remoteDataSource;

  BranchRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<List<CustomerBranchModel>>> getBranches({
    String? query,
    double? lat,
    double? lng,
  }) async {
    return await remoteDataSource.getBranches(
      query: query,
      lat: lat,
      lng: lng,
    );
  }

  @override
  Future<ApiResponse<CustomerBranchModel>> getBranchDetail(String id) async {
    return await remoteDataSource.getBranchDetail(id);
  }
}
