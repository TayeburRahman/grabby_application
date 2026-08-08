import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../src_export.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _shopLicenseController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  File? _imageFile;
  bool _isShopOwner = false;
  ProfileData? _profileData;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _shopNameController.dispose();
    _shopLicenseController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _onSave(BuildContext context) {
    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        name: _nameController.text,
        profileImage: _imageFile,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        shopName: _shopNameController.text,
        shopLicenseNumber: _shopLicenseController.text,
        contactEmail: _contactEmailController.text,
        contactPhone: _contactPhoneController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(GetProfileEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStaticStrings.personalInformation)),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              setState(() {
                _profileData = state.profileData;
                _isShopOwner = state.profileData.authId.role == 'SHOP_OWNER';

                _nameController.text = state.profileData.name;
                _emailController.text = state.profileData.email;
                _phoneController.text = state.profileData.phoneNumber;
                _shopNameController.text = state.profileData.shopName ?? '';
                _shopLicenseController.text =
                    state.profileData.shopLicenseNumber ?? '';
                _contactEmailController.text =
                    state.profileData.contactEmail ?? '';
                _contactPhoneController.text =
                    state.profileData.contactPhone ?? '';
              });
            } else if (state is ProfileUpdateSuccess) {
              CustomSnackbar.show(context, state.message);
              context.pop();
            } else if (state is ProfileError) {
              CustomSnackbar.show(context, state.message, isError: true);
            }
          },
          builder: (context, state) {
            final isLoading = state is ProfileLoading;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(GetProfileEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppPadding.getPadding12(context).copyWith(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    // Profile Photo Section
                    const CustomText(
                      AppStaticStrings.profilePhoto,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.kSecondaryTextColor,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        spacing: 12,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (_imageFile != null)
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else if (_profileData?.profileImage != null)
                                CustomNetworkImage(
                                  imageUrl:
                                      "${ApiEndpoints.baseUrl}${_profileData!.profileImage!}",
                                  width: 100,
                                  height: 100,
                                  radius: 12,
                                  imageErrorUrl: ImagesConstant.kOnboard1Img,
                                )
                              else
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        ImagesConstant.kOnboard1Img,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.kPrimaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: _pickImage,
                            child: const CustomText(
                              AppStaticStrings.changePhoto,
                              fontSize: 14,
                              color: AppColors.kPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Basic Information Section
                    const CustomText(
                      AppStaticStrings.basicInformation,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.kSecondaryTextColor,
                    ),

                    if (_isShopOwner) ...[
                      CustomTextField(
                        textEditingController: _shopNameController,
                        title: AppStaticStrings.shopName,
                        hintText: AppStaticStrings.shopName,
                        prefixIcon: const Icon(
                          Icons.store_outlined,
                          color: AppColors.kSecondaryTextColor,
                          size: 20,
                        ),
                      ),
                      CustomTextField(
                        textEditingController: _shopLicenseController,
                        title: AppStaticStrings.shopLicenseNumber,
                        hintText: AppStaticStrings.shopLicenseNumber,
                        prefixIcon: const Icon(
                          Icons.article_outlined,
                          color: AppColors.kSecondaryTextColor,
                          size: 20,
                        ),
                      ),
                    ],

                    CustomTextField(
                      textEditingController: _nameController,
                      title: AppStaticStrings.name,
                      hintText: AppStaticStrings.name,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppColors.kSecondaryTextColor,
                        size: 20,
                      ),
                    ),

                    CustomTextField(
                      textEditingController: _emailController,
                      title: AppStaticStrings.emailAddress,
                      hintText: AppStaticStrings.emailAddress,
                      isEnable: _isShopOwner,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.kSecondaryTextColor,
                        size: 20,
                      ),
                    ),

                    CustomTextField(
                      textEditingController: _phoneController,
                      title: AppStaticStrings.phoneNumber,
                      hintText: AppStaticStrings.phoneNumber,
                      isEnable: _isShopOwner,
                      prefixIcon: const Icon(
                        Icons.call_outlined,
                        color: AppColors.kSecondaryTextColor,
                        size: 20,
                      ),
                    ),

                    if (_isShopOwner) ...[
                      const CustomText(
                        AppStaticStrings.businessInformation,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kSecondaryTextColor,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12,
                          children: [
                            // if (_profileData?.shopLogo != null &&
                            //     _profileData!.shopLogo!.isNotEmpty) ...[
                            //   const CustomText(
                            //     AppStaticStrings.shopLogo,
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w500,
                            //     color: AppColors.kSecondaryTextColor,
                            //   ),
                            //   CustomNetworkImage(
                            //     imageUrl:
                            //         "${ApiEndpoints.baseUrl}${_profileData!.shopLogo!}",
                            //     width: 80,
                            //     height: 80,
                            //     radius: 8,
                            //     imageErrorUrl: ImagesConstant.kOnboard1Img,
                            //   ),
                            // ],
                            if (_profileData?.businessLicense != null &&
                                _profileData!.businessLicense!.isNotEmpty) ...[
                              const CustomText(
                                AppStaticStrings.businessLicense,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.kSecondaryTextColor,
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.kPrimaryColor.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.kPrimaryColor.withAlpha(
                                      50,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.description_outlined,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: CustomText(
                                        _profileData!.businessLicense!
                                            .split('/')
                                            .last,
                                        fontSize: 12,
                                        color: AppColors.kPrimaryColor,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      CustomTextField(
                        textEditingController: _contactEmailController,
                        title: AppStaticStrings.shopContactEmail,
                        hintText: AppStaticStrings.shopContactEmail,
                        prefixIcon: const Icon(
                          Icons.contact_mail_outlined,
                          color: AppColors.kSecondaryTextColor,
                          size: 20,
                        ),
                      ),
                      CustomTextField(
                        textEditingController: _contactPhoneController,
                        title: AppStaticStrings.shopContactPhone,
                        hintText: AppStaticStrings.shopContactPhone,
                        prefixIcon: const Icon(
                          Icons.contact_phone_outlined,
                          color: AppColors.kSecondaryTextColor,
                          size: 20,
                        ),
                      ),
                    ],

                    CustomButton(
                      text: AppStaticStrings.saveChange,
                      isLoading: isLoading,
                      onPressed: () => _onSave(context),
                      backgroundColor: AppColors.kPrimaryColor,
                      borderRadius: 12,
                    ),

                    CustomButton(
                      text: AppStaticStrings.cancel,
                      onPressed: () => context.pop(),
                      backgroundColor: Colors.white,
                      textColor: AppColors.kSecondaryTextColor,
                      borderColor: Colors.black12,
                      borderRadius: 12,
                    ),
                    space24H,
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
