part of 'support_bloc.dart';

abstract class SupportState {}

class SupportInitial extends SupportState {}
class SupportLoading extends SupportState {}
class TermsAndConditionsLoaded extends SupportState {
  final List<TermsAndConditionsModel> data;
  TermsAndConditionsLoaded(this.data);
}
class HelpCenterLoaded extends SupportState {
  final List<HelpCenterModel> data;
  HelpCenterLoaded(this.data);
}
class SupportError extends SupportState {
  final String message;
  SupportError(this.message);
}
