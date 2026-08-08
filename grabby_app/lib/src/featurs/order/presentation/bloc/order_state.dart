
part of 'order_bloc.dart';

enum OrderStatus { initial, loading, success, failure, updating }

class OrderState {
  final OrderStatus status;
  final List<OrderModel> orders;
  final OrderModel? selectedOrder;
  final String? errorMessage;
  final String? successMessage;
  final int? totalOrders;
  // Tracks which query produced the current orders list
  final String? fetchedBranchId;
  final String? fetchedStatus;

  OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.selectedOrder,
    this.errorMessage,
    this.successMessage,
    this.totalOrders,
    this.fetchedBranchId,
    this.fetchedStatus,
  });

  OrderState copyWith({
    OrderStatus? status,
    List<OrderModel>? orders,
    OrderModel? selectedOrder,
    String? errorMessage,
    String? successMessage,
    int? totalOrders,
    String? fetchedBranchId,
    String? fetchedStatus,
    bool clearSuccessMessage = false,
    bool clearErrorMessage = false,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      totalOrders: totalOrders ?? this.totalOrders,
      fetchedBranchId: fetchedBranchId ?? this.fetchedBranchId,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
    );
  }
}
