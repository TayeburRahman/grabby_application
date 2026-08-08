class WalletModel {
  final double pointWallet;
  final double credWallet;
  final String id;

  WalletModel({
    required this.pointWallet,
    required this.credWallet,
    required this.id,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      pointWallet: (json['pointWallet'] ?? 0.0).toDouble(),
      credWallet: (json['credWallet'] ?? 0.0).toDouble(),
      id: json['_id'] ?? '',
    );
  }
}
