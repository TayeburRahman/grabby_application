


import 'package:grabby_app/src/featurs/onboarding-splash/data/models/faq_model.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/data/models/fee_structure_model.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/domain/repositories/onboarding_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'onboarding_info_event.dart';
part 'onboarding_info_state.dart';

class OnboardingInfoBloc
    extends Bloc<OnboardingInfoEvent, OnboardingInfoState> {
  final OnboardingRepository _repository;

  OnboardingInfoBloc(this._repository) : super(OnboardingInfoState()) {
    on<GetOnboardingInfoEvent>(_onGetOnboardingInfo);
  }

  Future<void> _onGetOnboardingInfo(
    GetOnboardingInfoEvent event,
    Emitter<OnboardingInfoState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingInfoStatus.loading));
    try {
      final feeResponse = await _repository.getFeeStructures();
      final faqResponse = await _repository.getFaqs();

      if (feeResponse.success && faqResponse.success) {
        emit(state.copyWith(
          status: OnboardingInfoStatus.success,
          feeStructures: feeResponse.data,
          faqs: faqResponse.data,
        ));
      } else {
        emit(state.copyWith(
          status: OnboardingInfoStatus.failure,
          errorMessage: feeResponse.message ?? faqResponse.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: OnboardingInfoStatus.failure,
        errorMessage: "Failed to load onboarding info",
      ));
    }
  }
}
