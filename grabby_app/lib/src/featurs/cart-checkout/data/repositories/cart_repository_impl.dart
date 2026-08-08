import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_model.dart';
import '../models/promo_code_model.dart';
import '../../../../core/services/api_response.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<CartModel>> addToCart(AddToCartRequest request) {
    return remoteDataSource.addToCart(request);
  }

  @override
  Future<ApiResponse<List<CartModel>>> getCartSummary(String branchId) {
    return remoteDataSource.getCartSummary(branchId);
  }

  @override
  Future<ApiResponse<CartModel>> updateCartItem(String cartItemId, int quantity) {
    return remoteDataSource.updateCartItem(cartItemId, quantity);
  }

  @override
  Future<ApiResponse<void>> deleteCartItem(String cartItemId) {
    return remoteDataSource.deleteCartItem(cartItemId);
  }

  @override
  Future<ApiResponse<PromoCodeModel>> validatePromoCode(String code, String shopOwnerId, String cartId) {
    return remoteDataSource.validatePromoCode(code, shopOwnerId, cartId);
  }

  @override
  Future<ApiResponse<void>> applyCredit(String cartId) {
    return remoteDataSource.applyCredit(cartId);
  }
}
