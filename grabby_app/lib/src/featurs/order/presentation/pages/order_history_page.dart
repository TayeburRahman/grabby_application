
import '../../../../src_export.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onOrderCancelled() {
    _tabController.animateTo(3);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderBloc>()..add(FetchMyOrdersEvent()),
      child: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatus.success &&
              state.successMessage == "Order cancelled successfully") {
            // Refresh all orders
            context.read<OrderBloc>().add(FetchMyOrdersEvent());
            // Switch to Cancelled tab
            _onOrderCancelled();
          }
        },
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  title: const CustomText(
                    AppStaticStrings.orders,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  centerTitle: false,
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: AppColors.kPrimaryColor,
                    labelColor: AppColors.kPrimaryColor,
                    unselectedLabelColor: AppColors.kSecondaryTextColor,
                    dividerColor: Colors.transparent,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: -20),
                    tabs: [
                      _buildTab(AppStaticStrings.all),
                      _buildTab(AppStaticStrings.active),
                      _buildTab(AppStaticStrings.completed),
                      _buildTab(AppStaticStrings.cancelled),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                const OrderListWidget(status: "all"),
                const OrderListWidget(status: "active"),
                const OrderListWidget(status: "completed"),
                const OrderListWidget(status: "cancelled"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Text(label),
      ),
    );
  }
}

class OrderListWidget extends StatelessWidget {
  final String status;
  const OrderListWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state.status == OrderStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == OrderStatus.failure) {
          return Center(child: CustomText(state.errorMessage ?? "Error"));
        }

        // Filter orders based on status
        final filteredOrders = state.orders.where((order) {
          final s = order.status?.toLowerCase() ?? "";
          if (status == "all") return true;
          if (status == "active") {
            return ["placed", "preparing", "ready"].contains(s);
          }
          return s == status;
        }).toList();

        if (filteredOrders.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrderBloc>().add(FetchMyOrdersEvent());
            },
            child: Stack(
              children: [
                ListView(),
                const Center(child: CustomText("No orders found")),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<OrderBloc>().add(FetchMyOrdersEvent());
          },
          child: ListView.separated(
            padding: AppPadding.getPadding12(context),
            itemCount: filteredOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return OrderCard(order: order);
            },
          ),
        );
      },
    );
  }
}
