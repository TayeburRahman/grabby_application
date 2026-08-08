import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../src_export.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/models/shop_ad_model.dart';

part 'promoted_ads_event.dart';
part 'promoted_ads_state.dart';

class PromotedAdsBloc extends Bloc<PromotedAdsEvent, PromotedAdsState> {
  final HomeRepository _repository;
  final LocationService _locationService;

  PromotedAdsBloc({
    required HomeRepository repository,
    required LocationService locationService,
  })  : _repository = repository,
        _locationService = locationService,
        super(PromotedAdsInitial()) {
    on<GetPromotedAdsEvent>(_onGetPromotedAds);
  }

  Future<void> _onGetPromotedAds(
    GetPromotedAdsEvent event,
    Emitter<PromotedAdsState> emit,
  ) async {
    emit(PromotedAdsLoading());
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        final response = await _repository.getPromotedAds(
          position.latitude,
          position.longitude,
        );
        if (response.success && response.data != null) {
          emit(PromotedAdsLoaded(response.data!));
        } else {
          emit(PromotedAdsError(response.message));
        }
      } else {
        emit(PromotedAdsError('Could not obtain location.'));
      }
    } catch (e) {
      emit(PromotedAdsError('An unexpected error occurred: $e'));
    }
  }
}
