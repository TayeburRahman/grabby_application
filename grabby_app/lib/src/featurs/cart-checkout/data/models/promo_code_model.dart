
class PromoCodeModel {
  final bool isValid;
  final String code;
  final String status;
  final double discountPercent;
  final String cartId;
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;
  final String message;

  PromoCodeModel({
    required this.isValid,
    required this.code,
    required this.status,
    required this.discountPercent,
    required this.cartId,
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    required this.message,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      isValid: json['isValid'] ?? false,
      code: json['code'] ?? '',
      status: json['status'] ?? '',
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
      cartId: json['cartId'] ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'code': code,
      'status': status,
      'discountPercent': discountPercent,
      'cartId': cartId,
      'originalPrice': originalPrice,
      'discountAmount': discountAmount,
      'finalPrice': finalPrice,
      'message': message,
    };
  }
}
