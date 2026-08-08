class PromotionModel {
  final String id;
  final String discountName;
  final String? eventName;
  final DateTime startDate;
  final DateTime endDate;
  final String appliedOn; // 'all' or 'specific'
  final List<SpecificItem> specificItems;
  final String discountType; // 'percentage' or 'fixed'
  final double discountValue;
  final bool isActive;
  final String shopOwnerId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PromotionModel({
    required this.id,
    required this.discountName,
    this.eventName,
    required this.startDate,
    required this.endDate,
    required this.appliedOn,
    required this.specificItems,
    required this.discountType,
    required this.discountValue,
    required this.isActive,
    required this.shopOwnerId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    final subscription = json['subscription'] as Map<String, dynamic>?;

    // Safely extract the raw list from either location
    final List<dynamic> specificItemsRaw =
        (subscription?['specificItems'] ?? json['specificItems'] ?? []) as List<dynamic>;

    return PromotionModel(
      id: json['_id'] ?? '',
      discountName: json['discountName'] ?? '',
      eventName: json['eventName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      appliedOn: subscription?['appliedOn'] ?? json['appliedOn'] ?? 'all',
      specificItems: specificItemsRaw.map((e) {
        if (e is String) {
          return SpecificItem(id: e, itemName: '', price: 0);
        }
        return SpecificItem.fromJson(e as Map<String, dynamic>);
      }).toList(),
      discountType: json['discountType'] ?? 'percentage',
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? false,
      shopOwnerId: json['shopOwnerId'] is Map
          ? json['shopOwnerId']['_id'] ?? ''
          : json['shopOwnerId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discountName': discountName,
      'eventName': eventName,
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      'appliedOn': appliedOn,
      'specificItems': specificItems.map((e) => e.id).toList(),
      'discountType': discountType,
      'discountValue': discountValue,
      'isActive': isActive,
    };
  }
}

class SpecificItem {
  final String id;
  final String itemName;
  final double price;

  const SpecificItem({
    required this.id,
    required this.itemName,
    required this.price,
  });

  factory SpecificItem.fromJson(Map<String, dynamic> json) {
    return SpecificItem(
      id: json['_id'] ?? '',
      itemName: json['itemName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class PromotionListResponse {
  final int page;
  final int limit;
  final int total;
  final int totalPage;
  final List<PromotionModel> data;

  const PromotionListResponse({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
    required this.data,
  });

  factory PromotionListResponse.fromJson(Map<String, dynamic> json) {
    return PromotionListResponse(
      page: json['meta']['page'] ?? 1,
      limit: json['meta']['limit'] ?? 10,
      total: json['meta']['total'] ?? 0,
      totalPage: json['meta']['totalPage'] ?? 1,
      data: (json['data'] as List<dynamic>)
          .map((e) => PromotionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}