import '../../../../src_export.dart';

class CategoriesManagementBottomSheet extends StatefulWidget {
  const CategoriesManagementBottomSheet({super.key});

  @override
  State<CategoriesManagementBottomSheet> createState() =>
      _CategoriesManagementBottomSheetState();
}

class _CategoriesManagementBottomSheetState
    extends State<CategoriesManagementBottomSheet> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MenuBloc>()..add(GetMenuCategoriesEvent()),
      child: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state.status == MenuStatus.error && state.errorMessage != null) {
            CustomSnackbar.show(context, state.errorMessage!, isError: true);
          }
          if (state.successMessage != null) {
            CustomSnackbar.show(context, state.successMessage!);
          }
        },
        builder: (context, state) {
          final categories = state.categories;
          final isLoading = state.status == MenuStatus.loading;

          return Container(
            padding: AppPadding.getPadding12(
              context,
            ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 19),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      AppStaticStrings.categories,
                      variant: TextVariant.titleLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                if (isLoading && categories.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else
                  ...categories.map((cat) => _buildCategoryRow(context, cat)),
                if (state.status == MenuStatus.error && categories.isEmpty)
                  Center(child: Text(state.errorMessage ?? "Error")),
                space8H,
                CustomTextField(
                  textEditingController: _categoryController,
                  hintText: AppStaticStrings.categoryName,
                  fillColor: const Color(0xffF9FAFB),
                  borderRadius: 12,
                ),
                space4H,
                CustomButton(
                  text: AppStaticStrings.submit,
                  isLoading: isLoading,
                  onPressed: () {
                    if (_categoryController.text.isNotEmpty) {
                      context.read<MenuBloc>().add(
                        CreateMenuCategoryEvent(_categoryController.text),
                      );
                      _categoryController.clear();
                    }
                  },
                  backgroundColor: AppColors.kPrimaryColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context, MenuCategoryModel category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(category.name, fontWeight: FontWeight.w600),
        IconButton(
          onPressed: () {
            context.read<MenuBloc>().add(DeleteMenuCategoryEvent(category.id));
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ],
    );
  }
}
