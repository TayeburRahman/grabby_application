class TermsAndConditionsModel {
  final String id;
  final String content;

  TermsAndConditionsModel({
    required this.id,
    required this.content,
  });

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsModel(
      id: json['_id'] ?? json['id'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
