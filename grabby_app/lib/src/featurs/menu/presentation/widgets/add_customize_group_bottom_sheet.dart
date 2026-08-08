import 'package:flutter/foundation.dart';

import '../../../../src_export.dart';

class AddCustomizeGroupBottomSheet extends StatefulWidget {
  const AddCustomizeGroupBottomSheet({super.key});

  @override
  State<AddCustomizeGroupBottomSheet> createState() =>
      _AddCustomizeGroupBottomSheetState();
}

class _AddCustomizeGroupBottomSheetState
    extends State<AddCustomizeGroupBottomSheet> {
  bool isRequired = true;
  final TextEditingController _groupNameController = TextEditingController(
    text: kDebugMode ? "Choice of milk" : "",
  );
  final TextEditingController _itemNameController = TextEditingController(
    text: kDebugMode ? "Oat Milk" : "",
  );
  final TextEditingController _itemPriceController = TextEditingController(
    text: kDebugMode ? "2" : "",
  );
  final List<CustomizationItemModel> _items = [];

  @override
  void dispose() {
    _groupNameController.dispose();
    _itemNameController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_itemNameController.text.isNotEmpty &&
        _itemPriceController.text.isNotEmpty) {
      setState(() {
        _items.add(
          CustomizationItemModel(
            name: _itemNameController.text,
            price: double.tryParse(_itemPriceController.text) ?? 0.0,
          ),
        );
        _itemNameController.clear();
        _itemPriceController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding12(
        context,
      ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            AppStaticStrings.addCustomizeGroup,
            variant: TextVariant.titleLarge,
            fontWeight: FontWeight.bold,
          ),

          const CustomText(AppStaticStrings.title, fontWeight: FontWeight.bold),

          CustomTextField(
            textEditingController: _groupNameController,
            hintText: "e.g., Choice of milk",
            fillColor: const Color(0xffF9FAFB),
            borderRadius: 12,
          ),

          ..._items.asMap().entries.map(
            (entry) => _buildItemRow(entry.key, entry.value),
          ),

          Row(
            spacing: 12,
            children: [
              Expanded(
                child: CustomTextField(
                  textEditingController: _itemNameController,
                  hintText: AppStaticStrings.name,
                  fillColor: const Color(0xffF9FAFB),
                  borderRadius: 12,
                ),
              ),
              Expanded(
                child: CustomTextField(
                  textEditingController: _itemPriceController,
                  keyboardType: TextInputType.number,
                  hintText: "Price",
                  fillColor: const Color(0xffF9FAFB),
                  borderRadius: 12,
                ),
              ),
            ],
          ),

          _buildAddButton(),

          _buildToggleButtons(),

          CustomButton(
            text: AppStaticStrings.saveChanges,
            onPressed: () {
              if (_groupNameController.text.isNotEmpty && _items.isNotEmpty) {
                Navigator.pop(
                  context,
                  CustomizationGroupModel(
                    groupName: _groupNameController.text,
                    type: isRequired ? 'regular' : 'optional',
                    items: _items,
                  ),
                );
              } else {
                CustomSnackbar.show(
                  context,
                  "Please enter a group name and at least one item",
                );
              }
            },
            backgroundColor: AppColors.kPrimaryColor,
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const CustomText(AppStaticStrings.cancel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(int index, CustomizationItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        spacing: 8,
        children: [
          const Icon(Icons.menu, color: Colors.grey),
          Expanded(child: CustomText(item.name)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xffEEECFF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomText(
              "${item.price} AED",
              fontSize: 10,
              color: AppColors.kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => _removeItem(index),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return ButtonTapWidget(
      onTap: _addItem,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16),
            CustomText("Add", fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      spacing: 8,
      children: [
        _buildToggleButton(
          AppStaticStrings.required,
          isRequired,
          () => setState(() => isRequired = true),
        ),
        _buildToggleButton(
          AppStaticStrings.optional,
          !isRequired,
          () => setState(() => isRequired = false),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: ButtonTapWidget(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.kPrimaryColor : const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: CustomText(
              label,
              color: active ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
