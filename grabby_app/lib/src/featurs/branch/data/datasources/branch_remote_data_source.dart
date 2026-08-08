import '../../../../src_export.dart';

abstract class BranchRemoteDataSource {
  Future<ApiResponse<List<CustomerBranchModel>>> getBranches({
    String? query,
    double? lat,
    double? lng,
  });
  Future<ApiResponse<CustomerBranchModel>> getBranchDetail(String id);
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final ApiService apiService;

  BranchRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<List<CustomerBranchModel>>> getBranches({
    String? query,
    double? lat,
    double? lng,
  }) async {
    return await apiService.get<List<CustomerBranchModel>>(
      ApiEndpoints.customerBranches,
      queryParameters: {
        if (query != null && query.isNotEmpty) 'searchTerm': query,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lon': lng,
      },
      fromJson: (json) {
        final List<dynamic> data = json['data'] ?? [];
        return data.map((e) => CustomerBranchModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<ApiResponse<CustomerBranchModel>> getBranchDetail(String id) async {
    return await apiService.get<CustomerBranchModel>(
      ApiEndpoints.customerBranchDetail(id),
      fromJson: (json) => CustomerBranchModel.fromJson(json['data']),
    );
  }
}
