import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../../../src_export.dart';

class EditItemPage extends StatefulWidget {
  final MenuItemModel? item;

  const EditItemPage({super.key, this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  bool giveStamp = true;
  bool availableNow = true;
  File? _pickedImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  MenuCategoryModel? _selectedCategory;
  final List<CustomizationGroupModel> _customizationGroups = [];

  bool get isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final item = widget.item!;
      _nameController.text = item.itemName;
      _priceController.text = item.price.toString();
      _descriptionController.text = item.description;
      giveStamp = item.stampActive;
      availableNow = item.isAvailable;
      _customizationGroups.addAll(item.additionalItems);
      log(
        "Loaded ${item.additionalItems.length} - ${_customizationGroups.length} customizations for editing.",
      );
    } else if (kDebugMode) {
      _nameController.text = "Matcha";
      _priceController.text = "12";
      _descriptionController.text = "Description";
      giveStamp = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MenuBloc>()..add(GetMenuCategoriesEvent()),
      child: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state.status == MenuStatus.error && state.errorMessage != null) {
            log(state.errorMessage!);
            CustomSnackbar.show(context, state.errorMessage!, isError: true);
          }
          if (state.successMessage != null) {
            CustomSnackbar.show(context, state.successMessage!);
            context.pop(true); // Return true to indicate refresh needed
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: CustomText(
                isEditing
                    ? AppStaticStrings.editItem
                    : AppStaticStrings.addItem,
                variant: TextVariant.titleLarge,
              ),
            ),
            body: SingleChildScrollView(
              padding: AppPadding.getPadding12(context).copyWith(top: 0),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageUpload(),
                  _buildTextField(
                    AppStaticStrings.itemName,
                    AppStaticStrings.enterItemName,
                    textEditingController: _nameController,
                  ),
                  _buildCategorySelection(context, state),
                  _buildTextField(
                    AppStaticStrings.priceAED,
                    "5.5",
                    textEditingController: _priceController,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    AppStaticStrings.description,
                    AppStaticStrings.describeYourItem,
                    textEditingController: _descriptionController,
                    maxLines: 3,
                  ),
                  _buildAddCustomizationButton(context),
                  _buildCustomizationGroups(),
                  _buildLoyaltySection(),
                  _buildAvailableNowSection(),
                  _buildActionButtons(context, state),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        const CustomText(AppStaticStrings.image, fontWeight: FontWeight.bold),
        Container(
          padding: AppPadding.getPadding8(context),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              if (_pickedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _pickedImage!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const Icon(
                  Icons.file_upload_outlined,
                  color: AppColors.kPrimaryColor,
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4,
                child: CustomButton(
                  text: _pickedImage != null
                      ? AppStaticStrings.changeImage
                      : AppStaticStrings.uploadImage,
                  onPressed: () async {
                    final File? image = await ImagePickerHelper.pickImage(
                      context,
                    );
                    if (image != null) {
                      setState(() {
                        _pickedImage = image;
                      });
                    }
                  },
                  backgroundColor: AppColors.kPrimaryColor.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoyaltySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        const CustomText(AppStaticStrings.loyalty, fontWeight: FontWeight.bold),
        Container(
          // padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(
                value: giveStamp,
                onChanged: (val) => setState(() => giveStamp = val ?? false),
                activeColor: AppColors.kPrimaryColor,
              ),
              const Expanded(
                child: CustomText(
                  AppStaticStrings.giveStampForItem,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String title,
    String hint, {
    int maxLines = 1,
    TextEditingController? textEditingController,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        CustomText(title, fontWeight: FontWeight.bold),
        CustomTextField(
          textEditingController: textEditingController,
          hintText: hint,
          maxLines: maxLines,
          keyboardType: keyboardType,
          fillColor: Colors.white,
          borderRadius: 12,
        ),
      ],
    );
  }

  Widget _buildCategorySelection(BuildContext context, MenuState state) {
    final categories = state.categories;

    // Pre-select category if editing and not yet set
    if (isEditing && _selectedCategory == null && categories.isNotEmpty) {
      _selectedCategory = categories.firstWhere(
        (cat) => cat.id == widget.item!.categoryId,
        orElse: () => categories.first,
      );
    }

    // Ensure _selectedCategory is always a valid reference from the updated list
    if (_selectedCategory != null && categories.isNotEmpty) {
      final exists = categories.any((cat) => cat.id == _selectedCategory!.id);
      if (exists) {
        _selectedCategory = categories.firstWhere((cat) => cat.id == _selectedCategory!.id);
      } else {
        _selectedCategory = null; // Reset if the category was deleted
      }
    } else if (categories.isEmpty) {
      _selectedCategory = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        const CustomText(
          AppStaticStrings.category,
          fontWeight: FontWeight.bold,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<MenuCategoryModel>(
              isExpanded: true,
              hint: const Text("Select Category"),
              value: _selectedCategory,
              items: categories.map((MenuCategoryModel cat) {
                return DropdownMenuItem<MenuCategoryModel>(
                  value: cat,
                  child: Text(cat.name),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val;
                });
              },
            ),
          ),
        ),
        ButtonTapWidget(
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) => const CategoriesManagementBottomSheet(),
            );
            // Refresh categories after closing management sheet
            if (context.mounted) {
              context.read<MenuBloc>().add(GetMenuCategoriesEvent());
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const CustomText(
              AppStaticStrings.editCategory,
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddCustomizationButton(BuildContext context) {
    return ButtonTapWidget(
      onTap: () async {
        final result = await showModalBottomSheet<CustomizationGroupModel>(
          context: context,
          isScrollControlled: true,
          builder: (context) => const AddCustomizeGroupBottomSheet(),
        );

        if (result != null) {
          setState(() {
            _customizationGroups.add(result);
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CustomText(
            AppStaticStrings.addCustomization,
            color: AppColors.kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationGroups() {
    return Column(
      spacing: 12,
      children: _customizationGroups.asMap().entries.map((entry) {
        return _buildCustomizationGroup(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildCustomizationGroup(int index, CustomizationGroupModel group) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(group.groupName, fontWeight: FontWeight.bold),
                ButtonTapWidget(
                  onTap: () {
                    setState(() {
                      _customizationGroups.removeAt(index);
                    });
                  },
                  child: const CustomText(
                    AppStaticStrings.deleteGroup,
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...group.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.menu, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: CustomText(item.name)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEEECFF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CustomText(
                      item.price == 0 ? "Free" : "+${item.price} AED",
                      fontSize: 10,
                      color: AppColors.kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableNowSection() {
    return Container(
      padding: AppPadding.getPadding8(context).copyWith(top: 0, right: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                AppStaticStrings.availableNow,
                variant: TextVariant.labelSmall,
                fontWeight: FontWeight.bold,
              ),
              Switch(
                value: availableNow,
                onChanged: (val) => setState(() => availableNow = val),
                activeTrackColor: AppColors.kPrimaryColor,
                activeThumbColor: Colors.white,
              ),
            ],
          ),
          const CustomText(
            AppStaticStrings.makeItemAvailable,
            variant: TextVariant.labelSmall,
            color: AppColors.kSecondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, MenuState state) {
    return Column(
      children: [
        CustomButton(
          text: AppStaticStrings.saveChanges,
          isLoading: state.status == MenuStatus.loading,
          onPressed: () {
            if (_nameController.text.isEmpty ||
                _selectedCategory == null ||
                _priceController.text.isEmpty) {
              CustomSnackbar.show(context, "Please fill all required fields");
              return;
            }

            if (isEditing) {
              context.read<MenuBloc>().add(
                UpdateMenuItemEvent(
                  menuId: widget.item!.id!,
                  itemName: _nameController.text,
                  categoryId: _selectedCategory!.id,
                  price: double.tryParse(_priceController.text),
                  description: _descriptionController.text,
                  stampActive: giveStamp,
                  isAvailable: availableNow,
                  additionalItems: _customizationGroups,
                  image: _pickedImage,
                ),
              );
            } else {
              context.read<MenuBloc>().add(
                CreateMenuItemEvent(
                  itemName: _nameController.text,
                  categoryId: _selectedCategory!.id,
                  price: double.tryParse(_priceController.text) ?? 0.0,
                  description: _descriptionController.text,
                  stampActive: giveStamp,
                  isAvailable: availableNow,
                  additionalItems: _customizationGroups,
                  image: _pickedImage,
                ),
              );
            }
          },
          backgroundColor: AppColors.kPrimaryColor,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
            child: const CustomText(
              AppStaticStrings.cancel,
              color: AppColors.kSecondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
