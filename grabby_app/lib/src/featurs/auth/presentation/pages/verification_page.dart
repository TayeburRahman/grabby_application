import '../../../../src_export.dart';

import 'package:pinput/pinput.dart';

class VerificationPage extends StatefulWidget {
  final Map<String, dynamic>? extra;
  const VerificationPage({super.key, this.extra});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerify(BuildContext context) {
    final email = widget.extra?['email'] as String?;
    final type = widget.extra?['type'] as String?;

    if (email == null || _otpController.text.length < 6) return;

    if (type == 'forgot_password') {
      context.read<AuthBloc>().add(
            VerifyForgotOtpEvent(
              email: email,
              activationCode: _otpController.text,
            ),
          );
    } else {
      context.read<AuthBloc>().add(
            VerifyOtpEvent(
              email: email,
              activationCode: _otpController.text,
            ),
          );
    }
  }

  void _onResend(BuildContext context) {
    final email = widget.extra?['email'] as String?;
    final type = widget.extra?['type'] as String?;

    if (email == null) return;

    if (type == 'forgot_password') {
      context.read<AuthBloc>().add(ResendForgotCodeEvent(email: email));
    } else {
      context.read<AuthBloc>().add(ResendOtpEvent(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final email = widget.extra?['email'] as String? ?? '';
    final type = widget.extra?['type'] as String? ?? 'signup';

    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text(AppStaticStrings.verification)),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is VerifyOtpSuccess) {
              CustomSnackbar.show(context, state.message);
              // Save tokens if available
              if (state.loginData != null) {
                final localStorage = sl<LocalStorageService>();
                localStorage.saveAccessToken(state.loginData!.accessToken);
                localStorage.saveRefreshToken(state.loginData!.refreshToken);
              }
              
              if (type == 'forgot_password') {
                context.pushNamed(
                  RoutesPath.resetPasswordPath,
                  extra: {'email': email, 'code': _otpController.text},
                );
              } else {
                // Determine and persist role
                final roleStr = widget.extra?['role'] as String? ?? 'customer';
                UserRole userRole = roleStr == 'shop' ? UserRole.shop : UserRole.customer;
                
                // Update storage and bloc state
                sl<OnboardingLocalDataSource>().saveUserRole(userRole);
                sl<OnboardingSplashBloc>().updateSelectedRole(userRole);

                if (userRole == UserRole.shop) {
                  context.goNamed(RoutesPath.businessInfoPath);
                } else {
                  context.goNamed(RoutesPath.navigationPath);
                }
              }
            } else if (state is OtpSentSuccess) {
              CustomSnackbar.show(context, state.message);
            } else if (state is AuthFailure) {
              CustomSnackbar.show(context, state.message, isError: true);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: AppPadding.getPadding12(context),
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      AppStaticStrings.verifyYourAccount,
                      variant: TextVariant.headlineLarge,
                    ),
                    CustomText(
                      "${AppStaticStrings.sentVerificationCode} to $email",
                      variant: TextVariant.labelMedium,
                      textAlign: TextAlign.center,
                      color: AppColors.kSecondaryTextColor,
                    ),

                    SvgPicture.asset(ImagesConstant.kVerifyAccImg),

                    space4H,

                    /// 🔹 OTP FIELD
                    Pinput(
                      controller: _otpController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1.5,
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                      onCompleted: (pin) => _onVerify(context),
                    ),

                    space4H,

                    CustomButton(
                      text: AppStaticStrings.verifyCode,
                      isLoading: isLoading,
                      onPressed: () => _onVerify(context),
                    ),
                    ButtonTapWidget(
                      onTap: () => _onResend(context),
                      child: CustomText(
                        AppStaticStrings.didntGetCode,
                        variant: TextVariant.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
