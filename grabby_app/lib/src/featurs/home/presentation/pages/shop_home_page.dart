import 'package:grabby_app/src/featurs/home/presentation/bloc/shop_dashboard_bloc.dart';
import '../../../../src_export.dart';
import '../../../profile-settings/presentation/bloc/branch/branch_bloc.dart';
import 'package:intl/intl.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  String? firstBranchId;

  @override
  void initState() {
    super.initState();
    // BranchBloc GetBranchesEvent is dispatched in ShopNavigationPage
  }

  void _fetchData() {
    context.read<ShopDashboardBloc>().add(GetShopDashboardStatsEvent());
    if (firstBranchId != null) {
      context.read<OrderBloc>().add(FetchBranchOrdersEvent(branchId: firstBranchId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchBloc, BranchState>(
      listener: (context, state) {
        if (state is BranchesLoaded && state.branches.isNotEmpty && firstBranchId == null) {
          setState(() {
            firstBranchId = state.branches.first.id;
          });
          context.read<OrderBloc>().add(FetchBranchOrdersEvent(branchId: firstBranchId!));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _fetchData();
            },
            child: SingleChildScrollView(
              padding: AppPadding.getPadding12(context),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShopHomeHeader(),
                  _buildStatsGrid(context),
                  const ShopRecentOrdersHeader(),
                  _buildOrdersList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return BlocBuilder<ShopDashboardBloc, ShopDashboardState>(
      builder: (context, state) {
        if (state.status == ShopDashboardStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        final stats = state.stats;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            ShopStatCard(
              title: AppStaticStrings.todaysOrders,
              value: "${stats?.totalOrders ?? 0}",
              iconContent: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.kPrimaryColor,
              ),
              iconColor: AppColors.kPrimaryColor,
              bgColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
            ),
            ShopStatCard(
              title: AppStaticStrings.revenue,
              value: "AED ${stats?.totalRevenue.toStringAsFixed(2) ?? "0.00"}",
              iconContent: const Icon(
                Icons.attach_money,
                color: AppColors.kGreenColor,
              ),
              iconColor: AppColors.kGreenColor,
              bgColor: AppColors.kGreenColor.withValues(alpha: 0.1),
            ),
            ShopStatCard(
              title: AppStaticStrings.activeItems,
              value: "${stats?.activeItems ?? 0}",
              iconPath: ImagesConstant.kMenuIcon,
              iconColor: Colors.orange,
              bgColor: Colors.orange.withValues(alpha: 0.1),
            ),
            ShopStatCard(
              title: AppStaticStrings.customers,
              value: "${stats?.totalUniqueCustomers ?? 0}",
              iconPath: ImagesConstant.kGroupIcon,
              iconColor: AppColors.kBlueColor,
              bgColor: AppColors.kBlueColor.withValues(alpha: 0.1),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state.status == OrderStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.orders.isEmpty) {
          return const Center(child: CustomText("No recent orders"));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.orders.length > 5 ? 5 : state.orders.length, // Show recent 5
          itemBuilder: (context, index) {
            final order = state.orders[index];
            final customer = order.customerId is CustomerInfo
                ? (order.customerId as CustomerInfo)
                : null;
            final time = order.createdAt != null
                ? DateFormat('h:mm a').format(DateTime.parse(order.createdAt!))
                : "";

            return ShopOrderItemWidget(
              id: order.orderId ?? order.id ?? "",
              name: customer?.name ?? "Customer",
              items: "${order.items.length} items",
              status: order.status ?? "",
              price: "AED ${order.totalAmount.toStringAsFixed(2)}",
              time: time,
              statusColor: _getStatusColor(order.status ?? ""),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "placed":
        return Colors.orange;
      case "preparing":
        return AppColors.kBlueColor;
      case "ready":
        return AppColors.kGreenColor;
      case "completed":
        return AppColors.kSecondaryTextColor;
      default:
        return AppColors.kPrimaryColor;
    }
  }
}
