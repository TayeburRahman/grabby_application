class MenuCategoryModel {
  final String id;
  final String name;
  final bool isStampActive;
  final String shopOwnerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuCategoryModel({
    required this.id,
    required this.isStampActive,
    required this.name,
    required this.shopOwnerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['_id']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      isStampActive: json['stampActive'] ?? false,
      shopOwnerId: json['shopOwnerId']?.toString() ?? "",
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'stampActive': isStampActive,
      'shopOwnerId': shopOwnerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuCategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
