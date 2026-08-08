import '../../../../src_export.dart';

class ResetPasswordPage extends StatefulWidget {
  final Map<String, dynamic>? extra;
  const ResetPasswordPage({super.key, this.extra});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onChangePassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = widget.extra?['email'] as String?;
      final code = widget.extra?['code'] as String?;

      context.read<AuthBloc>().add(
            ChangePasswordEvent(
              email: email,
              code: code,
              oldPassword: _oldPasswordController.text,
              newPassword: _newPasswordController.text,
              confirmPassword: _confirmPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isResetFlow = widget.extra != null && widget.extra!['email'] != null;

    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            CustomSnackbar.show(context, state.message);
            if (isResetFlow) {
              context.goNamed(RoutesPath.loginPath);
            } else {
              context.pop();
            }
          } else if (state is AuthFailure) {
            CustomSnackbar.show(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            appBar: AppBar(
              title: Text(isResetFlow
                  ? AppStaticStrings.resetPassword
                  : AppStaticStrings.changePassword),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: AppPadding.getPadding12(context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isResetFlow) ...[
                        CustomTextField(
                          textEditingController: _oldPasswordController,
                          title: AppStaticStrings.oldPassword,
                          hintText: AppStaticStrings.oldPassword,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStaticStrings.required;
                            }
                            return null;
                          },
                        ),
                        space12H,
                      ],
                      CustomTextField(
                        textEditingController: _newPasswordController,
                        title: AppStaticStrings.enterNewPassword,
                        hintText: AppStaticStrings.enterNewPassword,
                        isPassword: true,
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
                      space12H,
                      CustomTextField(
                        textEditingController: _confirmPasswordController,
                        title: AppStaticStrings.confirmPassword,
                        hintText: AppStaticStrings.confirmPassword,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStaticStrings.required;
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      space24H,
                      CustomButton(
                        text: AppStaticStrings.continueText,
                        isLoading: isLoading,
                        onPressed: () => _onChangePassword(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
