import 'package:grabby_app/src/core/core_export.dart';

import '../models/terms_and_conditions_model.dart';
import '../models/help_center_model.dart';

abstract class SupportRemoteDataSource {
  Future<ApiResponse<List<TermsAndConditionsModel>>> getTermsAndConditions();
  Future<ApiResponse<List<HelpCenterModel>>> getHelpCenter();
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final ApiService _apiService;

  SupportRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<List<TermsAndConditionsModel>>> getTermsAndConditions() async {
    return await _apiService.get<List<TermsAndConditionsModel>>(
      ApiEndpoints.termsAndConditions,
      fromJson: (json) {
        final data = json['data'];
        if (data is List) {
          return data.map((e) => TermsAndConditionsModel.fromJson(e)).toList();
        } else if (data is Map<String, dynamic>) {
          return [TermsAndConditionsModel.fromJson(data)];
        }
        return [];
      },
    );
  }

  @override
  Future<ApiResponse<List<HelpCenterModel>>> getHelpCenter() async {
    return await _apiService.get<List<HelpCenterModel>>(
      ApiEndpoints.helpCenter,
      fromJson: (json) =>
          (json['data'] as List).map((e) => HelpCenterModel.fromJson(e)).toList(),
    );
  }
}
