part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;
  RegisterSuccess({required this.message});
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

class LoginSuccess extends AuthState {
  final LoginResponseData loginData;
  final String message;
  LoginSuccess({required this.loginData, required this.message});
}

class OtpSentSuccess extends AuthState {
  final String message;
  OtpSentSuccess({required this.message});
}

class VerifyOtpSuccess extends AuthState {
  final LoginResponseData? loginData;
  final String message;
  VerifyOtpSuccess({this.loginData, required this.message});
}

class ForgotPasswordSuccess extends AuthState {
  final String message;
  ForgotPasswordSuccess({required this.message});
}

class ChangePasswordSuccess extends AuthState {
  final String message;
  ChangePasswordSuccess({required this.message});
}

class BusinessInfoSuccess extends AuthState {
  final String message;
  BusinessInfoSuccess({required this.message});
}

class SaveBranchesSuccess extends AuthState {
  final String message;
  SaveBranchesSuccess({required this.message});
}

class SaveBusinessDocumentsSuccess extends AuthState {
  final String message;
  SaveBusinessDocumentsSuccess({required this.message});
}
