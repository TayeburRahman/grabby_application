import '../../../../src_export.dart';


part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(CartState()) {
    on<FetchCartEvent>(_onFetchCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemEvent>(_onUpdateCartItem);
    on<DeleteCartItemEvent>(_onDeleteCartItem);
  }

  Future<void> _onFetchCart(
    FetchCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final response = await _cartRepository.getCartSummary(event.branchId);
      if (response.success && response.data != null) {
        // Summary returns a list, we take the one matching branchId or the first one
        final cart = response.data!.firstWhere(
          (c) => c.branchId == event.branchId,
          orElse: () => response.data!.isNotEmpty 
              ? response.data!.first 
              : CartModel(branchId: event.branchId, items: [], totalItems: 0, totalAmount: 0),
        );
        emit(state.copyWith(status: CartStatus.success, cart: cart));
      } else {
        emit(state.copyWith(status: CartStatus.error, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: 'Failed to fetch cart.'));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final response = await _cartRepository.addToCart(event.request);
      if (response.success && response.data != null) {
        emit(state.copyWith(
          status: CartStatus.success,
          cart: response.data,
          successMessage: response.message,
        ));
      } else {
        emit(state.copyWith(status: CartStatus.error, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: 'Failed to add item to cart.'));
    }
  }

  Future<void> _onUpdateCartItem(
    UpdateCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final response = await _cartRepository.updateCartItem(event.cartItemId, event.quantity);
      if (response.success) {
        // Refresh cart after update
        add(FetchCartEvent(event.branchId));
      } else {
        emit(state.copyWith(status: CartStatus.error, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: 'Failed to update cart item.'));
    }
  }

  Future<void> _onDeleteCartItem(
    DeleteCartItemEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final response = await _cartRepository.deleteCartItem(event.cartItemId);
      if (response.success) {
        // Refresh cart after deletion
        add(FetchCartEvent(event.branchId));
      } else {
        emit(state.copyWith(status: CartStatus.error, errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: 'Failed to delete cart item.'));
    }
  }
}
