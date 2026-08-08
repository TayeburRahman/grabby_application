import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core_export.dart';
import '../../data/models/promotion_model.dart';
import '../../data/models/upcoming_event_model.dart';
import '../../domain/repositories/promotion_repository.dart';

part 'promotion_event.dart';
part 'promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final PromotionRepository repository;

  PromotionBloc(this.repository) : super(PromotionInitial()) {
    on<GetPromotionsEvent>(_onGetPromotions);
    on<CreatePromotionEvent>(_onCreatePromotion);
    on<UpdatePromotionEvent>(_onUpdatePromotion);
    on<DeletePromotionEvent>(_onDeletePromotion);
    on<FetchUpcomingEventsEvent>(_onFetchUpcomingEvents);
  }

  Future<void> _onGetPromotions(
    GetPromotionsEvent event,
    Emitter<PromotionState> emit,
  ) async {
    emit(PromotionLoading());
    try {
      final promotionsResponse = await repository.getPromotions(
        searchTerm: event.searchTerm,
        page: event.page,
        limit: event.limit,
      );

      final eventsResponse = await repository.getUpcomingEvents();

      if (promotionsResponse.success) {
        emit(PromotionsLoaded(
          promotionsResponse.data!,
          upcomingEvents: eventsResponse.success ? eventsResponse.data! : [],
        ));
      } else {
        emit(PromotionError(promotionsResponse.message));
      }
    } on ApiException catch (e) {
      emit(PromotionError(e.message));
    } catch (e) {
      emit(PromotionError('Failed to load promotions'));
    }
  }

  Future<void> _onFetchUpcomingEvents(
    FetchUpcomingEventsEvent event,
    Emitter<PromotionState> emit,
  ) async {
    try {
      final response = await repository.getUpcomingEvents();
      if (response.success) {
        if (state is PromotionsLoaded) {
          final currentLoaded = state as PromotionsLoaded;
          emit(PromotionsLoaded(
            currentLoaded.data,
            upcomingEvents: response.data!,
          ));
        } else {
          emit(UpcomingEventsLoaded(response.data!));
        }
      } else {
        emit(PromotionError(response.message));
      }
    } catch (e) {
      emit(PromotionError('Failed to load upcoming events'));
    }
  }

  Future<void> _onCreatePromotion(
    CreatePromotionEvent event,
    Emitter<PromotionState> emit,
  ) async {
    emit(PromotionLoading());
    try {
      final response = await repository.createPromotion(event.data);
      if (response.success) {
        emit(PromotionOperationSuccess('Promotion created successfully'));
        add(GetPromotionsEvent());
      } else {
        emit(PromotionError(response.message));
      }
    } on ApiException catch (e) {
      emit(PromotionError(e.message));
    } catch (e) {
      emit(PromotionError('Failed to create promotion'));
    }
  }

  Future<void> _onUpdatePromotion(
    UpdatePromotionEvent event,
    Emitter<PromotionState> emit,
  ) async {
    emit(PromotionLoading());
    try {
      final response = await repository.updatePromotion(event.id, event.data);
      if (response.success) {
        emit(PromotionOperationSuccess('Promotion updated successfully'));
        add(GetPromotionsEvent());
      } else {
        emit(PromotionError(response.message));
      }
    } on ApiException catch (e) {
      emit(PromotionError(e.message));
    } catch (e) {
      emit(PromotionError('Failed to update promotion'));
    }
  }

  Future<void> _onDeletePromotion(
    DeletePromotionEvent event,
    Emitter<PromotionState> emit,
  ) async {
    emit(PromotionLoading());
    try {
      final response = await repository.deletePromotion(event.id);
      if (response.success) {
        emit(PromotionOperationSuccess('Promotion deleted successfully'));
        add(GetPromotionsEvent());
      } else {
        emit(PromotionError(response.message));
      }
    } on ApiException catch (e) {
      emit(PromotionError(e.message));
    } catch (e) {
      emit(PromotionError('Failed to delete promotion'));
    }
  }
}