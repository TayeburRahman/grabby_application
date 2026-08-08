

class OrderModel {
  final String? id;
  final String? orderId;
  final dynamic customerId; // Can be String or CustomerInfo
  final dynamic branchId; // Can be String or BranchInfo
  final List<OrderItemModel> items;
  final String? pickupType;
  final double? applyGrabbyCredit;
  final double? applyPromoCode;
  final double totalAmount;
  final String? carPlates;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? transactionId;
  final String? createdAt;
  final String? updatedAt;
  final bool? nearByShop;
  final String? cancelNote;
  final String? cancelStatus;
  final String? referenceToken;

  OrderModel({
    this.id,
    this.orderId,
    this.customerId,
    this.branchId,
    required this.items,
    this.pickupType,
    this.applyGrabbyCredit,
    this.applyPromoCode,
    required this.totalAmount,
    this.carPlates,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.transactionId,
    this.createdAt,
    this.updatedAt,
    this.nearByShop,
    this.cancelNote,
    this.cancelStatus,
    this.referenceToken,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'],
      orderId: json['orderId'],
      customerId: json['customerId'] != null && json['customerId'] is Map 
          ? CustomerInfo.fromJson(json['customerId']) 
          : json['customerId'],
      branchId: json['branchId'] != null && json['branchId'] is Map 
          ? BranchInfo.fromJson(json['branchId']) 
          : json['branchId'],
      items: (json['items'] as List? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pickupType: json['pickupType'],
      applyGrabbyCredit: (json['applyGrabbyCredit'] ?? 0.0).toDouble(),
      applyPromoCode: (json['applyPromoCode'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      carPlates: json['carPlates'],
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      nearByShop: json['nearByShop'],
      cancelNote: json['cancelNote'],
      cancelStatus: json['cancelStatus'],
      referenceToken: json['referenceToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId is BranchInfo ? (branchId as BranchInfo).id : branchId,
      'items': items.map((e) => e.toJson()).toList(),
      'pickupType': pickupType,
      'applyGrabbyCredit': applyGrabbyCredit,
      'applyPromoCode': applyPromoCode,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'carPlates': carPlates,
      'nearByShop': nearByShop,
      'cancelNote': cancelNote,
      'cancelStatus': cancelStatus,
    };
  }
}

class OrderItemModel {
  final String? id;
  final String productId;
  final String menuName;
  final double? menuPrice;
  final String? menuImage;
  final int quantity;
  final List<OrderAdditionalItemModel> additionalItems;
  final double? totalPrice;

  OrderItemModel({
    this.id,
    required this.productId,
    required this.menuName,
    this.menuPrice,
    this.menuImage,
    required this.quantity,
    required this.additionalItems,
    this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['_id'] ?? json['id'],
      productId: json['productId'] ?? '',
      menuName: json['menuName'] ?? '',
      menuPrice: (json['menuPrice'] ?? 0.0).toDouble(),
      menuImage: json['menuImage'],
      quantity: json['quantity'] ?? 0,
      additionalItems: (json['additionalItems'] as List? ?? [])
          .map((e) =>
              OrderAdditionalItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'menuName': menuName,
      'menuPrice': menuPrice,
      'menuImage': menuImage,
      'quantity': quantity,
      'additionalItems': additionalItems.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
    };
  }
}

class OrderAdditionalItemModel {
  final String? id;
  final String itemId;
  final String name;
  final double price;
  final int quantity;

  OrderAdditionalItemModel({
    this.id,
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderAdditionalItemModel.fromJson(Map<String, dynamic> json) {
    return OrderAdditionalItemModel(
      id: json['_id'] ?? json['id'],
      itemId: json['itemId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}

class BranchInfo {
  final String id;
  final String branchName;
  final String address;
  final String? phoneNumber;
  final double? lat;
  final double? lng;

  BranchInfo({
    required this.id,
    required this.branchName,
    required this.address,
    this.phoneNumber,
    this.lat,
    this.lng,
  });

  factory BranchInfo.fromJson(Map<String, dynamic> json) {
    return BranchInfo(
      id: json['_id'] ?? json['id'] ?? '',
      branchName: json['branch_name'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'],
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }
}

class CustomerInfo {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String? addressName;
  final double? lat;
  final double? lon;

  CustomerInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    this.addressName,
    this.lat,
    this.lon,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profileImage: json['profile_image'],
      addressName: json['addressName'],
      lat: json['lat']?.toDouble(),
      lon: json['lon']?.toDouble(),
    );
  }
}
