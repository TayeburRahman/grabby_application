import '../../../../src_export.dart';

class BusinessInfoPage extends StatefulWidget {
  const BusinessInfoPage({super.key});

  @override
  State<BusinessInfoPage> createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends State<BusinessInfoPage> {
  final _shopNameController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _shopNameController.dispose();
    _licenseNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            AppStaticStrings.businessInformation,
            variant: TextVariant.titleLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is BusinessInfoSuccess) {
              context.push(RoutesPath.branchLocationsPath);
            } else if (state is AuthFailure) {
              CustomSnackbar.show(context, state.message, isError: true);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const OnboardingProgressBar(currentStep: 1),
                  Padding(
                    padding: AppPadding.getPadding12(context),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          AppStaticStrings.businessInformation,
                          variant: TextVariant.titleMedium,
                          fontWeight: FontWeight.bold,
                        ),
                        _buildField(
                          context,
                          label: AppStaticStrings.shopName,
                          hint: AppStaticStrings.enterYourShopName,
                          controller: _shopNameController,
                        ),
                        _buildField(
                          context,
                          label: AppStaticStrings.shopLicenseNumber,
                          hint: AppStaticStrings.enterYourShopName,
                          controller: _licenseNumberController,
                        ),
                        _buildField(
                          context,
                          label: AppStaticStrings.contactEmail,
                          hint: AppStaticStrings.businessEmailHint,
                          icon: Icons.email_outlined,
                          controller: _emailController,
                        ),
                        _buildField(
                          context,
                          label: AppStaticStrings.contactPhone,
                          hint: AppStaticStrings.phoneHint,
                          icon: Icons.phone_outlined,
                          controller: _phoneController,
                        ),
                        space20H,
                        CustomButton(
                          text: AppStaticStrings.continueText,
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (_shopNameController.text.isEmpty ||
                                _licenseNumberController.text.isEmpty ||
                                _emailController.text.isEmpty ||
                                _phoneController.text.isEmpty) {
                              CustomSnackbar.show(
                                context,
                                "All fields are required",
                                isError: true,
                              );
                              return;
                            }
                            context.read<AuthBloc>().add(
                                  SaveBusinessInfoEvent(
                                    shopName: _shopNameController.text,
                                    shopLicenseNumber:
                                        _licenseNumberController.text,
                                    contactEmail: _emailController.text,
                                    contactPhone: _phoneController.text,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required String hint,
    IconData? icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        CustomText(
          label,
          variant: TextVariant.labelLarge,
          fontWeight: FontWeight.bold,
        ),
        CustomTextField(
          textEditingController: controller,
          hintText: hint,
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey, size: 20)
              : null,
        ),
      ],
    );
  }
}
