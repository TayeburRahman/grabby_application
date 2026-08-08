import 'dart:io';
import '../../../../src_export.dart';

abstract class ProfileRepository {
  Future<ApiResponse<ProfileData>> getProfile();
  Future<ApiResponse<void>> updateProfile({
    required String name,
    File? profileImage,
    String? email,
    String? phoneNumber,
    String? shopName,
    String? shopLicenseNumber,
    String? contactEmail,
    String? contactPhone,
    String? addressName,
    double? lat,
    double? lon,
  });
  Future<ApiResponse<void>> updateUserLocation({
    required String addressName,
    required double lat,
    required double lon,
  });
  Future<ApiResponse<Map<String, dynamic>>> getStripeConnectOnboardingLink();
  Future<ApiResponse<Map<String, dynamic>>> getStripeConnectStatus();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<ProfileData>> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getStripeConnectOnboardingLink() async {
    return await remoteDataSource.getStripeConnectOnboardingLink();
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getStripeConnectStatus() async {
    return await remoteDataSource.getStripeConnectStatus();
  }


  @override
  Future<ApiResponse<void>> updateProfile({
    required String name,
    File? profileImage,
    String? email,
    String? phoneNumber,
    String? shopName,
    String? shopLicenseNumber,
    String? contactEmail,
    String? contactPhone,
    String? addressName,
    double? lat,
    double? lon,
  }) async {
    return await remoteDataSource.updateProfile(
      name: name,
      profileImage: profileImage,
      email: email,
      phoneNumber: phoneNumber,
      shopName: shopName,
      shopLicenseNumber: shopLicenseNumber,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      addressName: addressName,
      lat: lat,
      lon: lon,
    );
  }

  @override
  Future<ApiResponse<void>> updateUserLocation({
    required String addressName,
    required double lat,
    required double lon,
  }) async {
    return await remoteDataSource.updateUserLocation(
      addressName: addressName,
      lat: lat,
      lon: lon,
    );
  }
}
