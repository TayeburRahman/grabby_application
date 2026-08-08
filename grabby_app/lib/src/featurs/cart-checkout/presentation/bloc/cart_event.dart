part of 'cart_bloc.dart';

abstract class CartEvent {}

class FetchCartEvent extends CartEvent {
  final String branchId;
  FetchCartEvent(this.branchId);
}

class AddToCartEvent extends CartEvent {
  final AddToCartRequest request;
  AddToCartEvent(this.request);
}

class UpdateCartItemEvent extends CartEvent {
  final String cartItemId;
  final int quantity;
  final String branchId;
  UpdateCartItemEvent(this.cartItemId, this.quantity, this.branchId);
}

class DeleteCartItemEvent extends CartEvent {
  final String cartItemId;
  final String branchId;
  DeleteCartItemEvent(this.cartItemId, this.branchId);
}
