import '../../../../src_export.dart';

class SuggestAShopPage extends StatelessWidget {
  const SuggestAShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStaticStrings.suggestAShop),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: AppPadding.getPadding12(context),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const CustomText(
              AppStaticStrings.suggestAShopDesc,
              fontSize: 14,
              color: AppColors.kSecondaryTextColor,
            ),

            // Form Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                _buildFieldLabel(AppStaticStrings.shopName, isRequired: true),
                CustomTextField(
                  hintText: AppStaticStrings.enterShopName,
                  borderRadius: 12,
                ),

                _buildFieldLabel(AppStaticStrings.location, isRequired: false),
                CustomTextField(
                  hintText: AppStaticStrings.cityOrAddress,
                  borderRadius: 12,
                ),

                _buildFieldLabel(
                  AppStaticStrings.additionalNotes,
                  isRequired: false,
                ),
                CustomTextField(
                  hintText: AppStaticStrings.additionalNotesHint,
                  maxLines: 5,
                  borderRadius: 12,
                ),
              ],
            ),

            space24H,

            // Submit Button
            CustomButton(
              text: AppStaticStrings.submitSuggestion,
              onPressed: () {
                // TODO: Logic for submit suggestion
              },
              backgroundColor: AppColors.kPrimaryColor,
              borderRadius: 16,
            ),
            space24H,
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, {required bool isRequired}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(label, fontSize: 14, fontWeight: FontWeight.bold),
        if (isRequired) const CustomText(" *", color: Colors.red, fontSize: 14),
      ],
    );
  }
}
