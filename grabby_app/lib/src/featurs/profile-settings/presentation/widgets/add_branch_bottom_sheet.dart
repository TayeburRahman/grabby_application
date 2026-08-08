import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grabby_app/src/featurs/profile-settings/data/models/branch_model.dart';
import 'package:grabby_app/src/featurs/profile-settings/presentation/bloc/branch/branch_bloc.dart';

import '../../../../src_export.dart';

class AddBranchBottomSheet extends StatefulWidget {
  final ShopBranchModel? branch;

  const AddBranchBottomSheet({super.key, this.branch});

  @override
  State<AddBranchBottomSheet> createState() => _AddBranchBottomSheetState();
}

class _AddBranchBottomSheetState extends State<AddBranchBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  double _lat = 0.0;
  double _lng = 0.0;
  bool _applyMenuForAll = false;

  @override
  void initState() {
    super.initState();
    if (widget.branch != null) {
      final branch = widget.branch!;
      _nameController.text = branch.branchName;
      _addressController.text = branch.address;
      _phoneController.text = branch.phoneNumber;
      _lat = branch.lat;
      _lng = branch.lng;
      _applyMenuForAll = branch.applyMenuForAll;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.isEmpty || _addressController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final data = {
      "branch_name": _nameController.text.trim(),
      "address": _addressController.text.trim(),
      "lat": _lat,
      "lng": _lng,
      "phone_number": _phoneController.text.trim(),
      "applyMenuForAll": _applyMenuForAll,
    };

    if (widget.branch != null) {
      context.read<BranchBloc>().add(
        UpdateBranchEvent(widget.branch!.id, data),
      );
    } else {
      context.read<BranchBloc>().add(CreateBranchEvent(data));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  widget.branch != null ? 'Edit Branch' : AppStaticStrings.addNewBranch,
                  variant: TextVariant.headlineSmall,
                  fontWeight: FontWeight.bold,
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            CustomTextField(
              title: AppStaticStrings.branchName,
              hintText: AppStaticStrings.branchNamePrompt,
              textEditingController: _nameController,
            ),
            ButtonTapWidget(
              onTap: () async {
                final result = await context.pushNamed(
                  RoutesPath.locationSelectionName,
                );
                if (result != null && result is Map<String, dynamic>) {
                  final position = result['position'] as LatLng?;
                  setState(() {
                    _addressController.text = result['address'] ?? '';
                    _lat = position?.latitude ?? 0.0;
                    _lng = position?.longitude ?? 0.0;
                  });
                }
              },

              child: CustomTextField(
                title: AppStaticStrings.fullAddress,
                textEditingController: _addressController,
                isEnable: false,
                hintText: AppStaticStrings.enterCompleteAddress,
              ),
            ),
            CustomTextField(
              title: AppStaticStrings.phoneNumber,
              hintText: "+1 (555) 000-0000",
              textEditingController: _phoneController,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.kBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          "Apply Menu to All",
                          variant: TextVariant.titleSmall,
                          fontWeight: FontWeight.bold,
                        ),
                        const CustomText(
                          "Sync menu items across branches",
                          variant: TextVariant.labelSmall,
                          color: AppColors.kSecondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _applyMenuForAll,
                    onChanged: (val) {
                      setState(() {
                        _applyMenuForAll = val;
                      });
                    },
                    activeColor: AppColors.kPrimaryColor,
                  ),
                ],
              ),
            ),
            CustomButton(
              text: widget.branch != null ? 'Update Branch' : AppStaticStrings.addBranch,
              onPressed: _submit,
            ),
            CustomButton(
              text: AppStaticStrings.cancel,
              onPressed: () => context.pop(),
              isOutlined: true,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
