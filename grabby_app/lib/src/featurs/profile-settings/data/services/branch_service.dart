import '../../../../core/services/api_service.dart';
import '../../../../core/services/api_response.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/branch_model.dart';

class BranchService {
  final ApiService apiService;

  BranchService(this.apiService);

  Future<ApiResponse<List<ShopBranchModel>>> getBranches() async {
    return await apiService.get<List<ShopBranchModel>>(
      ApiEndpoints.branchBase,
      fromJson: (json) {
        final data = json['data'];
        if (data is List) {
          return data.map((e) => ShopBranchModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<ShopBranchModel>> createBranch(Map<String, dynamic> data) async {
    return await apiService.post<ShopBranchModel>(
      ApiEndpoints.branchBase,
      data: data,
      fromJson: (json) => ShopBranchModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ShopBranchModel>> updateBranch(String branchId, Map<String, dynamic> data) async {
    return await apiService.patch<ShopBranchModel>(
      ApiEndpoints.branchUpdate(branchId),
      data: data,
      fromJson: (json) => ShopBranchModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<void>> deleteBranch(String branchId) async {
    return await apiService.delete<void>(
      ApiEndpoints.branchDelete(branchId),
    );
  }

  Future<ApiResponse<ShopBranchModel>> getBranchDetails(String branchId) async {
    return await apiService.get<ShopBranchModel>(
      ApiEndpoints.branchUpdate(branchId),
      fromJson: (json) => ShopBranchModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ShopBranchModel>> getBranchAvailability(String branchId) async {
    return await apiService.get<ShopBranchModel>(
      ApiEndpoints.branchAvailability(branchId),
      fromJson: (json) => ShopBranchModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<ShopBranchModel>> updateBranchAvailability(String branchId, List<Map<String, dynamic>> availability) async {
    return await apiService.patch<ShopBranchModel>(
      ApiEndpoints.branchAvailability(branchId),
      data: {"availability": availability},
      fromJson: (json) => ShopBranchModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
