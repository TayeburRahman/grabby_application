class ShopAdModel {
  final String branchId;
  final AdShopOwner shopOwner;
  final List<AdMenu> topRatedMenus;

  ShopAdModel({
    required this.branchId,
    required this.shopOwner,
    required this.topRatedMenus,
  });

  factory ShopAdModel.fromJson(Map<String, dynamic> json) {
    return ShopAdModel(
      branchId: json['branchId'] ?? '',
      shopOwner: AdShopOwner.fromJson(json['shopOwner'] ?? {}),
      topRatedMenus: (json['topRatedMenus'] as List? ?? [])
          .map((e) => AdMenu.fromJson(e))
          .toList(),
    );
  }
}

class AdShopOwner {
  final String? profileImage;
  final String name;
  final String phoneNumber;

  AdShopOwner({
    this.profileImage,
    required this.name,
    required this.phoneNumber,
  });

  factory AdShopOwner.fromJson(Map<String, dynamic> json) {
    return AdShopOwner(
      profileImage: json['profile_image'],
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}

class AdMenu {
  final String id;
  final String itemName;
  final double price;
  final String? image;
  final String? description;

  AdMenu({
    required this.id,
    required this.itemName,
    required this.price,
    this.image,
    this.description,
  });

  factory AdMenu.fromJson(Map<String, dynamic> json) {
    return AdMenu(
      id: json['_id'] ?? '',
      itemName: json['itemName'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'],
      description: json['description'],
    );
  }
}
