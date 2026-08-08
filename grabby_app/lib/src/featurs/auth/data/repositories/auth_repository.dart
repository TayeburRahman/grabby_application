import 'dart:io';

import '../../../../src_export.dart';

abstract class AuthRepository {
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
