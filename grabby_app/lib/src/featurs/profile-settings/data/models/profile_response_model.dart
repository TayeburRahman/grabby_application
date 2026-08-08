class ProfileResponseModel {
  final int statusCode;
  final bool success;
  final String message;
  final ProfileData? data;

  ProfileResponseModel({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final String id;
  final AuthId authId;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String? businessLicense;
  final String? shopLogo;
  final int? registrationStep;
  final String? approvalStatus;
  final String? addressName;
  final double? lat;
  final double? lon;
  final String? contactEmail;
  final String? contactPhone;
  final String? shopLicenseNumber;
  final String? shopName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileData({
    required this.id,
    required this.authId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    this.businessLicense,
    this.shopLogo,
    this.registrationStep,
    this.approvalStatus,
    this.addressName,
    this.lat,
    this.lon,
    this.contactEmail,
    this.contactPhone,
    this.shopLicenseNumber,
    this.shopName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    return ProfileData(
      id: json['_id'] ?? '',
      authId: json['authId'] != null 
          ? AuthId.fromJson(json['authId']) 
          : AuthId(id: '', role: 'CUSTOMER'),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profileImage: json['profile_image'],
      businessLicense: json['business_license'],
      shopLogo: json['shop_logo'],
      registrationStep: json['registration_step'],
      approvalStatus: json['approval_status'],
      addressName: location?['address'] ?? json['addressName'],
      lat: (location?['lat'] as num?)?.toDouble() ?? (json['lat'] as num?)?.toDouble(),
      lon: (location?['lng'] as num?)?.toDouble() ?? (json['lon'] as num?)?.toDouble(),
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      shopLicenseNumber: json['shop_license_number'],
      shopName: json['shop_name'],
      status: json['status'] ?? 'inactive',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}

class AuthId {
  final String id;
  final String role;

  AuthId({required this.id, required this.role});

  factory AuthId.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AuthId(id: '', role: 'CUSTOMER');
    return AuthId(
      id: json['_id'] ?? '',
      role: json['role'] ?? 'CUSTOMER',
    );
  }
}
