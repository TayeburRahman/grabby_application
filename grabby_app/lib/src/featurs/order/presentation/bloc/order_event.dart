
part of 'order_bloc.dart';

abstract class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final OrderModel order;
  CreateOrderEvent(this.order);
}

class FetchMyOrdersEvent extends OrderEvent {
  final String? status;
  final int page;
  final int limit;
  FetchMyOrdersEvent({this.status, this.page = 1, this.limit = 10});
}

class FetchOrderDetailsEvent extends OrderEvent {
  final String orderId;
  FetchOrderDetailsEvent(this.orderId);
}

class FetchBranchOrdersEvent extends OrderEvent {
  final String branchId;
  final String? status;
  final int page;
  final int limit;
  FetchBranchOrdersEvent({required this.branchId, this.status, this.page = 1, this.limit = 10});
}

class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final String status;
  UpdateOrderStatusEvent({required this.orderId, required this.status});
}

class CancelOrderEvent extends OrderEvent {
  final String orderId;
  final String? cancelNote;
  CancelOrderEvent(this.orderId, {this.cancelNote});
}

class RespondToCancelEvent extends OrderEvent {
  final String orderId;
  final String action; // 'accept' or 'decline'
  RespondToCancelEvent({required this.orderId, required this.action});
}
