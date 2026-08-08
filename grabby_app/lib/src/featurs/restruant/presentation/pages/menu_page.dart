import '../../../../src_export.dart';

class MenuPage extends StatefulWidget {
  final String branchId;
  const MenuPage({super.key, required this.branchId});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _selectedCategory = AppStaticStrings.allItems;

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

  void _fetchMenu() {
    context.read<CustomerBranchBloc>().add(
      GetCustomerBranchDetailEvent(widget.branchId),
    );
    context.read<CartBloc>().add(FetchCartEvent(widget.branchId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStaticStrings.menu),
        actions: [
          BlocBuilder<CustomerBranchBloc, CustomerBranchState>(
            builder: (context, state) {
              if (state is CustomerBranchDetailLoaded) {
                return ButtonTapWidget(
                  onTap: () {
                    final shopOwnerId = state
                        .branch
                        .menuCategories
                        ?.firstOrNull
                        ?.menus
                        .firstOrNull
                        ?.shopOwnerId;
                    context.pushNamed(
                      RoutesPath.cartPath,
                      extra: {
                        'branchId': state.branch.id,
                        'shopOwnerId': shopOwnerId,
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(
                      ImagesConstant.kCartIcon,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState.cart != null && cartState.cart!.totalItems > 0) {
            return BlocBuilder<CustomerBranchBloc, CustomerBranchState>(
              builder: (context, branchState) {
                if (branchState is CustomerBranchDetailLoaded) {
                  final shopOwnerId = branchState
                      .branch
                      .menuCategories
                      ?.firstOrNull
                      ?.menus
                      .firstOrNull
                      ?.shopOwnerId;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ButtonTapWidget(
                      onTap: () {
                        context.pushNamed(
                          RoutesPath.cartPath,
                          extra: {
                            'branchId': branchState.branch.id,
                            'shopOwnerId': shopOwnerId,
                          },
                        );
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.kPrimaryColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CustomText(
                                "${cartState.cart!.items?.length}",
                                color: AppColors.kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: CustomText(
                                "View Cart",
                                color: Colors.white,
                                variant: TextVariant.titleMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomText(
                              "AED ${cartState.cart!.totalAmount.toStringAsFixed(2)}",
                              color: Colors.white,
                              variant: TextVariant.titleMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: BlocBuilder<CustomerBranchBloc, CustomerBranchState>(
        builder: (context, state) {
          if (state is CustomerBranchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerBranchError) {
            return Center(child: CustomText(state.message));
          } else if (state is CustomerBranchDetailLoaded) {
            final branch = state.branch;
            final menuCategories = branch.menuCategories ?? [];

            return RefreshIndicator(
              onRefresh: () async => _fetchMenu(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppPadding.getPadding12(context).copyWith(top: 0),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8,
                        children: [
                          _buildCategoryChip(
                            AppStaticStrings.allItems,
                            _selectedCategory == AppStaticStrings.allItems,
                            onTap: () {
                              setState(() {
                                _selectedCategory = AppStaticStrings.allItems;
                              });
                            },
                          ),
                          ...menuCategories.map((cat) {
                            return _buildCategoryChip(
                              cat.name,
                              _selectedCategory == cat.name,
                              stampActive: cat.stampActive,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = cat.name;
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    ),

                    // Menu Sections
                    ...menuCategories
                        .where(
                          (cat) =>
                              _selectedCategory == AppStaticStrings.allItems ||
                              _selectedCategory == cat.name,
                        )
                        .map(
                          (cat) => _buildMenuSection(
                            cat.name,
                            cat.menus
                                .map(
                                  (item) => MenuItemWidget(
                                    title: item.itemName,
                                    price:
                                        "AED ${item.price.toStringAsFixed(1)}",
                                    hasDiscount: item.discount ?? false,
                                    discount: "${item.discountParcent}% OFF",
                                    originalPrice: item.originalPrice != null
                                        ? "AED ${item.originalPrice!.toStringAsFixed(1)}"
                                        : null,
                                    image:
                                        item.image != null &&
                                            item.image!.isNotEmpty
                                        ? "${ApiEndpoints.baseUrl}${item.image}"
                                        : "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2070&auto=format&fit=crop",
                                    onAdd: () {
                                      context.pushNamed(
                                        RoutesPath.itemDetailsPath,
                                        extra: {
                                          'item': item,
                                          'branchId': branch.id,
                                        },
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected, {
    bool stampActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          spacing: 6,
          children: [
            if (stampActive)
              Image.asset("assets/icons/stamp_category_icon.png", height: 15),
            CustomText(
              label,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? AppColors.kWhiteTextColor
                  : AppColors.kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(title, fontSize: 18, fontWeight: FontWeight.bold),
        ...items,
        const Divider(height: 2),
      ],
    );
  }
}
