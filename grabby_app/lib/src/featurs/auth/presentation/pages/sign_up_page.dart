import 'package:flutter/foundation.dart';

import '../../../../src_export.dart';

class SignUpPage extends StatefulWidget {
  final Map<String, dynamic>? extra;
  const SignUpPage({super.key, this.extra});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(
    text: kDebugMode ? "Sadia Binte" : "",
  );
  final _emailController = TextEditingController(
    text: kDebugMode ? "xiviho6107@agoalz.com" : "",
  );
  final _phoneController = TextEditingController(
    text: kDebugMode ? "+971501234567" : "+971",
  );
  final _passwordController = TextEditingController(
    text: kDebugMode ? "123456" : "",
  );
  final _confirmPasswordController = TextEditingController(
    text: kDebugMode ? "123456" : "",
  );
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (!_termsAccepted) {
        CustomSnackbar.show(
          context,
          'Please accept the terms and conditions',
          isError: true,
        );
        return;
      }
      final role = widget.extra?['role'] as String? ?? 'customer';
      if (role == 'shop') {
        context.read<AuthBloc>().add(
          RegisterShopOwnerEvent(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            termsAccepted: _termsAccepted,
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          RegisterCustomerEvent(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            termsAccepted: _termsAccepted,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              // Show success message then navigate to verification
              CustomSnackbar.show(context, state.message);
              context.pushNamed(
                RoutesPath.verificationPath,
                extra: {
                  'email': _emailController.text.trim(),
                  'type': 'signup',
                  'role': widget.extra?['role'] ?? 'customer',
                },
              );
            } else if (state is AuthFailure) {
              CustomSnackbar.show(context, state.message, isError: true);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: AppPadding.getPadding12(context).copyWith(top: 0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        CustomText(
                          AppStaticStrings.signUp,
                          variant: TextVariant.headlineLarge,
                        ),
                        CustomText(
                          AppStaticStrings.letsGetYouSetUp,
                          variant: TextVariant.titleSmall,
                          color: AppColors.kBlueColor,
                        ),
                        space6H,
                        CustomTextField(
                          title: AppStaticStrings.preferredName,
                          hintText: AppStaticStrings.preferredName,
                          textEditingController: _nameController,
                          isRequired: true,
                        ),
                        CustomTextField(
                          title: AppStaticStrings.email,
                          hintText: AppStaticStrings.email,
                          textEditingController: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStaticStrings.required;
                            }
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          title: AppStaticStrings.phoneNumber,
                          hintText: AppStaticStrings.phoneNumber,
                          keyboardType: TextInputType.phone,
                          textEditingController: _phoneController,
                          isRequired: true,
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
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          title: AppStaticStrings.confirmPassword,
                          hintText: AppStaticStrings.confirmPassword,
                          isPassword: true,
                          textEditingController: _confirmPasswordController,
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStaticStrings.required;
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _termsAccepted,
                              onChanged: (value) => setState(
                                () => _termsAccepted = value ?? false,
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                children: [
                                  CustomText(
                                    AppStaticStrings.iHaveReadAndAgree,
                                  ),
                                  ButtonTapWidget(
                                    onTap: () {
                                      context.pushNamed(
                                        RoutesPath.termsAndConditionsPath,
                                      );
                                    },
                                    child: CustomText(
                                      AppStaticStrings.termsAndConditions,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                  // CustomText(AppStaticStrings.and),
                                  // ButtonTapWidget(
                                  //   onTap: () {
                                  //     // TODO: Navigate to Privacy Policy
                                  //   },
                                  //   child: CustomText(
                                  //     AppStaticStrings.privacyPolicy,
                                  //     color: AppColors.kPrimaryColor,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        CustomButton(
                          text: AppStaticStrings.signUp,
                          isLoading: isLoading,
                          onPressed: () => _onSignUp(context),
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
