import '../../../../src_export.dart';
import '../models/cart_model.dart';
import '../models/promo_code_model.dart';

abstract class CartRemoteDataSource {
  Future<ApiResponse<CartModel>> addToCart(AddToCartRequest request);
  Future<ApiResponse<List<CartModel>>> getCartSummary(String branchId);
  Future<ApiResponse<CartModel>> updateCartItem(String cartItemId, int quantity);
  Future<ApiResponse<void>> deleteCartItem(String cartItemId);
  Future<ApiResponse<PromoCodeModel>> validatePromoCode(String code, String shopOwnerId, String cartId);
  Future<ApiResponse<void>> applyCredit(String cartId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService apiService;

  CartRemoteDataSourceImpl(this.apiService);

  @override
  Future<ApiResponse<CartModel>> addToCart(AddToCartRequest request) async {
    return await apiService.post<CartModel>(
      ApiEndpoints.addToCart,
      data: request.toJson(),
      fromJson: (json) => CartModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<CartModel>>> getCartSummary(String branchId) async {
    return await apiService.get<List<CartModel>>(
      ApiEndpoints.cartSummary,
      queryParameters: {"branchId": branchId},
      fromJson: (json) => (json['data'] as List)
          .map((e) => CartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<CartModel>> updateCartItem(String cartItemId, int quantity) async {
    return await apiService.patch<CartModel>(
      ApiEndpoints.cartItem(cartItemId),
      data: {"quantity": quantity},
      fromJson: (json) => CartModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> deleteCartItem(String cartItemId) async {
    return await apiService.delete<void>(
      ApiEndpoints.cartItem(cartItemId),
    );
  }

  @override
  Future<ApiResponse<PromoCodeModel>> validatePromoCode(String code, String shopOwnerId, String cartId) async {
    return await apiService.post<PromoCodeModel>(
      ApiEndpoints.validatePromoCode,
      data: {
        "code": code,
        "shopOwnerId": shopOwnerId,
        "cartId": cartId,
      },
      fromJson: (json) => PromoCodeModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> applyCredit(String cartId) async {
    return await apiService.post<void>(
      ApiEndpoints.applyCredit,
      data: {"cartId": cartId},
    );
  }
}
