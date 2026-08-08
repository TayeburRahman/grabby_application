import 'package:flutter/foundation.dart';

import '../../../../src_export.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(
    text: kDebugMode ? "sayor98367@algarr.com" : "",
  );
  // final _emailController = TextEditingController(
  //   text: kDebugMode ? "lolini5440@bpotogo.com" : "",
  // );

  final _passwordController = TextEditingController(
    text: kDebugMode ? "123456" : "",
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text(AppStaticStrings.loginAccount)),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              // Save tokens locally
              final localStorage = sl<LocalStorageService>();
              await localStorage.saveAccessToken(state.loginData.accessToken);
              await localStorage.saveRefreshToken(state.loginData.refreshToken);

              // Extract and persist the actual role from the token
              final roleStr = localStorage.getUserRoleFromToken();
              UserRole userRole = UserRole.customer;

              if (roleStr == 'SHOP_OWNER') {
                userRole = UserRole.shop;
              } else {
                userRole = UserRole.customer;
              }

              // Update data source so the role is remembered on app restart
              await sl<OnboardingLocalDataSource>().saveUserRole(userRole);

              // Update the bloc's current selection state
              sl<OnboardingSplashBloc>().selectedRole = userRole;

              if (context.mounted) {
                CustomSnackbar.show(context, state.message);

                // Navigate based on the actual verified role
                if (userRole == UserRole.shop) {
                  context.goNamed(RoutesPath.shopNavigationPath);
                } else {
                  context.goNamed(RoutesPath.navigationPath);
                }
              }
            } else if (state is AuthFailure) {
              CustomSnackbar.show(context, state.message, isError: true);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: AppPadding.getPadding12(context),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12,
                      children: [
                        SvgPicture.asset(ImagesConstant.kLoginImg),
                        CustomText(
                          AppStaticStrings.gladToMeetYouAgain,
                          variant: TextVariant.headlineLarge,
                        ),
                        space6H,
                        CustomTextField(
                          title: AppStaticStrings.emailAddressOrPhoneNumber,
                          hintText: AppStaticStrings.emailAddressOrPhoneNumber,
                          textEditingController: _emailController,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStaticStrings.required;
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          title: AppStaticStrings.password,
                          hintText: AppStaticStrings.password,
                          isPassword: true,
                          textEditingController: _passwordController,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStaticStrings.required;
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: AlignmentGeometry.topRight,
                          child: ButtonTapWidget(
                            onTap: () {
                              context.pushNamed(RoutesPath.forgotPasswordPath);
                            },
                            child: CustomText(
                              AppStaticStrings.forgotThePassword,
                              color: AppColors.kSecondaryColor,
                              variant: TextVariant.titleSmall,
                            ),
                          ),
                        ),
                        CustomButton(
                          text: AppStaticStrings.logIn,
                          isLoading: isLoading,
                          onPressed: () => _onLogin(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            CustomText(
                              AppStaticStrings.dontHaveAnAccount,
                              variant: TextVariant.labelMedium,
                            ),
                            ButtonTapWidget(
                              onTap: () {
                                context.pushNamed(RoutesPath.roleSelectionPath);
                              },
                              child: CustomText(
                                AppStaticStrings.signUp,
                                color: AppColors.kPrimaryColor,
                                variant: TextVariant.labelMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
