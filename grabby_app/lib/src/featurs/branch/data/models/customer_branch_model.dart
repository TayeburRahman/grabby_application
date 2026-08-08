
class CustomerBranchModel {
  final String id;
  final String branchName;
  final String shopName;
  final String? image;
  final String address;
  final double distance;
  final String distanceText;
  final bool isOpen;
  final String statusText;
  final String timing;
  final List<String> tags;
  final double lat;
  final double lng;
  final int? totalStamps;
  final num? discount;
  final String? discountType;
  final String? endDate;
  final List<CustomerMenuCategory>? menuCategories;

  const CustomerBranchModel({
    required this.id,
    required this.branchName,
    required this.shopName,
    this.image,
    required this.address,
    required this.distance,
    required this.distanceText,
    required this.isOpen,
    required this.statusText,
    required this.timing,
    required this.tags,
    required this.lat,
    required this.lng,
    this.totalStamps,
    this.discount,
    this.discountType,
    this.endDate,
    this.menuCategories,
  });

  factory CustomerBranchModel.fromJson(Map<String, dynamic> json) {
    return CustomerBranchModel(
      id: json['_id'] ?? '',
      branchName: json['branch_name'] ?? '',
      shopName: json['shop_name'] ?? '',
      image: json['image'],
      address: json['address'] ?? '',
      distance: (json['distance'] ?? 0.0).toDouble(),
      distanceText: json['distanceText'] ?? '',
      isOpen: json['isOpen'] ?? false,
      statusText: json['statusText'] ?? '',
      timing: json['timing'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      totalStamps: (json['totalStamps'] as num?)?.toInt(),
      discount: json['discount'],
      discountType: json['discountType'],
      endDate: json['endDate'],
      menuCategories: json['menu_categories'] != null
          ? (json['menu_categories'] as List)
              .map((e) => CustomerMenuCategory.fromJson(e))
              .toList()
          : null,
    );
  }
}

class CustomerMenuCategory {
  final String id;
  final String name;
  final bool stampActive;
  final List<CustomerMenuItem> menus;

  const CustomerMenuCategory({
    required this.id,
    required this.name,
    required this.stampActive,
    required this.menus,
  });

  factory CustomerMenuCategory.fromJson(Map<String, dynamic> json) {
    return CustomerMenuCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      stampActive: json['stampActive'] ?? false,
      menus: (json['menus'] as List? ?? [])
          .map((e) => CustomerMenuItem.fromJson(e))
          .toList(),
    );
  }
}

class CustomerMenuItem {
  final String id;
  final String? image;
  final String itemName;
  final double price;
  final String? description;
  final int? stamp;
  final bool isAvailable;
  final CustomerMenuItemCategory? category;
  final List<CustomerCustomizationGroup>? additionalItems;
  final bool stampActive;
  final int? totalStamps;
  final bool isFree;
  final int? remainingStamps;
  final String? shopOwnerId;
  final double? originalPrice;
  final bool? discount;
  final int? discountParcent;
  final String? createdAt;
  final String? updatedAt;
  final CustomerEventOffer? eventOffer;

  const CustomerMenuItem({
    required this.id,
    this.image,
    required this.itemName,
    required this.price,
    this.description,
    this.stamp,
    required this.isAvailable,
    this.category,
    this.additionalItems,
    required this.stampActive,
    this.totalStamps,
    this.isFree = false,
    this.remainingStamps,
    this.shopOwnerId,
    this.originalPrice,
    this.discount,
    this.discountParcent,
    this.createdAt,
    this.updatedAt,
    this.eventOffer,
  });

  factory CustomerMenuItem.fromJson(Map<String, dynamic> json) {
    return CustomerMenuItem(
      id: json['_id'] ?? '',
      image: json['image'],
      itemName: json['itemName'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'],
      stamp: (json['stamp'] as num?)?.toInt(),
      isAvailable: json['isAvailable'] ?? true,
      category: json['category'] != null
          ? CustomerMenuItemCategory.fromJson(json['category'])
          : null,
      additionalItems: json['additionalItems'] != null
          ? (json['additionalItems'] as List)
              .map((e) => CustomerCustomizationGroup.fromJson(e))
              .toList()
          : null,
      stampActive: json['stampActive'] ?? false,
      totalStamps: (json['totalStamps'] as num?)?.toInt(),
      isFree: json['isFree'] ?? false,
      remainingStamps: (json['remainingStamps'] as num?)?.toInt(),
      shopOwnerId: json['shopOwnerId'],
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      discount: json['discount'],
      discountParcent: (json['discountParcent'] as num?)?.toInt(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      eventOffer: json['eventOffer'] != null
          ? CustomerEventOffer.fromJson(json['eventOffer'])
          : null,
    );
  }
}

class CustomerEventOffer {
  final String? discountName;
  final String? eventName;
  final String? endDate;
  final String? discountType;
  final num? discountValue;

  const CustomerEventOffer({
    this.discountName,
    this.eventName,
    this.endDate,
    this.discountType,
    this.discountValue,
  });

  factory CustomerEventOffer.fromJson(Map<String, dynamic> json) {
    return CustomerEventOffer(
      discountName: json['discountName'],
      eventName: json['eventName'],
      endDate: json['endDate'],
      discountType: json['discountType'],
      discountValue: json['discountValue'],
    );
  }
}

class CustomerMenuItemCategory {
  final String id;
  final String name;
  final String? shopOwnerId;
  final String? createdAt;
  final String? updatedAt;
  final bool? stampActive;
  final int? v;

  const CustomerMenuItemCategory({
    required this.id,
    required this.name,
    this.shopOwnerId,
    this.createdAt,
    this.updatedAt,
    this.stampActive,
    this.v,
  });

  factory CustomerMenuItemCategory.fromJson(Map<String, dynamic> json) {
    return CustomerMenuItemCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      shopOwnerId: json['shopOwnerId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      stampActive: json['stampActive'],
      v: (json['__v'] as num?)?.toInt(),
    );
  }
}

class CustomerCustomizationGroup {
  final String id;
  final String groupName;
  final String type;
  final List<CustomerCustomizationItem> items;

  const CustomerCustomizationGroup({
    required this.id,
    required this.groupName,
    required this.type,
    required this.items,
  });

  factory CustomerCustomizationGroup.fromJson(Map<String, dynamic> json) {
    return CustomerCustomizationGroup(
      id: json['_id'] ?? '',
      groupName: json['groupName'] ?? '',
      type: json['type'] ?? 'optional',
      items: (json['items'] as List? ?? [])
          .map((e) => CustomerCustomizationItem.fromJson(e))
          .toList(),
    );
  }
}

class CustomerCustomizationItem {
  final String id;
  final String name;
  final double price;
  final String? image;

  const CustomerCustomizationItem({
    required this.id,
    required this.name,
    required this.price,
    this.image,
  });

  factory CustomerCustomizationItem.fromJson(Map<String, dynamic> json) {
    return CustomerCustomizationItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'],
    );
  }
}
