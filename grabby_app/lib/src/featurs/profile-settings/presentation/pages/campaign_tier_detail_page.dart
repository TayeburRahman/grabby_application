import '../../../../src_export.dart';

class CampaignTierDetailPage extends StatelessWidget {
  final Map<String, dynamic> tierData;

  const CampaignTierDetailPage({super.key, required this.tierData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          tierData['tier'],
          variant: TextVariant.headlineSmall,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppPadding.getPadding12(context).copyWith(top: 0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tier Info Card
            Container(
              width: double.infinity,
              padding: AppPadding.getPadding12(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(appRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    tierData['duration'],
                    variant: TextVariant.headlineMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomText(
                      "AED ${tierData['price']} ",
                      variant: TextVariant.labelMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  space8H,
                  if (tierData['features'] != null)
                    ...(tierData['features'] as List<String>).map(
                      (feature) => CheckmarkListItem(title: feature),
                    ),
                ],
              ),
            ),

            // Buy Now Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: AppStaticStrings.buyNow,
                onPressed: () {
                  // TODO: Implement purchase logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
