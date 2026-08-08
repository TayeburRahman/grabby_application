
class ShopDashboardModel {
  final int totalOrders;
  final int activeItems;
  final int totalUniqueCustomers;
  final double totalRevenue;

  ShopDashboardModel({
    required this.totalOrders,
    required this.activeItems,
    required this.totalUniqueCustomers,
    required this.totalRevenue,
  });

  factory ShopDashboardModel.fromJson(Map<String, dynamic> json) {
    return ShopDashboardModel(
      totalOrders: json['totalOrders'] ?? 0,
      activeItems: json['activeItems'] ?? 0,
      totalUniqueCustomers: json['totalUniqueCustomers'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
    );
  }
}
