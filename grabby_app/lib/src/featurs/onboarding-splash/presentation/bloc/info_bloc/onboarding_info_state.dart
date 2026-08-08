
part of 'onboarding_info_bloc.dart';

enum OnboardingInfoStatus { initial, loading, success, failure }

class OnboardingInfoState {
  final OnboardingInfoStatus status;
  final List<FeeStructureModel> feeStructures;
  final List<FaqModel> faqs;
  final String? errorMessage;

  OnboardingInfoState({
    this.status = OnboardingInfoStatus.initial,
    this.feeStructures = const [],
    this.faqs = const [],
    this.errorMessage,
  });

  OnboardingInfoState copyWith({
    OnboardingInfoStatus? status,
    List<FeeStructureModel>? feeStructures,
    List<FaqModel>? faqs,
    String? errorMessage,
  }) {
    return OnboardingInfoState(
      status: status ?? this.status,
      feeStructures: feeStructures ?? this.feeStructures,
      faqs: faqs ?? this.faqs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
