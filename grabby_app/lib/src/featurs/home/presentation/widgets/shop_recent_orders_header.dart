import '../../../../src_export.dart';

class ShopRecentOrdersHeader extends StatefulWidget {
  const ShopRecentOrdersHeader({super.key});

  @override
  State<ShopRecentOrdersHeader> createState() => _ShopRecentOrdersHeaderState();
}

class _ShopRecentOrdersHeaderState extends State<ShopRecentOrdersHeader> {
  String selectedBranch = AppStaticStrings.branch;
  String? selectedBranchId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          AppStaticStrings.recentOrders,
          variant: TextVariant.titleLarge,
          fontWeight: FontWeight.bold,
        ),
        BranchDropdown(
          onBranchSelected: (id, name) {
            if (selectedBranchId != null) {
              context.read<OrderBloc>().add(
                FetchBranchOrdersEvent(
                  branchId: selectedBranchId!,
                  // status: tabs[selectedTabIndex],
                ),
              );
            }
            setState(() {
              selectedBranch = name;
              selectedBranchId = id;
            });
            // You can also add logic here to fetch recent orders for the specific branch
          },
        ),
      ],
    );
  }
}
