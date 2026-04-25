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
      menuName,
      menuPrice = 0,
      menuImage,
      quantity = 0,
      additionalItems = []
    } = itemData;

    // Validate branch exists
    const branch = await Branch.findById(branchId);
    if (!branch) {
      throw new ApiError(httpStatus.NOT_FOUND, `Branch not found: ${branchId}`);
    }

    // Validate menu item exists
    let menuStamps = 0;
    const menu = await Menu.findById(productId);
    if (!menu) {
      throw new ApiError(httpStatus.NOT_FOUND, 'Menu item not found');
    }
    if (!menu.isAvailable) {
      throw new ApiError(httpStatus.BAD_REQUEST, 'Menu item is not available');
    }

    menuStamps = menu.stamp || 0;

    // If price is 0 and it's a menu item (quantity > 0), check stamps
    if (quantity > 0 && menuPrice === 0 && menuStamps > 0) {
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
    let totalPrice = (menuPrice || 0) * (quantity || 0);

    // Add additional items price
    for (const additionalItem of additionalItems) {
      totalPrice += additionalItem.price * additionalItem.quantity;
    }

    // Check if item already exists in cart
    const existingItem = cart.items.find(
      (item) => item.productId && item.productId.equals(productId)
    );

    if (existingItem) {
      // Update existing item details if provided
      if (menuName) existingItem.menuName = menuName;
      if (menuPrice !== undefined) existingItem.menuPrice = menuPrice;
      if (menuImage) existingItem.menuImage = menuImage;

      // Update quantity
      existingItem.quantity = (existingItem.quantity || 0) + (quantity || 0);

      // Merge additional items
      if (additionalItems && additionalItems.length > 0) {
        if (!existingItem.additionalItems) {
          existingItem.additionalItems = [];
        }

        for (const newAddon of additionalItems) {
          const existingAddon = existingItem.additionalItems.find(
            (addon) => addon.itemId && addon.itemId.toString() === newAddon.itemId.toString()
          );

          if (existingAddon) {
            existingAddon.quantity = (existingAddon.quantity || 0) + (newAddon.quantity || 0);
          } else {
            existingItem.additionalItems.push(newAddon);
          }
        }
      }

      // Recalculate total price for the updated item
      let updatedItemTotalPrice = (existingItem.menuPrice || 0) * (existingItem.quantity || 0);
      for (const addon of existingItem.additionalItems || []) {
        updatedItemTotalPrice += (addon.price || 0) * (addon.quantity || 0);
      }
      existingItem.totalPrice = updatedItemTotalPrice;

      // Mark items array as modified to ensure Mongoose saves changes to subdocuments
      cart.markModified('items');
    } else {
      // Add as a new item if not exists
      const newItem: ICartItem = {
        customerId: customerId as any,
        branchId: branchId as any,
        productId: productId as any,
        menuName,
        menuPrice,
        menuImage,
        quantity,
        additionalItems,
        totalPrice: totalPrice,
      };
      cart.items.push(newItem);
    }

    // Deduct stamps if price is 0 and quantity > 0
    if (quantity > 0 && menuPrice === 0 && menuStamps > 0) {
      await CustomerStampService.addStamp(
        customer.authId.toString(),
        branchId,
        -(quantity * menuStamps)
      );
    }

    // Update cart totals
    cart.totalItems = cart.items.reduce((sum, item) => sum + (item.quantity || 0) + (item.additionalItems?.length || 0), 0);
    const grossTotal = cart.items.reduce((sum, item) => sum + item.totalPrice, 0);

    if (cart.appliedCredit && cart.appliedCredit > 0) {
      if (grossTotal < cart.appliedCredit) {
        const differenceToRefund = cart.appliedCredit - grossTotal;
        const cartCustomer = await Customer.findById(cart.customerId);
        if (cartCustomer) {
          cartCustomer.credWallet += differenceToRefund;
          await cartCustomer.save();
        }
        cart.appliedCredit = grossTotal;
      }
    }
    cart.totalAmount = grossTotal - (cart.appliedCredit || 0);

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
    if ((item.menuPrice || 0) === 0) {
      const menu = await Menu.findById(item.productId);
      if (menu && menu.stamp && menu.stamp > 0) {
        await CustomerStampService.addStamp(
          customer?.authId.toString() || customerId,
          cart.branchId.toString(),
          (item.quantity || 0) * menu.stamp
        );
      }
    }
    cart.items.splice(itemIndex, 1);
  } else {
    // Only update main item quantity and handle stamps if quantity is provided
    if (quantity !== undefined) {
      const oldQuantity = item.quantity || 0;
      const quantityDifference = quantity - oldQuantity;

      // Update quantity
      item.quantity = quantity;

      // Handle stamp adjustments for free items
      if ((item.menuPrice || 0) === 0 && quantityDifference !== 0) {
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
    }

    // Update additional items if provided
    if (additionalItems && Array.isArray(additionalItems)) {
      if (!item.additionalItems) {
        item.additionalItems = [];
      }

      for (const updateAddon of additionalItems) {
        const existingAddon = item.additionalItems.find(
          (addon) => addon.itemId && addon.itemId.toString() === updateAddon.itemId.toString()
        );

        if (existingAddon) {
          // Update quantity and any other provided fields
          if (updateAddon.quantity !== undefined) existingAddon.quantity = updateAddon.quantity;
          if (updateAddon.name) existingAddon.name = updateAddon.name;
          if (updateAddon.price !== undefined) existingAddon.price = updateAddon.price;
          if (updateAddon.image) existingAddon.image = updateAddon.image;
        } else {
          // If it's a new addon, we need name and price to add it safely
          if (updateAddon.name && updateAddon.price !== undefined) {
            item.additionalItems.push(updateAddon);
          }
        }
      }
    }

    // Recalculate total price
    let totalPrice = (item.menuPrice || 0) * (item.quantity || 0);
    for (const additionalItem of item.additionalItems || []) {
      totalPrice += (additionalItem.price || 0) * (additionalItem.quantity || 0);
    }
    item.totalPrice = totalPrice;
  }

  // Update cart totals
  cart.totalItems = cart.items.reduce((sum, item) => sum + (item.quantity || 0) + (item.additionalItems?.length || 0), 0);
  const grossTotal = cart.items.reduce((sum, item) => sum + item.totalPrice, 0);

  if (cart.appliedCredit && cart.appliedCredit > 0) {
    if (grossTotal < cart.appliedCredit) {
      const differenceToRefund = cart.appliedCredit - grossTotal;
      const cartCustomer = await Customer.findById(cart.customerId);
      if (cartCustomer) {
        cartCustomer.credWallet += differenceToRefund;
        await cartCustomer.save();
      }
      cart.appliedCredit = grossTotal;
    }
  }
  cart.totalAmount = grossTotal - (cart.appliedCredit || 0);

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
  if ((removedItem.menuPrice || 0) === 0) {
    const menu = await Menu.findById(removedItem.productId);
    if (menu && menu.stamp && menu.stamp > 0) {
      await CustomerStampService.addStamp(
        customer?.authId.toString() || customerId,
        cart.branchId.toString(),
        (removedItem.quantity || 0) * menu.stamp
      );
    }
  }

  cart.items.splice(itemIndex, 1);

  // Update cart totals
  cart.totalItems = cart.items.reduce((sum, item) => sum + (item.quantity || 0) + (item.additionalItems?.length || 0), 0);
  const grossTotal = cart.items.reduce((sum, item) => sum + item.totalPrice, 0);

  if (cart.appliedCredit && cart.appliedCredit > 0) {
    if (grossTotal < cart.appliedCredit) {
      const differenceToRefund = cart.appliedCredit - grossTotal;
      const cartCustomer = await Customer.findById(cart.customerId);
      if (cartCustomer) {
        cartCustomer.credWallet += differenceToRefund;
        await cartCustomer.save();
      }
      cart.appliedCredit = grossTotal;
    }
  }
  cart.totalAmount = grossTotal - (cart.appliedCredit || 0);

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

  const cartsToClear = await Cart.find(filter);
  const customer = await Customer.findById(customerId);

  // Refund any applied credit before clearing carts
  if (customer) {
    for (const c of cartsToClear) {
      if (c.appliedCredit && c.appliedCredit > 0) {
        customer.credWallet += c.appliedCredit;
      }
    }
    await customer.save();
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
    cartId: cart._id,
    branchId: cart.branchId,
    totalItems: cart.totalItems,
    totalAmount: cart.totalAmount,
    appliedCredit: cart.appliedCredit,
    items: cart.items.map(item => ({
      itemId: item._id,
      productId: item.productId,
      menuName: item.menuName,
      menuImage: item.menuImage,
      quantity: item.quantity,
      totalPrice: item.totalPrice,
      additionalItems: item.additionalItems,
    })),
  }));

  return summary;
};

const applyCredit = async (customerId: string, cartId: string) => {
  const customer = await Customer.findById(customerId);
  const cart = await Cart.findById(cartId);

  if (!cart) throw new ApiError(httpStatus.NOT_FOUND, 'Cart not found');
  if (cart.customerId.toString() !== customerId) throw new ApiError(httpStatus.FORBIDDEN, 'Not your cart');
  if (!customer) throw new ApiError(httpStatus.NOT_FOUND, 'Customer not found');

  // Revert previously applied credit to get the base totalAmount
  if (cart.appliedCredit && cart.appliedCredit > 0) {
    customer.credWallet += cart.appliedCredit;
    cart.totalAmount += cart.appliedCredit;
    cart.appliedCredit = 0;
  }

  const baseTotal = cart.totalAmount;
  const maxCreditCanApply = Math.min(baseTotal, customer.credWallet);

  if (maxCreditCanApply <= 0) {
    throw new ApiError(httpStatus.BAD_REQUEST, 'No credit available to apply or cart is empty');
  }

  cart.appliedCredit = maxCreditCanApply;
  cart.totalAmount = baseTotal - maxCreditCanApply;
  customer.credWallet -= maxCreditCanApply;

  await customer.save();
  await cart.save();

  return {
    totalAmount: cart.totalAmount,
    details: {
      grossTotal: baseTotal,
      appliedCredit: cart.appliedCredit,
    },
  };
};

export const CartService = {
  addToCart,
  updateCartItem,
  removeFromCart,
  getCart,
  clearCart,
  getCartSummary,
  applyCredit,
};