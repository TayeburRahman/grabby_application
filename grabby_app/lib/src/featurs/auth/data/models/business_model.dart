class BranchModel {
  final String branchName;
  final String address;
  final double lat;
  final double lng;
  final String phoneNumber;
  final bool applyMenuForAll;

  BranchModel({
    required this.branchName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.phoneNumber,
    this.applyMenuForAll = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "branch_name": branchName,
      "address": address,
      "lat": lat,
      "lng": lng,
      "phone_number": phoneNumber,
      "applyMenuForAll": applyMenuForAll,
    };
  }

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchName: json['branch_name'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      phoneNumber: json['phone_number'] as String,
      applyMenuForAll: json['applyMenuForAll'] as bool? ?? false,
    );
  }
}
