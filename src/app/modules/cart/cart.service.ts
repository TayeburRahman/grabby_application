import httpStatus from 'http-status';
import ApiError from '../../../errors/ApiError';
import { Cart } from './cart.model';
import { ICartItem } from './cart.interface';
import { Menu } from '../menu/menu.model';
import { Branch } from '../shop_owner/shop_owner.model';
import Customer from '../customers/customers.model';
import { CustomerStampService } from '../customer_stamps/customer_stamps.service';

const addToCart = async (customerId: string, cartData: any) => {
  const itemsToAdd = Array.isArray(cartData) ? cartData : [cartData];

  // Validate customer exists once
  const customer = await Customer.findById(customerId);
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Customer not found');
  }

  let lastCart = null;

  for (const itemData of itemsToAdd) {
    const {
      branchId,
      productId,
      productType,
      menuName,
      menuPrice,
      menuImage,
      quantity,
      additionalItems = []
    } = itemData;

    // Validate branch exists
    const branch = await Branch.findById(branchId);
    if (!branch) {
      throw new ApiError(httpStatus.NOT_FOUND, `Branch not found: ${branchId}`);
    }

    // Validate menu item exists if productType is 'menu' 
    let menuStamps = 0;
    if (productType === 'menu') {
      const menu = await Menu.findById(productId);
      if (!menu) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Menu item not found');
      }
      if (!menu.isAvailable) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Menu item is not available');
      }

      menuStamps = menu.stamp || 0;

      // Check if item can be taken for free
      if (menuPrice === 0 && menuStamps === 0) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'This menu item cannot be taken for free');
      }

      // If price is 0, check customer stamps
      if (menuPrice === 0 && menuStamps > 0) {
        const customerStampData = await CustomerStampService.getCustomerStampsByBranch(
          customer.authId.toString(),
          branchId
        );
        const customerTotalStamps = customerStampData.totalStamps || 0;
        if (customerTotalStamps < menuStamps) {
          throw new ApiError(
            httpStatus.BAD_REQUEST,
            `Insufficient stamps. Required: ${menuStamps}, Available: ${customerTotalStamps}`
          );
        }
      }
    } else if (productType === 'additional_item') {
      const menu = await Menu.findById(productId);
      if (!menu) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Menu not found');
      }
      if (!menu.isAvailable) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Menu is not available');
      }

      // Find the additional item
      const additionalItem = menu.additionalItems?.flatMap(group => group.items).find(item => item.name === menuName);
      if (!additionalItem) {
        throw new ApiError(httpStatus.NOT_FOUND, 'Additional item not found in menu');
      }
      if (additionalItem.price !== menuPrice) {
        throw new ApiError(httpStatus.BAD_REQUEST, 'Price mismatch for additional item');
      }

      // No stamps for additional items
      menuStamps = 0;
    }

    // Find or create cart for this customer and branch
    let cart = await Cart.findOne({ customerId, branchId });

    if (!cart) {
      cart = await Cart.create({
        customerId,
        branchId,
        items: [],
        totalItems: 0,
        totalAmount: 0,
      });
    }

    // Calculate total price for this item
    let totalPrice = menuPrice * quantity;

    // Add additional items price
    for (const additionalItem of additionalItems) {
      totalPrice += additionalItem.price * additionalItem.quantity;
    }

    // Always add as a new item to ensure different objects for all menu items and additional items
    const newItem: ICartItem = {
      customerId: customerId as any,
      branchId: branchId as any,
      productId: productId as any,
      productType,
      menuName,
      menuPrice,
      menuImage,
      quantity,
      additionalItems,
      totalPrice,
    };

    cart.items.push(newItem);

    // Deduct stamps if price is 0
    if (menuPrice === 0 && menuStamps > 0) {
      await CustomerStampService.addStamp(
        customer.authId.toString(),
        branchId,
        -(quantity * menuStamps)
      );
    }

    // Update cart totals
    cart.totalItems = cart.items.reduce((sum, item) => sum + item.quantity, 0);
    cart.totalAmount = cart.items.reduce((sum, item) => sum + item.totalPrice, 0);

    await cart.save();
    lastCart = cart;
  }

  return lastCart;
};

const updateCartItem = async (customerId: string, itemId: string, updateData: any) => {
  const { quantity, additionalItems } = updateData;

  const cart = await Cart.findOne({ customerId, 'items._id': itemId });
  if (!cart) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Cart item not found');
  }

  const itemIndex = cart.items.findIndex(item => item._id?.toString() === itemId);
  if (itemIndex === -1) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Cart item not found');
  }

  const item = cart.items[itemIndex];
  const customer = await Customer.findById(customerId);

  if (quantity === 0) {
    // Remove item if quantity is 0
    // Refund stamps if item price is 0
    if (item.menuPrice === 0 && item.productType === 'menu') {
      const menu = await Menu.findById(item.productId);
      if (menu && menu.stamp && menu.stamp > 0) {
        await CustomerStampService.addStamp(
          customer?.authId.toString() || customerId,
          cart.branchId.toString(),
          item.quantity * menu.stamp
        );
      }
    }
    cart.items.splice(itemIndex, 1);
  } else {
    const oldQuantity = item.quantity;
    const quantityDifference = quantity - oldQuantity;

    // Update quantity
    item.quantity = quantity;

    // Handle stamp adjustments for free items
    if (item.menuPrice === 0 && item.productType === 'menu' && quantityDifference !== 0) {
      const menu = await Menu.findById(item.productId);
      if (menu && menu.stamp && menu.stamp > 0) {
        // Negative value = deduct stamps, Positive value = refund stamps
        await CustomerStampService.addStamp(
          customer?.authId.toString() || customerId,
          cart.branchId.toString(),
          -(quantityDifference * menu.stamp)
        );
      }
    }

    // Update additional items if provided
    if (additionalItems) {
      item.additionalItems = additionalItems;
    }

    // Recalculate total price
    let totalPrice = item.menuPrice * item.quantity;
    for (const additionalItem of item.additionalItems || []) {
      totalPrice += additionalItem.price * (additionalItem.quantity || 1);
    }
    item.totalPrice = totalPrice;
  }

  // Update cart totals
  cart.totalItems = cart.items.reduce((sum, item) => sum + item.quantity, 0);
  cart.totalAmount = cart.items.reduce((sum, item) => sum + item.totalPrice, 0);

  await cart.save();
  return cart;
};

const removeFromCart = async (customerId: string, itemId: string) => {
  const cart = await Cart.findOne({ customerId, 'items._id': itemId });
  if (!cart) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Cart item not found');
  }

  const itemIndex = cart.items.findIndex(item => item._id?.toString() === itemId);
  if (itemIndex === -1) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Cart item not found');
  }

  const removedItem = cart.items[itemIndex];
  const customer = await Customer.findById(customerId);
  
  // Refund stamps if item price is 0
  if (removedItem.menuPrice === 0 && removedItem.productType === 'menu') {
    const menu = await Menu.findById(removedItem.productId);
    if (menu && menu.stamp && menu.stamp > 0) {
      await CustomerStampService.addStamp(
        customer?.authId.toString() || customerId,
        cart.branchId.toString(),
        removedItem.quantity * menu.stamp
      );
    }
  }

  cart.items.splice(itemIndex, 1);

  // Update cart totals
  cart.totalItems = cart.items.reduce((sum, item) => sum + item.quantity, 0);
  cart.totalAmount = cart.items.reduce((sum, item) => sum + item.totalPrice, 0);

  await cart.save();
  return cart;
};

const getCart = async (customerId: string, branchId?: string) => {
  let filter: any = { customerId };
  if (branchId) {
    filter.branchId = branchId;
  }

  const carts = await Cart.find(filter)
    .populate('branchId', 'branch_name address')
    .populate('customerId', 'name email');

  return carts;
};

const clearCart = async (customerId: string, branchId?: string) => {
  let filter: any = { customerId };
  if (branchId) {
    filter.branchId = branchId;
  }

  const result = await Cart.deleteMany(filter);
  return { message: 'Cart cleared successfully', deletedCount: result.deletedCount };
};

const getCartSummary = async (customerId: string, branchId?: string) => {
  let filter: any = { customerId };
  if (branchId) {
    filter.branchId = branchId;
  }

  const carts = await Cart.find(filter);

  const summary = carts.map(cart => ({
    branchId: cart.branchId,
    totalItems: cart.totalItems,
    totalAmount: cart.totalAmount,
    items: cart.items.map(item => ({
      productId: item.productId,
      productType: item.productType,
      menuName: item.menuName,
      quantity: item.quantity,
      totalPrice: item.totalPrice,
      additionalItems: item.additionalItems,
    })),
  }));

  return summary;
};

export const CartService = {
  addToCart,
  updateCartItem,
  removeFromCart,
  getCart,
  clearCart,
  getCartSummary,
};