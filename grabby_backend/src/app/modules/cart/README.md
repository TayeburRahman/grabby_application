# Cart System API Documentation

## Overview
The cart system allows customers to add menu items and additional items to their shopping cart for different branches.

## Cart Item Structure
```json
{
  "branchId": "branch_object_id",
  "productId": "menu_or_additional_item_id",
  "productType": "menu" | "additional_item",
  "menuName": "Item Name",
  "menuPrice": 10.99,
  "menuImage": "image_url",
  "quantity": 2,
  "additionalItems": [
    {
      "itemId": "additional_item_id",
      "name": "Extra Cheese",
      "price": 2.50,
      "image": "image_url",
      "quantity": 1
    }
  ]
}
```

## API Endpoints

### 1. Add Item to Cart
**POST** `/cart/add`
- **Auth**: Customer required
- **Body**: Cart item data (see structure above)

### 2. Update Cart Item
**PATCH** `/cart/item/:itemId`
- **Auth**: Customer required
- **Body**:
  ```json
  {
    "quantity": 3,
    "additionalItems": [...]
  }
  ```

### 3. Remove Item from Cart
**DELETE** `/cart/item/:itemId`
- **Auth**: Customer required

### 4. Get Cart
**GET** `/cart`
- **Auth**: Customer required
- **Query**: `?branchId=branch_id` (optional, to get cart for specific branch)

### 5. Clear Cart
**DELETE** `/cart/clear`
- **Auth**: Customer required
- **Body**:
  ```json
  {
    "branchId": "branch_id" // optional, clear specific branch cart
  }
  ```

### 6. Get Cart Summary
**GET** `/cart/summary`
- **Auth**: Customer required
- **Query**: `?branchId=branch_id` (optional)

## Features

### Adding Menu Items
- Customers can add main menu items to cart
- Each menu item can have additional items (toppings, sides, etc.)
- Cart supports multiple branches (separate carts per branch)

### Adding Additional Items
- Additional items from menu's `additionalItems` array can be added directly to cart
- Useful for selling individual toppings, drinks, etc.

### Cart Management
- Update quantities
- Remove items
- Clear entire cart or branch-specific cart
- Automatic price calculation including additional items

### Validation
- Validates branch and menu existence
- Checks menu availability
- Ensures proper data types and ranges