class CarPlateModel {
  final String id;
  final String customerId;
  final String carNumberSource;
  final String plateCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  CarPlateModel({
    required this.id,
    required this.customerId,
    required this.carNumberSource,
    required this.plateCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CarPlateModel.fromJson(Map<String, dynamic> json) {
    return CarPlateModel(
      id: json['_id'] as String,
      customerId: json['customerId'] as String,
      carNumberSource: json['carNumberSource'] as String,
      plateCode: json['plateCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customerId': customerId,
      'carNumberSource': carNumberSource,
      'plateCode': plateCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
