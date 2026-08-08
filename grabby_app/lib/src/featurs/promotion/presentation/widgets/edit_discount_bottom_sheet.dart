import '../../../../src_export.dart';

class EditDiscountBottomSheet extends StatefulWidget {
  final String? title;
  final PromotionModel? promotion; // For edit mode
  const EditDiscountBottomSheet({super.key, this.title, this.promotion});

  @override
  State<EditDiscountBottomSheet> createState() =>
      _EditDiscountBottomSheetState();
}

class _EditDiscountBottomSheetState extends State<EditDiscountBottomSheet> {
  final Map<String, String> selectedItemsMap = {}; // Maps Item Name to ID
  bool isDropdownOpen = false;
  String _appliedOn = 'all'; // 'all' or 'specific'
  final List<String> _appliedOnOptions = ['all', 'specific'];

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _occasionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  String? _selectedEvent; // Holds selected event name
  List<UpcomingEventModel> _events = [];

  @override
  void initState() {
    super.initState();
    // Initialize form with existing promotion data if editing
    if (widget.promotion != null) {
      _nameController.text = widget.promotion!.discountName;
      _selectedEvent = widget.promotion!.eventName; // This handles previous data as well
      _startDateController.text = widget.promotion!.startDate.toString().split(' ').first;
      _endDateController.text = widget.promotion!.endDate.toString().split(' ').first;
      _discountController.text = widget.promotion!.discountValue.toInt().toString();
      _appliedOn = widget.promotion!.appliedOn;
      for (var item in widget.promotion!.specificItems) {
        selectedItemsMap[item.itemName] = item.id;
      }
    }
    // Fetch upcoming events for dropdown
    context.read<PromotionBloc>().add(FetchUpcomingEventsEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _occasionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void toggleSelection(String itemName, String itemId) {
    setState(() {
      if (selectedItemsMap.containsKey(itemName)) {
        selectedItemsMap.remove(itemName);
      } else {
        selectedItemsMap[itemName] = itemId;
      }
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(' ').first;
      });
    }
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty ||
        _discountController.text.isEmpty ||
        (_appliedOn == 'specific' && selectedItemsMap.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final data = {
      'discountName': _nameController.text,
      'eventName': _selectedEvent,
      'startDate': _startDateController.text,
      'endDate': _endDateController.text,
      'discountType': 'percentage',
      'discountValue': int.parse(_discountController.text),
      'appliedOn': _appliedOn,
      'specificItems': _appliedOn == 'specific' ? selectedItemsMap.values.toList() : [],
      'isActive': true,
    };

    final bloc = context.read<PromotionBloc>();
    if (widget.promotion != null) {
      // Edit mode
      bloc.add(UpdatePromotionEvent(widget.promotion!.id, data));
    } else {
      // Create mode
      bloc.add(CreatePromotionEvent(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PromotionBloc, PromotionState>(
      listener: (context, state) {
        if (state is PromotionOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.pop();
        } else if (state is PromotionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UpcomingEventsLoaded) {
          setState(() {
            _events = state.upcomingEvents;
          });
        }
      },
      child: BlocBuilder<PromotionBloc, PromotionState>(
        builder: (context, state) {
          if (state is UpcomingEventsLoaded) {
            _events = state.upcomingEvents;
          } else if (state is PromotionsLoaded) {
            _events = state.upcomingEvents;
          }
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              padding: AppPadding.getPadding16(context).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    widget.title ?? AppStaticStrings.editDiscount,
                    variant: TextVariant.headlineSmall,
                    fontWeight: FontWeight.bold,
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              // Image section commented out as requested
              /*
              _buildFieldLabel(AppStaticStrings.promotionImage),
              _buildImagePicker(),
              */

              _buildFieldLabel(AppStaticStrings.discountName),
              CustomTextField(textEditingController: _nameController, hintText: "Cappuccino"),

              _buildFieldLabel(AppStaticStrings.eventOccasionOptional),
              _buildEventDropdown(),

              Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(AppStaticStrings.startDate),
                        GestureDetector(
                          onTap: () => _selectDate(context, _startDateController),
                          child: AbsorbPointer(
                            child: CustomTextField(
                              textEditingController: _startDateController,
                              hintText: "YYYY-MM-DD",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(AppStaticStrings.endDate),
                        GestureDetector(
                          onTap: () => _selectDate(context, _endDateController),
                          child: AbsorbPointer(
                            child: CustomTextField(
                              textEditingController: _endDateController,
                              hintText: "YYYY-MM-DD",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              _buildFieldLabel("Applied On"),
              _buildAppliedOnDropdown(),

              if (_appliedOn == 'specific') ...[
                _buildFieldLabel(AppStaticStrings.appliedToItem),
                _buildMultiSelectField(),
                if (isDropdownOpen) _buildItemsList(),
              ],

              _buildFieldLabel(AppStaticStrings.discountPercentage),
              CustomTextField(
                textEditingController: _discountController,
                hintText: "15",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),
              CustomButton(
                text: widget.promotion != null
                    ? AppStaticStrings.saveChanges
                    : AppStaticStrings.addPromotion,
                onPressed: _submitForm,
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
      },
    ),
  );
}

  Widget _buildEventDropdown() {
    // If we have a selected event that's not in the list (e.g. from old data),
    // we should still display it or handle it.
    
    
    final List<String> eventNames = _events.map((e) => e.name).toSet().toList();
    if (_selectedEvent != null && !eventNames.contains(_selectedEvent)) {
      eventNames.add(_selectedEvent!);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.kSecondaryTextColor.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedEvent,
          isExpanded: true,
          hint: CustomText(
            "Select Event",
            variant: TextVariant.labelMedium,
            color: AppColors.kSecondaryTextColor,
          ),
          items: eventNames.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CustomText(
                value,
                variant: TextVariant.labelMedium,
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedEvent = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CustomText(
        label,
        variant: TextVariant.labelMedium,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAppliedOnDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.kSecondaryTextColor.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _appliedOn,
          isExpanded: true,
          items: _appliedOnOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CustomText(
                value,
                variant: TextVariant.labelMedium,
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _appliedOn = newValue!;
              if (_appliedOn == 'all') {
                selectedItemsMap.clear();
                isDropdownOpen = false;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildMultiSelectField() {
    return GestureDetector(
      onTap: () => setState(() => isDropdownOpen = !isDropdownOpen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.kSecondaryTextColor.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: selectedItemsMap.isEmpty
                  ? CustomText(
                      "Select items",
                      variant: TextVariant.labelMedium,
                      color: AppColors.kSecondaryTextColor,
                    )
                  : Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: selectedItemsMap.keys
                          .map(
                            (itemName) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.kPrimaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    itemName,
                                    variant: TextVariant.labelSmall,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => toggleSelection(itemName, selectedItemsMap[itemName]!),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
            Icon(
              isDropdownOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: AppColors.kSecondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, menuState) {
        final menuItems = menuState.items;
        return Container(
          constraints: const BoxConstraints(maxHeight: 200),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.kSecondaryTextColor.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              final isSelected = selectedItemsMap.containsKey(item.itemName);
              return ListTile(
                dense: true,
                title: CustomText(item.itemName, variant: TextVariant.labelMedium),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (_) => toggleSelection(item.itemName, item.id!),
                  activeColor: AppColors.kPrimaryColor,
                ),
                onTap: () => toggleSelection(item.itemName, item.id!),
              );
            },
          ),
        );
      },
    );
  }
}
