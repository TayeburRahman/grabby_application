
import '../../../../src_export.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc(this._orderRepository) : super(OrderState()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<FetchMyOrdersEvent>(_onFetchMyOrders);
    on<FetchOrderDetailsEvent>(_onFetchOrderDetails);
    on<FetchBranchOrdersEvent>(_onFetchBranchOrders);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<CancelOrderEvent>(_onCancelOrder);
    on<RespondToCancelEvent>(_onRespondToCancel);
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await _orderRepository.createOrder(event.order);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          status: OrderStatus.success,
          selectedOrder: response.data,
          successMessage: response.message,
        ));
      } else {
        emit(state.copyWith(status: OrderStatus.failure, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: "Failed to create order."));
    }
  }

  Future<void> _onFetchMyOrders(FetchMyOrdersEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading, clearSuccessMessage: true, clearErrorMessage: true));
    try {
      final response = await _orderRepository.getMyOrders(
        status: event.status,
        page: event.page,
        limit: event.limit,
      );
      if (response.success) {
        emit(state.copyWith(
          status: OrderStatus.success,
          orders: response.data ?? [],
          totalOrders: response.meta?['total'] as int?,
          clearSuccessMessage: true,
          clearErrorMessage: true,
        ));
      } else {
        emit(state.copyWith(status: OrderStatus.failure, errorMessage: response.message, clearSuccessMessage: true));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: e.message, clearSuccessMessage: true));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: "Failed to fetch orders.", clearSuccessMessage: true));
    }
  }

  Future<void> _onFetchOrderDetails(FetchOrderDetailsEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await _orderRepository.getOrderDetails(event.orderId);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          status: OrderStatus.success,
          selectedOrder: response.data,
        ));
      } else {
        emit(state.copyWith(status: OrderStatus.failure, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: "Failed to fetch order details."));
    }
  }

  Future<void> _onFetchBranchOrders(FetchBranchOrdersEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await _orderRepository.getBranchOrders(
        event.branchId,
        status: event.status,
        page: event.page,
        limit: event.limit,
      );
      if (response.success) {
        emit(state.copyWith(
          status: OrderStatus.success,
          orders: response.data ?? [],
          fetchedBranchId: event.branchId,
          fetchedStatus: event.status,
        ));
      } else {
        emit(state.copyWith(status: OrderStatus.failure, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: "Failed to fetch branch orders."));
    }
  }

  Future<void> _onUpdateOrderStatus(UpdateOrderStatusEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.updating));
    try {
      final response = await _orderRepository.updateOrderStatus(event.orderId, event.status);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          status: OrderStatus.success,
          selectedOrder: response.data,
          successMessage: response.message,
        ));
      } else {
        emit(state.copyWith(status: OrderStatus.failure, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: "Failed to update order status."));
    }
  }

  Future<void> _onCancelOrder(CancelOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await _orderRepository.cancelOrder(event.orderId, cancelNote: event.cancelNote);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          status: OrderStatus.success,
          successMessage: response.message,
        ));
        // Immediately clear the successMessage to prevent repeated triggers
        emit(state.copyWith(clearSuccessMessage: true));
      } else {
        emit(state.copyWith(status: OrderStatus.failure, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: "Failed to cancel order."));
    }
  }

  Future<void> _onRespondToCancel(RespondToCancelEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final response = await _orderRepository.respondToCancel(event.orderId, event.action);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          status: OrderStatus.success,
          successMessage: response.message,
        ));
        emit(state.copyWith(clearSuccessMessage: true));
      } else {
        emit(state.copyWith(status: OrderStatus.failure, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, errorMessage: "Failed to respond to cancellation."));
    }
  }
}
