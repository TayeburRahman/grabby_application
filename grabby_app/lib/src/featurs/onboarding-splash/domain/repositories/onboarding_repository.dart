
import 'package:grabby_app/src/featurs/onboarding-splash/data/datasources/onboarding_remote_data_source.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/data/models/faq_model.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/data/models/fee_structure_model.dart';

import '../../../../src_export.dart';

abstract class OnboardingRepository {
  Future<ApiResponse<List<FeeStructureModel>>> getFeeStructures();
  Future<ApiResponse<List<FaqModel>>> getFaqs();
}

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;
  OnboardingRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<List<FeeStructureModel>>> getFeeStructures() =>
      remoteDataSource.getFeeStructures();

  @override
  Future<ApiResponse<List<FaqModel>>> getFaqs() => remoteDataSource.getFaqs();
}
