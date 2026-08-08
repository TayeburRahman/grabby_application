import 'package:flutter/foundation.dart';

import '../../../../src_export.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(
    text: kDebugMode ? "sayor98367@algarr.com" : "",
  );

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendCode(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ForgotPasswordEvent(email: _emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text(AppStaticStrings.forgotPassword)),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              CustomSnackbar.show(context, state.message);
              context.pushNamed(
                RoutesPath.verificationPath,
                extra: {
                  'email': _emailController.text.trim(),
                  'type': 'forgot_password',
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
                padding: AppPadding.getPadding12(context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(ImagesConstant.kForgetPassImg),
                      space12H,
                      CustomText(
                        AppStaticStrings.enterYourEmail,
                        variant: TextVariant.labelLarge,
                        color: AppColors.kSecondaryTextColor,
                        textAlign: TextAlign.center,
                      ),
                      space12H,
                      CustomTextField(
                        title: AppStaticStrings.email,
                        hintText: AppStaticStrings.enterYourEmailHint,
                        textEditingController: _emailController,
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStaticStrings.required;
                          }
                          return null;
                        },
                      ),
                      space12H,
                      CustomButton(
                        text: AppStaticStrings.sendCode,
                        isLoading: isLoading,
                        onPressed: () => _onSendCode(context),
                      ),
                    ],
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
