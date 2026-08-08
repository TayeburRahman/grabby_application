part of 'cart_bloc.dart';

enum CartStatus { initial, loading, success, error }

class CartState {
  final CartStatus status;
  final CartModel? cart;
  final String? errorMessage;
  final String? successMessage;

  CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.successMessage,
  });

  CartState copyWith({
    CartStatus? status,
    CartModel? cart,
    String? errorMessage,
    String? successMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
