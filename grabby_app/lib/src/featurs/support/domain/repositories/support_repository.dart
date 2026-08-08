import 'package:grabby_app/src/featurs/support/data/datasources/support_remote_data_source.dart';
import 'package:grabby_app/src/featurs/support/data/models/help_center_model.dart';
import 'package:grabby_app/src/featurs/support/data/models/terms_and_conditions_model.dart';

import '../../../../src_export.dart';


abstract class SupportRepository {
  Future<ApiResponse<List<TermsAndConditionsModel>>> getTermsAndConditions();
  Future<ApiResponse<List<HelpCenterModel>>> getHelpCenter();
}

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource _remoteDataSource;

  SupportRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<TermsAndConditionsModel>>> getTermsAndConditions() {
    return _remoteDataSource.getTermsAndConditions();
  }

  @override
  Future<ApiResponse<List<HelpCenterModel>>> getHelpCenter() {
    return _remoteDataSource.getHelpCenter();
  }
}
