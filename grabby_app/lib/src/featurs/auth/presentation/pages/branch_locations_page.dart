import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../src_export.dart';

class BranchLocationsPage extends StatefulWidget {
  const BranchLocationsPage({super.key});

  @override
  State<BranchLocationsPage> createState() => _BranchLocationsPageState();
}

class _BranchLocationsPageState extends State<BranchLocationsPage> {
  final List<BranchInputControllers> _branches = [
    BranchInputControllers(),
  ];
  bool _applyMenuForAll = false;

  @override
  void dispose() {
    for (var branch in _branches) {
      branch.dispose();
    }
    super.dispose();
  }

  void _addBranch() {
    setState(() {
      _branches.add(BranchInputControllers());
    });
  }

  void _removeBranch(int index) {
    if (_branches.length > 1) {
      setState(() {
        _branches[index].dispose();
        _branches.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            AppStaticStrings.branchLocations,
            variant: TextVariant.titleLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SaveBranchesSuccess) {
              context.push(RoutesPath.requiredDocumentsPath);
            } else if (state is AuthFailure) {
              CustomSnackbar.show(context, state.message, isError: true);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const OnboardingProgressBar(currentStep: 2),
                  Padding(
                    padding: AppPadding.getPadding12(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          AppStaticStrings.branchLocations,
                          variant: TextVariant.titleMedium,
                          fontWeight: FontWeight.bold,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _branches.length,
                          separatorBuilder: (context, index) => space16H,
                          itemBuilder: (context, index) {
                            return _buildBranchForm(index);
                          },
                        ),
                        space16H,
                        CustomButton(
                          text: AppStaticStrings.addAnotherBranch,
                          onPressed: _addBranch,
                          icon: Icons.add,
                          isOutlined: true,
                          borderColor: AppColors.kPrimaryColor,
                          textColor: AppColors.kPrimaryColor,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _applyMenuForAll,
                              onChanged: (val) {
                                setState(() {
                                  _applyMenuForAll = val ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const Expanded(
                              child: CustomText(
                                AppStaticStrings.applySameMenuForAllBranches,
                                variant: TextVariant.labelSmall,
                                color: AppColors.kSecondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        space20H,
                        CustomButton(
                          text: AppStaticStrings.continueText,
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            // Validation
                            for (var branch in _branches) {
                              if (branch.nameController.text.isEmpty ||
                                  branch.addressController.text.isEmpty ||
                                  branch.phoneController.text.isEmpty) {
                                CustomSnackbar.show(
                                  context,
                                  "Please fill all details for all branches",
                                  isError: true,
                                );
                                return;
                              }
                            }

                            final branches = _branches.map((b) {
                              return BranchModel(
                                branchName: b.nameController.text,
                                address: b.addressController.text,
                                phoneNumber: b.phoneController.text,
                                lat: b.lat,
                                lng: b.lng,
                                applyMenuForAll: _applyMenuForAll,
                              );
                            }).toList();

                            context.read<AuthBloc>().add(
                                  SaveBranchesEvent(branches: branches),
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

  Widget _buildBranchForm(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              "${AppStaticStrings.branch} ${index + 1}",
              variant: TextVariant.labelLarge,
              fontWeight: FontWeight.bold,
            ),
            if (_branches.length > 1)
              IconButton(
                onPressed: () => _removeBranch(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
          ],
        ),
        space8H,
        CustomTextField(
          textEditingController: _branches[index].nameController,
          hintText: AppStaticStrings.branchNameHint,
        ),
        space8H,
        ButtonTapWidget(
          onTap: () async {
            final result = await context.pushNamed(
              RoutesPath.locationSelectionName,
            );
            if (result != null && result is Map<String, dynamic>) {
              final position = result['position'] as LatLng?;
              setState(() {
                _branches[index].addressController.text = result['address'] ?? '';
                _branches[index].lat = position?.latitude ?? 0.0;
                _branches[index].lng = position?.longitude ?? 0.0;
              });
            }
          },
          child: CustomTextField(
            textEditingController: _branches[index].addressController,
            hintText: AppStaticStrings.fullAddress,
            isEnable: false,
          ),
        ),
        space8H,
        CustomTextField(
          textEditingController: _branches[index].phoneController,
          hintText: AppStaticStrings.phoneNumber,
        ),
      ],
    );
  }
}

class BranchInputControllers {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  double lat = 0.0;
  double lng = 0.0;

  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
  }
}
