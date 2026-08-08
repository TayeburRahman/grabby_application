part of 'auth_bloc.dart';

abstract class AuthEvent {}

class RegisterCustomerEvent extends AuthEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final bool termsAccepted;

  RegisterCustomerEvent({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.termsAccepted,
  });
}

class RegisterShopOwnerEvent extends AuthEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final bool termsAccepted;

  RegisterShopOwnerEvent({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.termsAccepted,
  });
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String activationCode;

  VerifyOtpEvent({required this.email, required this.activationCode});
}

class ResendOtpEvent extends AuthEvent {
  final String email;

  ResendOtpEvent({required this.email});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
}

class ResendForgotCodeEvent extends AuthEvent {
  final String email;

  ResendForgotCodeEvent({required this.email});
}

class VerifyForgotOtpEvent extends AuthEvent {
  final String email;
  final String activationCode;

  VerifyForgotOtpEvent({required this.email, required this.activationCode});
}

class ChangePasswordEvent extends AuthEvent {
  final String? oldPassword;
  final String? email;
  final String? code;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordEvent({
    this.oldPassword,
    this.email,
    this.code,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class SaveBusinessInfoEvent extends AuthEvent {
  final String shopName;
  final String shopLicenseNumber;
  final String contactEmail;
  final String contactPhone;

  SaveBusinessInfoEvent({
    required this.shopName,
    required this.shopLicenseNumber,
    required this.contactEmail,
    required this.contactPhone,
  });
}

class SaveBranchesEvent extends AuthEvent {
  final List<BranchModel> branches;

  SaveBranchesEvent({required this.branches});
}

class SaveBusinessDocumentsEvent extends AuthEvent {
  final File businessLicense;
  final File shopLogo;

  SaveBusinessDocumentsEvent({
    required this.businessLicense,
    required this.shopLogo,
  });
}
