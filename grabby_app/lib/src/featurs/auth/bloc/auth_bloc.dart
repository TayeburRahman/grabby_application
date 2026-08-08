import 'dart:io';

import '../../../src_export.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<RegisterCustomerEvent>(_onRegisterCustomer);
    on<RegisterShopOwnerEvent>(_onRegisterShopOwner);
    on<LoginEvent>(_onLogin);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResendForgotCodeEvent>(_onResendForgotCode);
    on<VerifyForgotOtpEvent>(_onVerifyForgotOtp);
    on<ChangePasswordEvent>(_onChangePassword);
    on<SaveBusinessInfoEvent>(_onSaveBusinessInfo);
    on<SaveBranchesEvent>(_onSaveBranches);
    on<SaveBusinessDocumentsEvent>(_onSaveBusinessDocuments);
  }

  Future<void> _onRegisterCustomer(
    RegisterCustomerEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.registerCustomer(
        name: event.name,
        email: event.email,
        phoneNumber: event.phoneNumber,
        password: event.password,
        confirmPassword: event.confirmPassword,
        termsAccepted: event.termsAccepted,
      );

      if (response.success) {
        emit(RegisterSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onRegisterShopOwner(
    RegisterShopOwnerEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.registerShopOwner(
        name: event.name,
        email: event.email,
        phoneNumber: event.phoneNumber,
        password: event.password,
        confirmPassword: event.confirmPassword,
        termsAccepted: event.termsAccepted,
      );

      if (response.success) {
        emit(RegisterSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      if (response.success && response.data != null) {
        emit(
          LoginSuccess(loginData: response.data!, message: response.message),
        );
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.verifyOtp(
        email: event.email,
        activationCode: event.activationCode,
      );

      if (response.success) {
        emit(
          VerifyOtpSuccess(loginData: response.data, message: response.message),
        );
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.resendOtp(email: event.email);

      if (response.success) {
        emit(OtpSentSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.forgotPassword(email: event.email);

      if (response.success) {
        emit(ForgotPasswordSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onResendForgotCode(
    ResendForgotCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.resendForgotCode(
        email: event.email,
      );

      if (response.success) {
        emit(OtpSentSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onVerifyForgotOtp(
    VerifyForgotOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.verifyForgotOtp(
        email: event.email,
        activationCode: event.activationCode,
      );

      if (response.success) {
        emit(VerifyOtpSuccess(loginData: null, message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.changePassword(
        oldPassword: event.oldPassword,
        email: event.email,
        code: event.code,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );

      if (response.success) {
        emit(ChangePasswordSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onSaveBusinessInfo(
    SaveBusinessInfoEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.saveBusinessInfo(
        shopName: event.shopName,
        shopLicenseNumber: event.shopLicenseNumber,
        contactEmail: event.contactEmail,
        contactPhone: event.contactPhone,
      );

      if (response.success) {
        emit(BusinessInfoSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onSaveBranches(
    SaveBranchesEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.saveBranches(
        branches: event.branches,
      );

      if (response.success) {
        emit(SaveBranchesSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }

  Future<void> _onSaveBusinessDocuments(
    SaveBusinessDocumentsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.saveBusinessDocuments(
        businessLicense: event.businessLicense,
        shopLogo: event.shopLogo,
      );

      if (response.success) {
        emit(SaveBusinessDocumentsSuccess(message: response.message));
      } else {
        emit(AuthFailure(message: response.message));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'Something went wrong. Please try again.'));
    }
  }
}
