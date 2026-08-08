import '../../../../src_export.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({super.key});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  int _quantity = 1;
  final Map<String, List<CustomerCustomizationItem>> _selectedAdditionalItems =
      {};
  final TextEditingController _notesController = TextEditingController();

  late CustomerMenuItem item;
  late String branchId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    item = extra['item'] as CustomerMenuItem;
    branchId = extra['branchId'] as String;

    // Initialize default selections if needed (optional)
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state.status == CartStatus.success &&
            state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
          Navigator.pop(context);
          // context.pushNamed(
          //   RoutesPath.cartPath,
          //   extra: {'branchId': branchId, 'shopOwnerId': item.shopOwnerId},
          // );
        } else if (state.status == CartStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Collapsible Header Image
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              automaticallyImplyLeading: false,
              leadingWidth: 70,
              leading: Center(
                child: ButtonTapWidget(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFADA4F8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: CustomNetworkImage(
                  imageUrl: item.image != null && item.image!.isNotEmpty
                      ? "${ApiEndpoints.baseUrl}${item.image}"
                      : "https://images.unsplash.com/photo-1541167760496-162955ed8a9f?q=80&w=2033&auto=format&fit=crop",
                  height: 300,
                  width: double.infinity,
                  radius: 0,
                ),
              ),
            ),
            // if (item.stampActive == true && item.stamp != null && item.stamp! > 0)
            if (item.stampActive == true)
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverToBoxAdapter(
                  child: LoyaltyStampsWidget(
                    currentStamps: item.totalStamps ?? 0,
                    totalStamps: item.stamp ?? 10,
                    remainingStamps: item.remainingStamps ?? 0,
                    isFree: item.isFree,
                  ),
                ),
              ),
            // Content
            SliverPadding(
              padding: AppPadding.getPadding12(context),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    CustomText(
                      item.itemName,
                      variant: TextVariant.headlineMedium,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      "AED ${item.price.toStringAsFixed(2)}",
                      variant: TextVariant.labelLarge,
                      color: AppColors.kPrimaryColor,
                    ),
                    if (item.additionalItems != null &&
                        item.additionalItems!.isNotEmpty) ...[
                      ...List.generate(item.additionalItems?.length ?? 0, (
                        index,
                      ) {
                        final e = item.additionalItems![index];
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: AppPadding.getPadding12(context),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(appRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionTitle(title: e.groupName),
                              const SizedBox(height: 8),
                              _buildCustomizationList(context, e),
                            ],
                          ),
                        );
                      }),
                    ],
                    // Notes Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        const SectionTitle(title: AppStaticStrings.notes),
                        CustomTextField(
                          hintText: "Add notes...",
                          maxLines: 4,
                          textEditingController: _notesController,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: AppPadding.getPadding12H(context),
            child: Row(
              spacing: 16,
              children: [
                // Quantity Selector
                QuantitySelector(
                  quantity: _quantity,
                  onIncrement: () => setState(() => _quantity++),
                  onDecrement: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),

                Expanded(
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      double totalPrice = item.price;
                      for (var group in _selectedAdditionalItems.values) {
                        for (var addon in group) {
                          totalPrice += addon.price;
                        }
                      }

                      return CustomButton(
                        isLoading: state.status == CartStatus.loading,
                        text:
                            "Add $_quantity to bag. AED${(totalPrice * _quantity).toStringAsFixed(2)}",
                        onPressed: () {
                          final List<CartAdditionalItemModel> additionalItems =
                              [];
                          for (var group in _selectedAdditionalItems.values) {
                            for (var addon in group) {
                              additionalItems.add(
                                CartAdditionalItemModel(
                                  itemId: addon.id,
                                  name: addon.name,
                                  price: addon.price,
                                  image: addon.image ?? "",
                                  quantity: 1,
                                ),
                              );
                            }
                          }

                          context.read<CartBloc>().add(
                            AddToCartEvent(
                              AddToCartRequest(
                                branchId: branchId,
                                productId: item.id,
                                menuName: item.itemName,
                                menuPrice: item.price,
                                menuImage: item.image ?? '',
                                quantity: _quantity,
                                additionalItems: additionalItems,
                              ),
                            ),
                          );
                        },
                        backgroundColor: AppColors.kPrimaryColor,
                        borderRadius: 16,
                      );
                    },
                  ),
                ), // Add to Bag Button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationList(
    BuildContext context,
    CustomerCustomizationGroup e,
  ) {
    final addons = e.items;

    return Column(
      children: addons.map((addon) {
        final groupSelections = _selectedAdditionalItems[e.id] ?? [];
        final isSelected = groupSelections.any(
          (element) => element.id == addon.id,
        );

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                groupSelections.removeWhere(
                  (element) => element.id == addon.id,
                );
              } else {
                groupSelections.add(addon);
              }
              _selectedAdditionalItems[e.id] = groupSelections;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected ? AppColors.kPrimaryColor : Colors.grey,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.kPrimaryColor : Colors.white,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          addon.name,
                          variant: TextVariant.labelLarge,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (addon.price > 0)
                        CustomText(
                          "+ AED ${addon.price.toStringAsFixed(2)}",
                          variant: TextVariant.labelSmall,
                          color: Colors.grey[600],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Widget _buildMilkSelectionList(BuildContext context) {
  //   // Get milk options from item's additionalItems
  //   final milkGroup = item.additionalItems?.firstWhere(
  //     (group) => group.groupName.toLowerCase().contains('milk'),
  //     orElse: () => CustomerCustomizationGroup(
  //       id: '',
  //       groupName: 'Milk Options',
  //       type: 'regular',
  //       items: [],
  //     ),
  //   );

  //   final milks = milkGroup?.items ?? [];

  //   return Column(
  //     children: milks.map((milk) {
  //       final isSelected = _selectedMilkItem?.id == milk.id;
  //       return InkWell(
  //         onTap: () => setState(() => _selectedMilkItem = milk),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 8.0),
  //           child: Row(
  //             children: [
  //               // Radio Button Icon
  //               Container(
  //                 height: 20,
  //                 width: 20,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   border: Border.all(
  //                     color: isSelected ? AppColors.kPrimaryColor : Colors.grey,
  //                     width: 1.5,
  //                   ),
  //                 ),
  //                 child: isSelected
  //                     ? Center(
  //                         child: Container(
  //                           height: 10,
  //                           width: 10,
  //                           decoration: const BoxDecoration(
  //                             color: AppColors.kPrimaryColor,
  //                             shape: BoxShape.circle,
  //                           ),
  //                         ),
  //                       )
  //                     : null,
  //               ),
  //               const SizedBox(width: 12),
  //               // Milk name
  //               Expanded(
  //                 child: CustomText(
  //                   milk.name,
  //                   fontSize: 14,
  //                   fontWeight: isSelected
  //                       ? FontWeight.bold
  //                       : FontWeight.normal,
  //                 ),
  //               ),
  //               // Price if any
  //               if (milk.price > 0)
  //                 CustomText(
  //                   '+AED ${milk.price.toStringAsFixed(2)}',
  //                   fontSize: 12,
  //                   color: AppColors.kSecondaryTextColor,
  //                 ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
}
