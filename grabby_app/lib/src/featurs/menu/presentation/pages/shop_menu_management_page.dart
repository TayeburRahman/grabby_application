import 'dart:async';

import '../../../../src_export.dart';

class ShopMenuManagementPage extends StatefulWidget {
  const ShopMenuManagementPage({super.key});

  @override
  State<ShopMenuManagementPage> createState() => _ShopMenuManagementPageState();
}

class _ShopMenuManagementPageState extends State<ShopMenuManagementPage> {
  MenuCategoryModel? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Removed _fetchInitialData() from here because BlocProvider hasn't been created yet.
    // The initial fetch is now handled in the BlocProvider's create block.
  }

  void _fetchInitialData(BuildContext context) {
    context.read<MenuBloc>().add(GetMenuCategoriesEvent());
    context.read<MenuBloc>().add(GetMenuItemsEvent());
  }

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MenuBloc>().add(
        GetMenuItemsEvent(searchTerm: query, categoryId: _selectedCategory?.id),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<MenuBloc>().add(GetMenuCategoriesEvent());
    context.read<MenuBloc>().add(
      GetMenuItemsEvent(
        categoryId: _selectedCategory?.id,
        searchTerm: _searchController.text,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: CustomText(
          AppStaticStrings.deleteMenuItem,
          variant: TextVariant.titleMedium,
        ),
        content: const CustomText(
          "Are you sure you want to delete this menu item?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const CustomText(AppStaticStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<MenuBloc>().add(DeleteMenuItemEvent(itemId));
            },
            child: const CustomText(AppStaticStrings.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MenuBloc>()
        ..add(GetMenuCategoriesEvent())
        ..add(GetMenuItemsEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const CustomText(
                AppStaticStrings.menuManagement,
                variant: TextVariant.titleLarge,
              ),
              centerTitle: false,
              actions: [
                GestureDetector(
                  onTap: () async {
                    final result = await context.pushNamed(
                      RoutesPath.editItemName,
                    );
                    if (result == true) {
                      if (context.mounted) {
                        _fetchInitialData(context);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(appRadius),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 15),
                        CustomText(
                          AppStaticStrings.addItem,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: BlocConsumer<MenuBloc, MenuState>(
              listener: (context, state) {
                if (state.status == MenuStatus.error &&
                    state.errorMessage != null &&
                    state.items.isNotEmpty) {
                  CustomSnackbar.show(
                    context,
                    state.errorMessage!,
                    isError: true,
                  );
                } else if (state.status == MenuStatus.success &&
                    state.successMessage != null) {
                  CustomSnackbar.show(context, state.successMessage!);
                }
              },
              builder: (context, state) {
                final categories = state.categories;
                final items = state.items;
                final meta = state.meta;
                final isLoading = state.status == MenuStatus.loading;

                return RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
                  color: AppColors.kPrimaryColor,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar
                        CustomTextField(
                          textEditingController: _searchController,
                          hintText: AppStaticStrings.searchMenuItems,
                          onChanged: (val) => _onSearchChanged(context, val),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.kSecondaryTextColor,
                          ),
                          fillColor: Colors.white,
                          borderRadius: 16,
                        ),

                        // Category Chips
                        _buildCategoryChips(context, categories),

                        // Summary Stats
                        _buildSummaryStats(items, meta),

                        // Items List
                        if (isLoading && items.isEmpty)
                          const Center(child: CircularProgressIndicator())
                        else if (items.isEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Center(
                              child: CustomText("No items found"),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return MenuManagementItemCard(
                                title: item.itemName,
                                description: item.description,
                                isDiscount: item.discount ?? false,
                                originalPrice: item.originalPrice,
                                // discountParcent: item.discountParcent,
                                eventName: item.eventOffer?.eventName,
                                price: "AED ${item.price}",
                                image: item.image ?? "",
                                category: item.categoryName,
                                isAvailable: item.isAvailable,
                                onEdit: () async {
                                  final result = await context.pushNamed(
                                    RoutesPath.editItemName,
                                    extra: item,
                                  );
                                  if (result == true) {
                                    if (context.mounted) {
                                      _fetchInitialData(context);
                                    }
                                  }
                                },
                                onDelete: () =>
                                    _showDeleteConfirmation(context, item.id!),
                                onToggleVisibility: () {
                                  // Implement visibility toggle if needed
                                },
                              );
                            },
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChips(
    BuildContext context,
    List<MenuCategoryModel> categories,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 12,
        children: [
          _buildCategoryChip(context, null, AppStaticStrings.allItems),
          ...categories.map(
            (category) => _buildCategoryChip(context, category, category.name),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    MenuCategoryModel? category,
    String label,
  ) {
    final isSelected = _selectedCategory?.id == category?.id;
    return ButtonTapWidget(
      onTap: () {
        setState(() => _selectedCategory = category);
        context.read<MenuBloc>().add(
          GetMenuItemsEvent(
            categoryId: category?.id,
            searchTerm: _searchController.text,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          spacing: 8,
          children: [
            if (category?.isStampActive ?? false)
              Image.asset("assets/icons/stamp_category_icon.png", height: 15),
            CustomText(
              label,
              color: isSelected ? Colors.white : AppColors.kSecondaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats(List<MenuItemModel> items, PaginationMeta? meta) {
    final total = meta?.total ?? items.length;
    final available = items.where((i) => i.isAvailable).length;
    final outOfStock = total - available; // Simplified calculation

    return Row(
      spacing: 12,
      children: [
        _buildStatText(AppStaticStrings.totalItems, total.toString()),
        _buildStatText(
          AppStaticStrings.available,
          available.toString(),
          valueColor: AppColors.kPrimaryColor,
        ),
        _buildStatText(
          AppStaticStrings.outOfStock,
          outOfStock.toString(),
          valueColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatText(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          label,
          fontSize: 14,
          color: AppColors.kSecondaryTextColor,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(width: 4),
        CustomText(
          value,
          fontSize: 14,
          color: valueColor ?? AppColors.kSecondaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
