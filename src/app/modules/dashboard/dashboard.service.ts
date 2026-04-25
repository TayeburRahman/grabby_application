import { Order } from '../order/order.model';
import { Menu } from '../menu/menu.model';
import { Branch } from '../shop_owner/shop_owner.model';

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

export const DashboardService = {
  getShopOwnerDashboardStats
};
