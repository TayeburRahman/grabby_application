class HelpCenterModel {
  final String id;
  final String phone;

  HelpCenterModel({
    required this.id,
    required this.phone,
  });

  factory HelpCenterModel.fromJson(Map<String, dynamic> json) {
    return HelpCenterModel(
      id: json['_id'] ?? json['id'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
