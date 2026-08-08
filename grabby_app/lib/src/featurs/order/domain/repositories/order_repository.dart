
import 'package:grabby_app/src/featurs/order/data/datasources/order_remote_data_source.dart';

import '../../../../src_export.dart';

abstract class OrderRepository {
  Future<ApiResponse<OrderModel>> createOrder(OrderModel order);
  Future<ApiResponse<List<OrderModel>>> getMyOrders({String? status, int page = 1, int limit = 10});
  Future<ApiResponse<OrderModel>> getOrderDetails(String orderId);
  Future<ApiResponse<List<OrderModel>>> getBranchOrders(String branchId, {String? status, int page = 1, int limit = 10});
  Future<ApiResponse<OrderModel>> updateOrderStatus(String orderId, String status);
  Future<ApiResponse<OrderModel>> cancelOrder(String orderId, {String? cancelNote});
  Future<ApiResponse<OrderModel>> respondToCancel(String orderId, String action);
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<OrderModel>> createOrder(OrderModel order) => remoteDataSource.createOrder(order);

  @override
  Future<ApiResponse<List<OrderModel>>> getMyOrders({String? status, int page = 1, int limit = 10}) =>
      remoteDataSource.getMyOrders(status: status, page: page, limit: limit);

  @override
  Future<ApiResponse<OrderModel>> getOrderDetails(String orderId) => remoteDataSource.getOrderDetails(orderId);

  @override
  Future<ApiResponse<List<OrderModel>>> getBranchOrders(String branchId, {String? status, int page = 1, int limit = 10}) =>
      remoteDataSource.getBranchOrders(branchId, status: status, page: page, limit: limit);

  @override
  Future<ApiResponse<OrderModel>> updateOrderStatus(String orderId, String status) =>
      remoteDataSource.updateOrderStatus(orderId, status);

  @override
  Future<ApiResponse<OrderModel>> cancelOrder(String orderId, {String? cancelNote}) =>
      remoteDataSource.cancelOrder(orderId, cancelNote: cancelNote);

  @override
  Future<ApiResponse<OrderModel>> respondToCancel(String orderId, String action) =>
      remoteDataSource.respondToCancel(orderId, action);
}
