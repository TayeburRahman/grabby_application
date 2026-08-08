
class FeeStructureModel {
  final String id;
  final String title;
  final String description;

  FeeStructureModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory FeeStructureModel.fromJson(Map<String, dynamic> json) {
    return FeeStructureModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
