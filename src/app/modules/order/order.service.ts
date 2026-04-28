import httpStatus from 'http-status';
import { Types } from 'mongoose';
import ApiError from '../../../errors/ApiError';
import { IOrder } from './order.interface';
import { Order } from './order.model';
import { Cart } from '../cart/cart.model';
import Customer from '../customers/customers.model';
import { Branch, ShopOwner } from '../shop_owner/shop_owner.model';
import QueryBuilder from '../../../builder/QueryBuilder';
import { NotificationService } from '../notification/notification.service';

const generateOrderId = async (): Promise<string> => {
  const date = new Date();
  const year = date.getFullYear().toString().slice(-2);
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');

  const count = await Order.countDocuments();
  const nextNumber = (count + 1).toString().padStart(4, '0');

  return `ORD-${year}${month}${day}-${nextNumber}`;
};

const createOrder = async (customerId: string, payload: Partial<IOrder>) => {
  const orderId = await generateOrderId();

  // Default values as per user request
  const orderData = {
    ...payload,
    customerId,
    orderId,
    paymentStatus: 'paid',
    transactionId: payload.transactionId || '6478ytwefgfwe456743654',
    status: 'placed',
  };

  const result = await Order.create(orderData);

  // Clear cart after successful order
  if (result) {
    await Cart.deleteMany({ customerId, branchId: payload.branchId });

    // Calculate and add earned points (stamps) for the shop
    // 2 points for every 5 total price
    const earnedPoints = Math.floor((payload.totalAmount || 0) / 5) * 2;
    if (earnedPoints > 0) {
      // Check if the shop owner has reward points enabled
      const branch = await Branch.findById(payload.branchId).populate('shopOwnerId');
      const isRewardEnabled = branch && (branch.shopOwnerId as any)?.isRewardPointEnabled !== false;

      if (isRewardEnabled) {
        await Customer.findByIdAndUpdate(
          customerId,
          { $inc: { pointWallet: earnedPoints } }
        );

        // Create notification for Customer: Points earned
        await NotificationService.createNotification({
          title: 'Points Earned',
          message: `You earned ${earnedPoints} points from order ${orderId}`,
          recipient: new Types.ObjectId(customerId) as any,
          role: 'customer',
          orderId: result._id as any,
        });
      }
    }

    // Create notification for Shop Owner: New Order
    const branch = await Branch.findById(payload.branchId);
    if (branch) {
      await NotificationService.createNotification({
        title: 'New Order',
        message: `You have a new order: ${orderId}`,
        recipient: branch.shopOwnerId as any,
        role: 'shop_owner',
        orderId: result._id as any,
      });
    }
  }

  return result;
};

const getMyOrders = async (customerId: string, query: Record<string, unknown>) => {

  const orderQuery = new QueryBuilder(
    Order.find({ customerId }).populate('branchId', 'branch_name address'),
    query
  )
    .filter()
    .sort()
    .paginate()
    .fields();

  const result = await orderQuery.modelQuery;
  const meta = await orderQuery.countTotal();

  return {
    meta,
    data: result,
  };
};

const getSingleOrder = async (orderId: string) => {
  const result = await Order.findById(orderId)
    .populate('branchId')
    .populate('customerId');

  if (!result) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Order not found');
  }
  return result;
};

const updateOrderStatus = async (orderId: string, status: string) => {
  const result = await Order.findByIdAndUpdate(
    orderId,
    { status },
    { new: true }
  );
  if (!result) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Order not found');
  }

  // Create notification for Customer: Status Update
  await NotificationService.createNotification({
    title: 'Order Status Updated',
    message: `Your order ${result.orderId} is now ${status}`,
    recipient: result.customerId as any,
    role: 'customer',
    orderId: result._id as any,
  });

  // Create notification for Shop Owner: Order Completed
  if (status === 'completed') {
    const branch = await Branch.findById(result.branchId);
    if (branch) {
      await NotificationService.createNotification({
        title: 'Order Completed',
        message: `Order ${result.orderId} has been completed`,
        recipient: branch.shopOwnerId as any,
        role: 'shop_owner',
        orderId: result._id as any,
      });
    }
  }

  return result;
};

const getBranchOrders = async (branchId: string, query: Record<string, unknown>) => {
  const orderQuery = new QueryBuilder(
    Order.find({ branchId }).populate('customerId', 'name email phone_number'),
    query
  )
    .filter()
    .sort()
    .paginate()
    .fields();

  const result = await orderQuery.modelQuery;
  const meta = await orderQuery.countTotal();

  return {
    meta,
    data: result,
  };
};

const getAllOrders = async (query: Record<string, unknown>) => {
  const orderQuery = new QueryBuilder(
    Order.find()
      .populate('customerId', 'name email phone_number')
      .populate('branchId', 'branch_name address'),
    query
  )
    .filter()
    .sort()
    .paginate()
    .fields();

  const result = await orderQuery.modelQuery;
  const meta = await orderQuery.countTotal();

  return {
    meta,
    data: result,
  };
};

const cancelOrder = async (orderId: string, customerId: string) => {
  const order = await Order.findOne({ _id: orderId, customerId });

  if (!order) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Order not found or you are not authorized to cancel this order');
  }

  if (order.status === 'cancelled') {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Order is already cancelled');
  }

  if (order.status === 'completed') {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Cannot cancel a completed order');
  }

  const result = await Order.findByIdAndUpdate(
    orderId,
    { status: 'cancelled' },
    { new: true }
  );

  // Deduct points if the order was cancelled
  if (result) {
    const earnedPoints = Math.floor((order.totalAmount || 0) / 5) * 2;
    if (earnedPoints > 0) {
      // Check if reward points were enabled for this shop
      const branch = await Branch.findById(order.branchId).populate('shopOwnerId');
      const isRewardEnabled = branch && (branch.shopOwnerId as any)?.isRewardPointEnabled !== false;

      if (isRewardEnabled) {
        await Customer.findByIdAndUpdate(
          customerId,
          { $inc: { pointWallet: -earnedPoints } }
        );
      }
    }
  }

  return result;
};

const updateOrderLocation = async (id: string, payload: { lat: number; lon: number }) => {
  const order = await Order.findById(id);
  if (!order) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Order not found');
  }

  // Update Customer location
  await Customer.findByIdAndUpdate(order.customerId, payload);

  // Notify Shop Owner via Socket
  const branch = await Branch.findById(order.branchId).populate('shopOwnerId');
  if (branch && branch.shopOwnerId) {
    const shopOwner = await ShopOwner.findById(branch.shopOwnerId);
    if (shopOwner && (global as any).io) {
      (global as any).io.to(shopOwner.authId.toString()).emit(`locationUpdate::${order.orderId}`, {
        orderId: order.orderId,
        lat: payload.lat,
        lon: payload.lon,
        customerId: order.customerId,
      });
    }
  }

  return { message: 'Location updated and notified successfully' };
};

const updateOrderNearbyStatus = async (orderId: string, customerId: string) => {
  const order = await Order.findOne({ _id: orderId, customerId });

  if (!order) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Order not found');
  }

  const result = await Order.findByIdAndUpdate(
    orderId,
    { nearByShop: true },
    { new: true }
  );

  if (result) {
    // Create notification for Shop Owner: Customer Nearby
    const branch = await Branch.findById(result.branchId);
    if (branch) {
      await NotificationService.createNotification({
        title: 'Customer Nearby',
        message: `Customer is nearby for order ${result.orderId}`,
        recipient: branch.shopOwnerId as any,
        role: 'shop_owner',
        orderId: result._id as any,
      });
    }
  }

  return result;
};

export const OrderService = {
  createOrder,
  getMyOrders,
  getSingleOrder,
  getBranchOrders,
  getAllOrders,
  updateOrderStatus,
  cancelOrder,
  updateOrderLocation,
  updateOrderNearbyStatus,
};
