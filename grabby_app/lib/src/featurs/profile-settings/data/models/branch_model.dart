class BranchAvailabilityModel {
  final String day;
  final String open;
  final String close;
  final bool isClosed;

  const BranchAvailabilityModel({
    required this.day,
    required this.open,
    required this.close,
    required this.isClosed,
  });

  factory BranchAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return BranchAvailabilityModel(
      day: json['day'] ?? '',
      open: json['open'] ?? '',
      close: json['close'] ?? '',
      isClosed: json['isClosed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'day': day, 'open': open, 'close': close, 'isClosed': isClosed};
  }

  BranchAvailabilityModel copyWith({
    String? day,
    String? open,
    String? close,
    bool? isClosed,
  }) {
    return BranchAvailabilityModel(
      day: day ?? this.day,
      open: open ?? this.open,
      close: close ?? this.close,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  // @override
  // List<Object?> get props => [day, open, close, isClosed];
}

class ShopBranchModel {
  final String id;
  final String shopOwnerId;
  final String branchName;
  final String address;
  final double lat;
  final double lng;
  final String phoneNumber;
  final List<BranchAvailabilityModel> availability;
  final bool applyMenuForAll;

  const ShopBranchModel({
    required this.id,
    required this.shopOwnerId,
    required this.branchName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.phoneNumber,
    required this.availability,
    required this.applyMenuForAll,
  });

  factory ShopBranchModel.fromJson(Map<String, dynamic> json) {
    return ShopBranchModel(
      id: json['_id'] ?? '',
      shopOwnerId: json['shopOwnerId'] ?? '',
      branchName: json['branch_name'] ?? '',
      address: json['address'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      phoneNumber: json['phone_number'] ?? '',
      availability:
          (json['availability'] as List<dynamic>?)
              ?.map(
                (e) =>
                    BranchAvailabilityModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      applyMenuForAll: json['applyMenuForAll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch_name': branchName,
      'address': address,
      'lat': lat,
      'lng': lng,
      'phone_number': phoneNumber,
      'applyMenuForAll': applyMenuForAll,
    };
  }

  // @override
  // List<Object?> get props => [
  //       id,
  //       shopOwnerId,
  //       branchName,
  //       address,
  //       lat,
  //       lng,
  //       phoneNumber,
  //       availability,
  //       applyMenuForAll,
  //     ];
}
