import { Order } from '../order/order.model';
import { Menu } from '../menu/menu.model';
import { Branch } from '../shop_owner/shop_owner.model';
import Customer from '../customers/customers.model';
import dayjs from 'dayjs';

const getShopOwnerDashboardStats = async (shopOwnerId: string) => {
  // 1. Get all branches for the shop owner
  const branches = await Branch.find({ shopOwnerId });
  const branchIds = branches.map(b => b._id);

  // 2. Total Orders
  const totalOrders = await Order.countDocuments({ branchId: { $in: branchIds } });

  // 3. Active Items
  const activeItems = await Menu.countDocuments({ 
    shopOwnerId, 
    isAvailable: true 
  });

  // 4. Total Unique Customers
  const uniqueCustomers = await Order.distinct('customerId', { 
    branchId: { $in: branchIds } 
  });
  const totalUniqueCustomers = uniqueCustomers.length;

  // 5. Total Revenue (excluding cancelled orders)
  const revenueResult = await Order.aggregate([
    {
      $match: {
        branchId: { $in: branchIds },
        status: { $ne: 'cancelled' }
      }
    },
    {
      $group: {
        _id: null,
        totalRevenue: { $sum: '$totalAmount' }
      }
    }
  ]);
  const totalRevenue = revenueResult.length > 0 ? revenueResult[0].totalRevenue : 0;

  return {
    totalOrders,
    activeItems,
    totalUniqueCustomers,
    totalRevenue
  };
};

const getAdminDashboardStats = async () => {
  // 1. Overall Stats
  const totalOrders = await Order.countDocuments();
  const totalCustomers = await Customer.countDocuments();
  const totalShops = await Branch.countDocuments();

  const revenueResult = await Order.aggregate([
    {
      $match: { status: { $ne: 'cancelled' } }
    },
    {
      $group: {
        _id: null,
        totalRevenue: { $sum: '$totalAmount' }
      }
    }
  ]);
  const totalRevenue = revenueResult.length > 0 ? revenueResult[0].totalRevenue : 0;
  const avgOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;

  // 2. Weekly Revenue Data (Last 7 days)
  const last7Days: { date: string; dayName: string; revenue: number; orders: number }[] = [];
  for (let i = 6; i >= 0; i--) {
    const date = dayjs().subtract(i, 'days').startOf('day');
    last7Days.push({
      date: date.format('YYYY-MM-DD'),
      dayName: date.format('ddd'),
      revenue: 0,
      orders: 0
    });
  }

  const startDate = dayjs().subtract(6, 'days').startOf('day').toDate();
  const dailyStats = await Order.aggregate([
    {
      $match: {
        status: { $ne: 'cancelled' },
        createdAt: { $gte: startDate }
      }
    },
    {
      $group: {
        _id: { $dateToString: { format: "%Y-%m-%d", date: "$createdAt" } },
        revenue: { $sum: "$totalAmount" },
        orders: { $sum: 1 }
      }
    }
  ]) as { _id: string; revenue: number; orders: number }[];

  dailyStats.forEach(item => {
    const day = last7Days.find(d => d.date === item._id);
    if (day) {
      day.revenue = item.revenue;
      day.orders = item.orders;
    }
  });

  // 3. Sales by Category
  const categorySales = (await Order.aggregate([
    { $match: { status: { $ne: 'cancelled' } } },
    { $unwind: '$items' },
    {
      $lookup: {
        from: 'menus',
        localField: 'items.productId',
        foreignField: '_id',
        as: 'menuItem'
      }
    },
    { $unwind: '$menuItem' },
    {
      $lookup: {
        from: 'menucategories',
        localField: 'menuItem.category',
        foreignField: '_id',
        as: 'categoryInfo'
      }
    },
    { $unwind: '$categoryInfo' },
    {
      $group: {
        _id: '$categoryInfo.name',
        value: { $sum: '$items.totalPrice' }
      }
    },
    { $sort: { value: -1 } },
    { $limit: 5 }
  ])) as { _id: string; value: number }[];

  const colors = ['#a78bfa', '#10b981', '#f59e0b', '#8b5cf6', '#ef4444'];
  const formattedCategoryData = categorySales.map((item, index) => ({
    name: item._id,
    value: item.value,
    color: colors[index % colors.length]
  }));

  // 4. Branch Performance
  const branchPerformance = (await Order.aggregate([
    { $match: { status: { $ne: 'cancelled' } } },
    {
      $lookup: {
        from: 'branches',
        localField: 'branchId',
        foreignField: '_id',
        as: 'branchInfo'
      }
    },
    { $unwind: '$branchInfo' },
    {
      $group: {
        _id: '$branchInfo.branch_name',
        orders: { $sum: 1 },
        revenue: { $sum: '$totalAmount' }
      }
    },
    { $sort: { revenue: -1 } },
    { $limit: 5 }
  ])) as { _id: string; orders: number; revenue: number }[];

  const formattedBranchData = branchPerformance.map(item => ({
    name: item._id,
    orders: item.orders,
    revenue: item.revenue
  }));

  // 5. Top Selling Products
  const topProducts = (await Order.aggregate([
    { $match: { status: { $ne: 'cancelled' } } },
    { $unwind: '$items' },
    {
      $group: {
        _id: '$items.productId',
        name: { $first: '$items.menuName' },
        unitsSold: { $sum: '$items.quantity' },
        revenue: { $sum: '$items.totalPrice' }
      }
    },
    { $sort: { unitsSold: -1 } },
    { $limit: 5 }
  ])) as { _id: string; name: string; unitsSold: number; revenue: number }[];

  const maxUnits = topProducts.length > 0 ? topProducts[0].unitsSold : 1;
  const formattedTopProducts = topProducts.map((item, index) => ({
    rank: index + 1,
    name: item.name,
    unitsSold: item.unitsSold,
    revenue: `AED ${item.revenue.toFixed(2)}`,
    performance: Math.round((item.unitsSold / maxUnits) * 100)
  }));

  // 6. New Customers (Last 30 days)
  const last30DaysStart = dayjs().subtract(30, 'days').startOf('day').toDate();
  const newCustomers = await Customer.countDocuments({
    createdAt: { $gte: last30DaysStart }
  });

  // 7. Recent Orders
  const recentOrders = await Order.find()
    .sort({ createdAt: -1 })
    .limit(10)
    .populate('customerId', 'name')
    .populate('branchId', 'branch_name');

  // 8. Order Status Distribution
  const orderStatusData = await Order.aggregate([
    {
      $group: {
        _id: "$status",
        value: { $sum: 1 }
      }
    }
  ]);

  const statusColors: Record<string, string> = {
    placed: "#f59e0b",
    preparing: "#a78bfa",
    ready: "#10b981",
    completed: "#8b5cf6",
    cancelled: "#ef4444"
  };

  const formattedOrderStatus = orderStatusData.map(item => ({
    name: item._id.charAt(0).toUpperCase() + item._id.slice(1),
    value: item.value,
    color: statusColors[item._id as string] || "#64748b"
  }));

  return {
    stats: {
      totalRevenue,
      totalOrders,
      totalCustomers,
      totalShops,
      avgOrderValue,
      newCustomers
    },
    weeklyRevenue: last7Days,
    categoryData: formattedCategoryData,
    branchPerformance: formattedBranchData,
    topProducts: formattedTopProducts,
    recentOrders,
    orderStatus: formattedOrderStatus
  };
};

export const DashboardService = {
  getShopOwnerDashboardStats,
  getAdminDashboardStats
};
