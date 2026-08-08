
import '../../../../src_export.dart';

abstract class OrderRemoteDataSource {
  Future<ApiResponse<OrderModel>> createOrder(OrderModel order);
  Future<ApiResponse<List<OrderModel>>> getMyOrders({String? status, int page = 1, int limit = 10});
  Future<ApiResponse<OrderModel>> getOrderDetails(String orderId);
  Future<ApiResponse<List<OrderModel>>> getBranchOrders(String branchId, {String? status, int page = 1, int limit = 10});
  Future<ApiResponse<OrderModel>> updateOrderStatus(String orderId, String status);
  Future<ApiResponse<OrderModel>> cancelOrder(String orderId, {String? cancelNote});
  Future<ApiResponse<OrderModel>> respondToCancel(String orderId, String action);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiService apiService;

  OrderRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<OrderModel>> createOrder(OrderModel order) async {
    return await apiService.post<OrderModel>(
      ApiEndpoints.orders,
      data: order.toJson(),
      fromJson: (json) => OrderModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<OrderModel>>> getMyOrders({String? status, int page = 1, int limit = 10}) async {
    final Map<String, dynamic> queryParams = {
      "page": page,
      "limit": limit,
    };
    if (status != null && status.isNotEmpty) {
      queryParams["status"] = status;
    }

    return await apiService.get<List<OrderModel>>(
      ApiEndpoints.myOrders,
      queryParameters: queryParams,
      fromJson: (json) => (json['data'] as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<OrderModel>> getOrderDetails(String orderId) async {
    return await apiService.get<OrderModel>(
      ApiEndpoints.orderDetail(orderId),
      fromJson: (json) => OrderModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<OrderModel>>> getBranchOrders(String branchId, {String? status, int page = 1, int limit = 10}) async {
    final Map<String, dynamic> queryParams = {
      "page": page,
      "limit": limit,
    };
    if (status != null && status.isNotEmpty) {
      queryParams["status"] = status;
    }

    return await apiService.get<List<OrderModel>>(
      ApiEndpoints.branchOrders(branchId),
      queryParameters: queryParams,
      fromJson: (json) => (json['data'] as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<OrderModel>> updateOrderStatus(String orderId, String status) async {
    return await apiService.patch<OrderModel>(
      ApiEndpoints.updateOrderStatus(orderId),
      data: {"status": status},
      fromJson: (json) => OrderModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<OrderModel>> cancelOrder(String orderId, {String? cancelNote}) async {
    return await apiService.patch<OrderModel>(
      ApiEndpoints.cancelOrder(orderId),
      data: cancelNote != null ? {"cancelNote": cancelNote} : null,
      fromJson: (json) => OrderModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<OrderModel>> respondToCancel(String orderId, String action) async {
    return await apiService.patch<OrderModel>(
      ApiEndpoints.cancelRespond(orderId),
      data: {"action": action},
      fromJson: (json) => OrderModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
