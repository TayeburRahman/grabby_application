import 'dart:io';
import '../../../../src_export.dart';
import 'package:dio/dio.dart' as dio;

abstract class ProfileRemoteDataSource {
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
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  ProfileRemoteDataSourceImpl(this.apiService, this.localStorageService);

  @override
  Future<ApiResponse<ProfileData>> getProfile() async {
    return await apiService.get<ProfileData>(
      ApiEndpoints.profile,
      fromJson: (json) =>
          ProfileData.fromJson(json['data'] as Map<String, dynamic>),
    );
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
    try {
      final Map<String, dynamic> data = {"name": name};
      final role = localStorageService.getUserRoleFromToken();
      final endpoint = role == 'SHOP_OWNER'
          ? ApiEndpoints.updateShopOwnerProfile
          : ApiEndpoints.updateProfile;

      if (role == 'SHOP_OWNER') {
        if (email != null) data["email"] = email;
        if (phoneNumber != null) data["phone_number"] = phoneNumber;
        if (shopName != null) data["shop_name"] = shopName;
        if (shopLicenseNumber != null)
          data["shop_license_number"] = shopLicenseNumber;
        if (contactEmail != null) data["contact_email"] = contactEmail;
        if (contactPhone != null) data["contact_phone"] = contactPhone;
      } else {
        // Customer profile update can include location
        if (addressName != null) data["addressName"] = addressName;
        if (lat != null) data["lat"] = lat;
        if (lon != null) data["lon"] = lon;
      }

      if (profileImage != null) {
        data["profile_image"] = await dio.MultipartFile.fromFile(
          profileImage.path,
          filename: profileImage.path.split('/').last,
        );
      }
      
      print('Sending profile update to $endpoint');
      print('Payload data: $data');

      if (profileImage != null) {
        final formData = dio.FormData.fromMap(data);
        return await apiService.patch<void>(endpoint, data: formData);
      } else {
        return await apiService.patch<void>(endpoint, data: data);
      }
    } catch (e) {
      print('Error in updateProfile: $e');
      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> updateUserLocation({
    required String addressName,
    required double lat,
    required double lon,
  }) async {
    try {
      Map<String, dynamic> data = {
        "addressName": addressName,
        "lat": lat,
        "lon": lon,
      };

      String endpoint = ApiEndpoints.updateUserLocation;

      print('Updating user location at $endpoint');
      print('Payload data: $data');

      final role = localStorageService.getUserRoleFromToken();
      if (role == 'SHOP_OWNER') {
        endpoint = ApiEndpoints.updateShopOwnerLocation;
        data = {"address": addressName, "lat": lat, "lng": lon};
        return await apiService.post<void>(endpoint, data: data);
      }

      return await apiService.patch<void>(endpoint, data: data);
    } catch (e) {
      print('Error in updateUserLocation: $e');
      rethrow;
    }
  }
}
