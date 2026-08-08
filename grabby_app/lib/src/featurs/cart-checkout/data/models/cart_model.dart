
class CartModel {
  final String? id;
  final String? customerId;
  final String branchId;
  final List<CartItemModel> items;
  final int totalItems;
  final double totalAmount;
  final double appliedCredit;
  final String? createdAt;
  final String? updatedAt;

  CartModel({
    this.id,
    this.customerId,
    required this.branchId,
    required this.items,
    required this.totalItems,
    required this.totalAmount,
    this.appliedCredit = 0.0,
    this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['cartId'] ?? json['_id'],
      customerId: json['customerId'],
      branchId: json['branchId'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: json['totalItems'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      appliedCredit: (json['appliedCredit'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': id,
      'branchId': branchId,
      'items': items.map((e) => e.toJson()).toList(),
      'totalItems': totalItems,
      'totalAmount': totalAmount,
      'appliedCredit': appliedCredit,
    };
  }
}

class CartItemModel {
  final String? id;
  final String productId;
  final String menuName;
  final double? menuPrice;
  final String? menuImage;
  final int quantity;
  final List<CartAdditionalItemModel> additionalItems;
  final double? totalPrice;
  final String? createdAt;
  final String? updatedAt;

  CartItemModel({
    this.id,
    required this.productId,
    required this.menuName,
    this.menuPrice,
    this.menuImage,
    required this.quantity,
    required this.additionalItems,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['itemId'] ?? json['_id'],
      productId: json['productId'] ?? '',
      menuName: json['menuName'] ?? '',
      menuPrice: (json['menuPrice'] ?? 0.0).toDouble(),
      menuImage: json['menuImage'],
      quantity: json['quantity'] ?? 0,
      additionalItems: (json['additionalItems'] as List? ?? [])
          .map((e) =>
              CartAdditionalItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': id,
      'productId': productId,
      'menuName': menuName,
      'menuPrice': menuPrice,
      'menuImage': menuImage,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'additionalItems': additionalItems.map((e) => e.toJson()).toList(),
    };
  }
}

class CartAdditionalItemModel {
  final String? id;
  final String itemId;
  final String name;
  final double price;
  final String? image;
  final int quantity;

  CartAdditionalItemModel({
    this.id,
    required this.itemId,
    required this.name,
    required this.price,
    this.image,
    required this.quantity,
  });

  factory CartAdditionalItemModel.fromJson(Map<String, dynamic> json) {
    return CartAdditionalItemModel(
      id: json['_id'],
      itemId: json['itemId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'],
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'itemId': itemId,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}

class AddToCartRequest {
  final String branchId;
  final String productId;
  final String menuName;
  final double menuPrice;
  final String menuImage;
  final int quantity;
  final List<CartAdditionalItemModel> additionalItems;

  AddToCartRequest({
    required this.branchId,
    required this.productId,
    required this.menuName,
    required this.menuPrice,
    required this.menuImage,
    required this.quantity,
    required this.additionalItems,
  });

  Map<String, dynamic> toJson() {
    return {
      "branchId": branchId,
      "productId": productId,
      "menuName": menuName,
      "menuPrice": menuPrice,
      "menuImage": menuImage,
      "quantity": quantity,
      "additionalItems": additionalItems.map((e) => e.toJson()).toList(),
    };
  }
}
