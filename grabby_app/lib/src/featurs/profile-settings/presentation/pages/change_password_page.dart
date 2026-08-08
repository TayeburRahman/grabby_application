import '../../../../src_export.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.pop();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.kRedColor,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        appBar: AppBar(
          title: const Text(AppStaticStrings.changePassword),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.kTextColor),
          ),
        ),
        body: SingleChildScrollView(
          padding: AppPadding.getPadding12(context),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                _buildField(
                  label: AppStaticStrings.typePassword,
                  hint: "••••••••",
                  controller: _oldPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.required;
                    }
                    return null;
                  },
                ),
                _buildField(
                  label: AppStaticStrings.newPassword,
                  hint: "••••••••",
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.required;
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                _buildField(
                  label: AppStaticStrings.newConfirmPassword,
                  hint: "••••••••",
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStaticStrings.required;
                    }
                    if (value != _newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: AppStaticStrings.update,
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                ChangePasswordEvent(
                                  oldPassword: _oldPasswordController.text,
                                  newPassword: _newPasswordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text,
                                ),
                              );
                        }
                      },
                      backgroundColor: AppColors.kPrimaryColor,
                      borderRadius: 12,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
   FormFieldValidator<dynamic>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        CustomText(label, fontSize: 14, fontWeight: FontWeight.w500),
        CustomTextField(
          textEditingController: controller,
          hintText: hint,
          validator: validator,
          suffixIcon: const Icon(
            Icons.visibility_off_outlined,
            color: AppColors.kSecondaryTextColor,
            size: 20,
          ),
          isPassword: true,
        ),
      ],
    );
  }
}
