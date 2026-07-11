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
import { CustomerStampService } from '../customer_stamps/customer_stamps.service';
import { initializeStripePayment } from '../../../utils/stripe';

const generateOrderId = async (): Promise<string> => {
  const date = new Date();
  const year = date.getFullYear().toString().slice(-2);
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');

  const count = await Order.countDocuments();
  const nextNumber = (count + 1).toString().padStart(4, '0');

  return `ORD-${year}${month}${day}-${nextNumber}`;
};

const createOrder = async (customerId: string, authId: string, payload: Partial<IOrder>) => {
  const orderId = await generateOrderId();

  const paymentMethod = payload.paymentMethod || 'stripe';
  const isCardPayment = paymentMethod === 'card' || paymentMethod === 'stripe';

  // Default values as per user request
  const orderData: any = {
    ...payload,
    customerId,
    orderId,
    paymentMethod,
    paymentStatus: isCardPayment ? 'unpaid' : 'paid',
    transactionId: isCardPayment ? '' : (payload.transactionId || '6478ytwefgfwe456743654'),
    status: 'placed',
    referenceToken: null,
  };

  // If card payment, initialize Stripe Payment to get reference token
  if (isCardPayment) {
    const customer = await Customer.findById(customerId);
    const stripeResult = await initializeStripePayment({
      amount: payload.totalAmount || 0,
      customerName: customer?.name || 'Customer',
      email: customer?.email || 'customer@example.com',
      phone: customer?.phone_number || '0000000000',
      orderId,
    });

    if (!stripeResult.success) {
      throw new ApiError(httpStatus.BAD_REQUEST, stripeResult.error || 'Failed to initialize Stripe payment');
    }

    orderData.referenceToken = stripeResult.reference_token;
  }

  const result = await Order.create(orderData);

  // Clear cart after creating the order
  if (result) {
    await Cart.deleteMany({ customerId, branchId: payload.branchId });

    // For non-card payments (e.g. cash), award stamps/points and send notifications immediately
    if (!isCardPayment) {
      // Add 1 stamp for the branch
      if (payload.branchId) {
        await CustomerStampService.addStamp(authId, payload.branchId.toString(), 1);
      }

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
  }

  return result;
};

const confirmPayment = async (orderId: string, transactionNo: string, paymentDetails: any) => {
  const order = await Order.findOne({ orderId });
  if (!order) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Order not found');
  }

  // If already paid, return early to prevent duplicate processing
  if (order.paymentStatus === 'paid') {
    return order;
  }

  const result = await Order.findOneAndUpdate(
    { orderId },
    {
      paymentStatus: 'paid',
      transactionId: transactionNo,
      paymentDetails,
      status: 'placed',
    },
    { new: true }
  );

  if (result) {
    const customer = await Customer.findById(result.customerId);
    const authId = customer?.authId?.toString();

    // Add 1 stamp for the branch
    if (result.branchId && authId) {
      await CustomerStampService.addStamp(authId, result.branchId.toString(), 1);
    }

    // Calculate and add earned points (stamps) for the shop
    // 2 points for every 5 total price
    const earnedPoints = Math.floor((result.totalAmount || 0) / 5) * 2;
    if (earnedPoints > 0 && authId) {
      // Check if the shop owner has reward points enabled
      const branch = await Branch.findById(result.branchId).populate('shopOwnerId');
      const isRewardEnabled = branch && (branch.shopOwnerId as any)?.isRewardPointEnabled !== false;

      if (isRewardEnabled) {
        await Customer.findByIdAndUpdate(
          result.customerId,
          { $inc: { pointWallet: earnedPoints } }
        );

        // Create notification for Customer: Points earned
        await NotificationService.createNotification({
          title: 'Points Earned',
          message: `You earned ${earnedPoints} points from order ${orderId}`,
          recipient: result.customerId as any,
          role: 'customer',
          orderId: result._id as any,
        });
      }
    }

    // Create notification for Shop Owner: New Order
    const branch = await Branch.findById(result.branchId);
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

const cancelOrder = async (orderId: string, customerId: string, cancelNote: string, cancelStatus?: any) => {
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

  const cStatus = cancelStatus === true ? 'pending' : (cancelStatus || 'pending');

  const result = await Order.findByIdAndUpdate(
    orderId,
    { cancelNote, cancelStatus: cStatus },
    { new: true }
  );

  if (result) {
    // Create notification for Shop Owner: Cancel Request
    const branch = await Branch.findById(result.branchId);
    if (branch) {
      await NotificationService.createNotification({
        title: 'Order Cancel Request',
        message: `Customer requested to cancel order ${result.orderId}`,
        recipient: branch.shopOwnerId as any,
        role: 'shop_owner',
        orderId: result._id as any,
      });
    }
  }

  return result;
};

const respondCancelRequest = async (orderId: string, action: 'accept' | 'decline') => {
  const order = await Order.findById(orderId);

  if (!order) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Order not found');
  }

  if (order.cancelStatus !== 'pending') {
    throw new ApiError(httpStatus.BAD_REQUEST, 'No pending cancel request found for this order');
  }

  if (action === 'accept') {
    const result = await Order.findByIdAndUpdate(
      orderId,
      { status: 'cancelled', cancelStatus: 'accepted' },
      { new: true }
    );

    if (result) {
      // Deduct points since order is now officially cancelled
      const earnedPoints = Math.floor((result.totalAmount || 0) / 5) * 2;
      if (earnedPoints > 0) {
        const branch = await Branch.findById(result.branchId).populate('shopOwnerId');
        const isRewardEnabled = branch && (branch.shopOwnerId as any)?.isRewardPointEnabled !== false;

        if (isRewardEnabled) {
          await Customer.findByIdAndUpdate(
            result.customerId,
            { $inc: { pointWallet: -earnedPoints } }
          );
        }
      }

      // Notify customer
      await NotificationService.createNotification({
        title: 'Cancel Request Accepted',
        message: `Your cancel request for order ${result.orderId} has been accepted.`,
        recipient: result.customerId as any,
        role: 'customer',
        orderId: result._id as any,
      });
    }

    return result;
  } else if (action === 'decline') {
    const result = await Order.findByIdAndUpdate(
      orderId,
      { cancelStatus: 'declined' },
      { new: true }
    );

    if (result) {
      // Notify customer
      await NotificationService.createNotification({
        title: 'Cancel Request Declined',
        message: `Your cancel request for order ${result.orderId} has been declined.`,
        recipient: result.customerId as any,
        role: 'customer',
        orderId: result._id as any,
      });
    }

    return result;
  } else {
    throw new ApiError(httpStatus.BAD_REQUEST, 'Invalid action. Must be accept or decline');
  }
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
  confirmPayment,
  getMyOrders,
  getSingleOrder,
  getBranchOrders,
  getAllOrders,
  updateOrderStatus,
  cancelOrder,
  respondCancelRequest,
  updateOrderLocation,
  updateOrderNearbyStatus,
};
