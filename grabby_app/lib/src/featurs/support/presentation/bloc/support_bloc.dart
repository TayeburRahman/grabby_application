import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../src_export.dart';
import '../../domain/repositories/support_repository.dart';
import '../../data/models/terms_and_conditions_model.dart';
import '../../data/models/help_center_model.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final SupportRepository _repository;

  SupportBloc({required SupportRepository repository})
      : _repository = repository,
        super(SupportInitial()) {
    on<GetTermsAndConditionsEvent>(_onGetTermsAndConditions);
    on<GetHelpCenterEvent>(_onGetHelpCenter);
  }

  Future<void> _onGetTermsAndConditions(
    GetTermsAndConditionsEvent event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());
    try {
      final response = await _repository.getTermsAndConditions();
      if (response.success && response.data != null) {
        emit(TermsAndConditionsLoaded(response.data!));
      } else {
        emit(SupportError(response.message));
      }
    } on ApiException catch (e) {
      emit(SupportError(e.message));
    } catch (e) {
      emit(SupportError('Failed to load terms and conditions.'));
    }
  }

  Future<void> _onGetHelpCenter(
    GetHelpCenterEvent event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading());
    try {
      final response = await _repository.getHelpCenter();
      if (response.success && response.data != null) {
        emit(HelpCenterLoaded(response.data!));
      } else {
        emit(SupportError(response.message));
      }
    } on ApiException catch (e) {
      emit(SupportError(e.message));
    } catch (e) {
      emit(SupportError('Failed to load help center.'));
    }
  }
}
