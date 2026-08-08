import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../src_export.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<void>> registerCustomer({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required bool termsAccepted,
  });

  Future<ApiResponse<void>> registerShopOwner({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required bool termsAccepted,
  });

  Future<ApiResponse<LoginResponseData>> login({
    required String email,
    required String password,
  });

  Future<ApiResponse<LoginResponseData>> verifyOtp({
    required String email,
    required String activationCode,
  });

  Future<ApiResponse<void>> resendOtp({required String email});

  Future<ApiResponse<void>> forgotPassword({required String email});

  Future<ApiResponse<void>> resendForgotCode({required String email});

  Future<ApiResponse<void>> verifyForgotOtp({
    required String email,
    required String activationCode,
  });

  Future<ApiResponse<void>> changePassword({
    String? oldPassword,
    String? email,
    String? code,
    required String newPassword,
    required String confirmPassword,
  });

  Future<ApiResponse<void>> saveBusinessInfo({
    required String shopName,
    required String shopLicenseNumber,
    required String contactEmail,
    required String contactPhone,
  });

  Future<ApiResponse<void>> saveBranches({required List<BranchModel> branches});

  Future<ApiResponse<void>> saveBusinessDocuments({
    required File businessLicense,
    required File shopLogo,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<void>> registerCustomer({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required bool termsAccepted,
  }) async {
    return await _apiService.post<void>(
      ApiEndpoints.customerRegister,
      data: {
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
        "confirmPassword": confirmPassword,
        "termsAccepted": termsAccepted,
      },
    );
  }

  @override
  Future<ApiResponse<void>> registerShopOwner({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required bool termsAccepted,
  }) async {
    return await _apiService.post<void>(
      ApiEndpoints.shopOwnerRegister,
      data: {
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
        "confirmPassword": confirmPassword,
        "termsAccepted": termsAccepted,
      },
    );
  }

  @override
  Future<ApiResponse<LoginResponseData>> login({
    required String email,
    required String password,
  }) async {
    return await _apiService.post<LoginResponseData>(
      ApiEndpoints.customerLogin,
      data: {"email": email, "password": password},
      fromJson: (json) =>
          LoginResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<LoginResponseData>> verifyOtp({
    required String email,
    required String activationCode,
  }) async {
    return await _apiService.post<LoginResponseData>(
      ApiEndpoints.verifyOtp,
      data: {"email": email, "activation_code": activationCode},
      fromJson: (json) =>
          LoginResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> resendOtp({required String email}) async {
    return await _apiService.post<void>(
      ApiEndpoints.resendOtp,
      data: {"email": email},
    );
  }

  @override
  Future<ApiResponse<void>> forgotPassword({required String email}) async {
    return await _apiService.post<void>(
      ApiEndpoints.forgotPassword,
      data: {"email": email},
    );
  }

  @override
  Future<ApiResponse<void>> resendForgotCode({required String email}) async {
    return await _apiService.post<void>(
      ApiEndpoints.resendForgotCode,
      data: {"email": email},
    );
  }

  @override
  Future<ApiResponse<void>> verifyForgotOtp({
    required String email,
    required String activationCode,
  }) async {
    return await _apiService.post<void>(
      ApiEndpoints.verifyForgotOtp,
      data: {"email": email, "code": activationCode},
    );
  }

  @override
  Future<ApiResponse<void>> changePassword({
    String? oldPassword,
    String? email,
    String? code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final isReset = email != null && code != null;
    return await _apiService.post<void>(
      isReset ? ApiEndpoints.resetPassword : ApiEndpoints.changePassword,
      queryParameters: isReset ? {"email": email} : null,
      data: isReset
          ? {"newPassword": newPassword, "confirmPassword": confirmPassword}
          : {
              "oldPassword": oldPassword,
              "newPassword": newPassword,
              "confirmPassword": confirmPassword,
            },
    );
  }

  @override
  Future<ApiResponse<void>> saveBusinessInfo({
    required String shopName,
    required String shopLicenseNumber,
    required String contactEmail,
    required String contactPhone,
  }) async {
    return await _apiService.post<void>(
      ApiEndpoints.saveBusinessInfo,
      data: {
        "shop_name": shopName,
        "shop_license_number": shopLicenseNumber,
        "contact_email": contactEmail,
        "contact_phone": contactPhone,
      },
    );
  }

  @override
  Future<ApiResponse<void>> saveBranches({
    required List<BranchModel> branches,
  }) async {
    return await _apiService.post<void>(
      ApiEndpoints.saveBranches,
      data: {"branches": branches.map((e) => e.toJson()).toList()},
    );
  }

  @override
  Future<ApiResponse<void>> saveBusinessDocuments({
    required File businessLicense,
    required File shopLogo,
  }) async {
    final formData = FormData.fromMap({
      "business_license": await MultipartFile.fromFile(
        businessLicense.path,
        filename: businessLicense.path.split('/').last,
      ),
      "shop_logo": await MultipartFile.fromFile(
        shopLogo.path,
        filename: shopLogo.path.split('/').last,
      ),
    });

    return await _apiService.post<void>(
      ApiEndpoints.saveBusinessDocuments,
      data: formData,
    );
  }
}
