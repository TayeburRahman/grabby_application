class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String recipient;
  final String role;
  final String orderId;
  final bool isRead;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.recipient,
    required this.role,
    required this.orderId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      recipient: json['recipient'] ?? '',
      role: json['role'] ?? '',
      orderId: json['orderId'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'recipient': recipient,
      'role': role,
      'orderId': orderId,
      'isRead': isRead,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
