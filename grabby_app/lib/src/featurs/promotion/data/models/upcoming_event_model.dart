class UpcomingEventModel {
  final String id;
  final String name;
  final List<String> icons;
  final String startDate;
  final String endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UpcomingEventModel({
    required this.id,
    required this.name,
    required this.icons,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpcomingEventModel.fromJson(Map<String, dynamic> json) {
    return UpcomingEventModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      icons: List<String>.from(json['icons'] as List),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'icons': icons,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
