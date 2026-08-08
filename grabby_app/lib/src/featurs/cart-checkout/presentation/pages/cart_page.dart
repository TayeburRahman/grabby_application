import 'dart:developer';

import 'package:grabby_app/src/featurs/reward/data/models/wallet_model.dart';
import 'package:grabby_app/src/featurs/reward/data/repositories/reward_repository_impl.dart';

import '../../../../src_export.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isCarPickup = true;
  String branchId = '';
  String? shopOwnerId;
  CarPlateModel? _selectedCarPlate;

  final TextEditingController _promoController = TextEditingController();
  String? _promoStatusMessage;
  bool? _isPromoSuccess;
  PromoCodeModel? _appliedPromo;
  WalletModel? _wallet;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    String newBranchId = '';
    String? newShopOwnerId;

    if (extra is String) {
      newBranchId = extra;
    } else if (extra is Map<String, dynamic>) {
      newBranchId = extra['branchId'] ?? '';
      newShopOwnerId = extra['shopOwnerId'];
    }

    if (newBranchId != branchId) {
      branchId = newBranchId;
      shopOwnerId = newShopOwnerId;
      if (branchId.isNotEmpty) {
        final cartBloc = context.read<CartBloc>();
        if (cartBloc.state.cart == null ||
            cartBloc.state.cart!.branchId != branchId) {
          cartBloc.add(FetchCartEvent(branchId));
        }
      }
    }
    _fetchWallet();
  }

  Future<void> _fetchWallet() async {
    try {
      final repository = sl<RewardRepository>();
      final response = await repository.getWallet();
      if (response.success && response.data != null) {
        if (mounted) {
          setState(() {
            _wallet = response.data;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching wallet: $e");
    }
  }

  void _incrementQuantity(CartItemModel item) {
    debugPrint('Incrementing quantity for item: ${item.id}');
    if (item.id != null) {
      context.read<CartBloc>().add(
            UpdateCartItemEvent(item.id!, item.quantity + 1, branchId),
          );
    }
  }

  void _decrementQuantity(CartItemModel item) {
    debugPrint('Decrementing quantity for item: ${item.id}');
    if (item.id != null && item.quantity > 1) {
      context.read<CartBloc>().add(
            UpdateCartItemEvent(item.id!, item.quantity - 1, branchId),
          );
    }
  }

  void _deleteItem(CartItemModel item) {
    debugPrint('Deleting item: ${item.menuName}');
    if (item.id != null) {
      context.read<CartBloc>().add(DeleteCartItemEvent(item.id!, branchId));
    }
  }

  Future<void> _onApplyPromoCode(String cartId) async {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;

    // Use the shopOwnerId passed from branch details.
    final currentShopOwnerId = shopOwnerId ?? "";

    debugPrint('Validating promo code: $code for shop: $currentShopOwnerId');
    try {
      final repository = sl<CartRepository>();
      final response = await repository.validatePromoCode(
        code,
        currentShopOwnerId,
        cartId,
      );

      if (response.success && response.data != null && response.data!.isValid) {
        setState(() {
          _promoStatusMessage = "ur promo code successfully applied";
          _isPromoSuccess = true;
          _appliedPromo = response.data;
        });
      } else {
        setState(() {
          _promoController.clear();
          _promoStatusMessage = "promo code is not valid";
          _isPromoSuccess = false;
          _appliedPromo = null;
        });
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        _promoController.clear();
        _promoStatusMessage = "Error validating promo code";
        _isPromoSuccess = false;
        _appliedPromo = null;
      });
    }
  }

  Future<void> _onApplyCredit(String cartId) async {
    try {
      final repository = sl<CartRepository>();
      final response = await repository.applyCredit(cartId);
      log("Apply credit response: ${response.message}");
      if (response.success) {
        // Refresh cart to see updated totalAmount/appliedCredit
        if (mounted) {
          context.read<CartBloc>().add(FetchCartEvent(branchId));
        //  credit = response['data']['details']['appliedCredit'];
        }
      }
    } catch (e) {
      debugPrint("Error applying credit: $e");
    }
  }

  Widget _buildContent(CartState state) {
    if (state.status == CartStatus.loading) {
      if (state.cart == null) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Stack(
          children: [
            _buildCartContent(state.cart!),
            Positioned.fill(
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.1),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      }
    }
    if (state.status == CartStatus.error && state.cart == null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: CustomText(state.errorMessage ?? 'Error loading cart'),
        ),
      );
    }
    final cart = state.cart;
    if (cart == null || cart.items.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CustomText('Your cart is empty')),
      );
    }

    return _buildCartContent(cart);
  }

  Widget _buildCartContent(CartModel cart) {
    double totalAmount = cart.totalAmount;
    if (_appliedPromo != null && _appliedPromo!.isValid) {
      totalAmount = _appliedPromo!.finalPrice;
    }

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cart Items
        ...cart.items.map((item) {
          return Dismissible(
            key: Key(item.id ?? UniqueKey().toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _deleteItem(item),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.delete_rounded, color: Colors.white),
            ),
            child: CartItemWithStepperCard(
              title: item.menuName,
              description: item.additionalItems.map((e) => e.name).join(', '),
              quantity: item.quantity,
              price: item.totalPrice ?? 0,
              imageUrl: item.menuImage,
              onIncrement: () => _incrementQuantity(item),
              onDecrement: () => _decrementQuantity(item),
              onDelete: () => _deleteItem(item),
            ),
          );
        }),

        // Pickup Type Section
        PickupSelectionWidget(
          isCarPickup: _isCarPickup,
          onSelectionChanged: (value) {
            setState(() => _isCarPickup = value);
          },
        ),

        // Car Plate row (only visible when Car Pickup selected)
        if (_isCarPickup)
          CarPlateNumberWidget(
            plateNumber: _selectedCarPlate?.plateCode ?? 'No Car Selected ',
            onTap: () async {
              final result = await context.pushNamed(RoutesPath.carPlatesPath);
              if (result != null && result is CarPlateModel) {
                setState(() {
                  _selectedCarPlate = result;
                });
              }
            },
          ),

        // Grabby Credit (Rewards)
        GrabbyCreditWidget(
          availableAmount: _wallet?.credWallet ?? 0.0,
          availablePoints: _wallet?.pointWallet.toInt() ?? 0,
          onApplyCredit: () => _onApplyCredit(cart.id ?? ''),
        ),

        // Promo Code
        PromoCodeWidget(
          controller: _promoController,
          statusMessage: _promoStatusMessage,
          isSuccess: _isPromoSuccess,
          onApply: () => _onApplyPromoCode(cart.id ?? ''),
        ),

        // Order Summary
        CartOrderSummaryWidget(
          subtotal: cart.totalAmount, // Showing original subtotal
          discount: _appliedPromo?.discountAmount ?? 0,
          total: totalAmount, // Showing potentially discounted total
          credit: cart.appliedCredit,
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStaticStrings.cart),
        backgroundColor: AppColors.kBackgroundColor,
        elevation: 0,
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatus.success && state.selectedOrder != null) {
            final referenceToken = state.selectedOrder!.referenceToken;
            if (referenceToken != null && referenceToken.isNotEmpty) {
              context.pushNamed(
                RoutesPath.stripePaymentWebviewPath,
                extra: {
                  'order': state.selectedOrder,
                  'paymentUrl': referenceToken,
                },
              );
            } else {
              context.pushNamed(
                RoutesPath.checkoutPath,
                extra: state.selectedOrder,
              );
            }
          } else if (state.status == OrderStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Failed to place order")),
            );
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                if (branchId.isNotEmpty) {
                  context.read<CartBloc>().add(FetchCartEvent(branchId));
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppPadding.getPadding12(context).copyWith(top: 0),
                child: _buildContent(state),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            return CustomButton(
              
              text: AppStaticStrings.proceedToCheckout,
              isLoading: orderState.status == OrderStatus.loading,
              onPressed: () {
                final cartState = context.read<CartBloc>().state;
                if (cartState.cart != null) {
                  final cart = cartState.cart!;
                  final order = OrderModel(
                    branchId: cart.branchId,
                    items: cart.items
                        .map((item) => OrderItemModel(
                              productId: item.productId,
                              menuName: item.menuName,
                              menuPrice: item.menuPrice,
                              menuImage: item.menuImage,
                              quantity: item.quantity,
                              additionalItems: item.additionalItems
                                  .map((e) => OrderAdditionalItemModel(
                                        itemId: e.itemId,
                                        name: e.name,
                                        price: e.price,
                                        quantity: e.quantity,
                                      ))
                                  .toList(),
                              totalPrice: item.totalPrice,
                            ))
                        .toList(),
                    pickupType: _isCarPickup ? "carPickup" : "walkIn",
                    applyGrabbyCredit: 0.0,
                    applyPromoCode: 0.0,
                    totalAmount: _appliedPromo != null && _appliedPromo!.isValid
                        ? _appliedPromo!.finalPrice
                        : cart.totalAmount,
                    paymentMethod: "stripe",
                    carPlates:
                        _isCarPickup ? (_selectedCarPlate?.plateCode ?? "") : null,
                  );
                  context.read<OrderBloc>().add(CreateOrderEvent(order));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
