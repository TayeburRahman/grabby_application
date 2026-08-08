
import '../../../../src_export.dart';
import '../../data/models/shop_dashboard_model.dart';
import '../../domain/repositories/home_repository.dart';

part 'shop_dashboard_event.dart';
part 'shop_dashboard_state.dart';

class ShopDashboardBloc extends Bloc<ShopDashboardEvent, ShopDashboardState> {
  final HomeRepository _homeRepository;

  ShopDashboardBloc(this._homeRepository) : super(ShopDashboardState()) {
    on<GetShopDashboardStatsEvent>(_onGetShopDashboardStats);
  }

  Future<void> _onGetShopDashboardStats(
    GetShopDashboardStatsEvent event,
    Emitter<ShopDashboardState> emit,
  ) async {
    emit(state.copyWith(status: ShopDashboardStatus.loading));
    try {
      final response = await _homeRepository.getShopDashboardStats();
      if (response.success && response.data != null) {
        emit(state.copyWith(
          status: ShopDashboardStatus.success,
          stats: response.data,
        ));
      } else {
        emit(state.copyWith(
          status: ShopDashboardStatus.failure,
          errorMessage: response.message,
        ));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: ShopDashboardStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: ShopDashboardStatus.failure, errorMessage: "Failed to load dashboard stats."));
    }
  }
}
