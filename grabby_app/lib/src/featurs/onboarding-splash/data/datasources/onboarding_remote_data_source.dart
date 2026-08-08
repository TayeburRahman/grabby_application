
import '../../../../src_export.dart';
import '../models/fee_structure_model.dart';
import '../models/faq_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<ApiResponse<List<FeeStructureModel>>> getFeeStructures();
  Future<ApiResponse<List<FaqModel>>> getFaqs();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final ApiService apiService;
  OnboardingRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<List<FeeStructureModel>>> getFeeStructures() async {
    return await apiService.get<List<FeeStructureModel>>(
      ApiEndpoints.feeStructure,
      fromJson: (json) => (json['data'] as List)
          .map((e) => FeeStructureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<List<FaqModel>>> getFaqs() async {
    return await apiService.get<List<FaqModel>>(
      ApiEndpoints.faq,
      fromJson: (json) => (json['data'] as List)
          .map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
