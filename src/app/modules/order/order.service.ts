import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { IOrder } from './order.interface';
import { Order } from './order.model';
import { Cart } from '../cart/cart.model';
import QueryBuilder from '../../../builder/QueryBuilder';

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
    .populate('branchId', 'branch_name address')
    .populate('customerId', 'name email phone_number');

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

export const OrderService = {
  createOrder,
  getMyOrders,
  getSingleOrder,
  getBranchOrders,
  updateOrderStatus,
};
