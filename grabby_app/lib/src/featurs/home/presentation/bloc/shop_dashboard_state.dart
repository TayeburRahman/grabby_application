
part of 'shop_dashboard_bloc.dart';

enum ShopDashboardStatus { initial, loading, success, failure }

class ShopDashboardState {
  final ShopDashboardStatus status;
  final ShopDashboardModel? stats;
  final String? errorMessage;

  ShopDashboardState({
    this.status = ShopDashboardStatus.initial,
    this.stats,
    this.errorMessage,
  });

  ShopDashboardState copyWith({
    ShopDashboardStatus? status,
    ShopDashboardModel? stats,
    String? errorMessage,
  }) {
    return ShopDashboardState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
