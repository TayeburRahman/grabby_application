import '../../../../src_export.dart';

class RewardSettingsPage extends StatefulWidget {
  const RewardSettingsPage({super.key});

  @override
  State<RewardSettingsPage> createState() => _RewardSettingsPageState();
}

class _RewardSettingsPageState extends State<RewardSettingsPage> {
  bool isRewardPointsAccepted = true;
  final List<Map<String, dynamic>> discountOffers = [
    {"amount": "AED 5", "points": "500", "isSelected": true},
    {"amount": "AED 10", "points": "1000", "isSelected": true},
    {"amount": "AED 15", "points": "1500", "isSelected": true},
    {"amount": "AED 20", "points": "2000", "isSelected": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          AppStaticStrings.rewardSettings,
          variant: TextVariant.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppPadding.getPadding12(context),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSystemHeader(),
            _buildAcceptPointsToggle(),
            _buildEarningRule(),
            _buildDiscountOffersSection(),
            _buildImportantNotes(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHeader() {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffEEECFF),
            borderRadius: BorderRadius.circular(appRadius16),
          ),
          child: SvgPicture.asset(ImagesConstant.kGiftIcon),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              const CustomText(
                AppStaticStrings.rewardPointsSystem,
                variant: TextVariant.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                AppStaticStrings.rewardPointsSystemDesc,
                variant: TextVariant.labelSmall,
                color: AppColors.kSecondaryTextColor,
                height: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcceptPointsToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              const CustomText(
                AppStaticStrings.acceptRewardPoints,
                variant: TextVariant.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                AppStaticStrings.allowCustomersToRedeem,
                variant: TextVariant.labelSmall,
                color: AppColors.kSecondaryTextColor,
              ),
            ],
          ),
        ),
        Switch(
          padding: EdgeInsets.zero,
          value: isRewardPointsAccepted,
          onChanged: (val) => setState(() => isRewardPointsAccepted = val),
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xffA59BF9),
        ),
      ],
    );
  }

  Widget _buildEarningRule() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, color: Color(0xffA59BF9), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              const CustomText(
                AppStaticStrings.pointsEarningRule,
                variant: TextVariant.titleSmall,
                fontWeight: FontWeight.bold,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.kSecondaryTextColor,
                    fontFamily: 'Outfit',
                  ),
                  children: [
                    const TextSpan(text: "Customers earn "),
                    TextSpan(
                      text: "2 points for every 5 AED",
                      style: TextStyle(
                        color: const Color(0xffA59BF9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " spent at your shop"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountOffersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const CustomText(
          AppStaticStrings.selectDiscountOffers,
          variant: TextVariant.titleMedium,
          fontWeight: FontWeight.bold,
        ),
        CustomText(
          AppStaticStrings.chooseWhichDiscount,
          variant: TextVariant.labelSmall,
          color: AppColors.kSecondaryTextColor,
        ),
        ...discountOffers.map((offer) => _buildOfferCard(offer)),
      ],
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return InkWell(
      onTap: () {
        setState(() {
          offer["isSelected"] = !offer["isSelected"];
        });
      },
      borderRadius: BorderRadius.circular(appRadius16),
      child: Container(
        padding: AppPadding.getPadding8(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(appRadius16),
          border: Border.all(
            color: offer["isSelected"]
                ? const Color(0xffA59BF9)
                : AppColors.kSecondaryTextColor.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: offer["isSelected"],
              onChanged: (val) {
                setState(() {
                  offer["isSelected"] = val ?? false;
                });
              },
              activeColor: const Color(0xffA59BF9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(
                color: AppColors.kSecondaryTextColor.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    offer["amount"],
                    variant: TextVariant.titleSmall,
                    color: offer["isSelected"]
                        ? const Color(0xffA59BF9)
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    "${offer["points"]} ${AppStaticStrings.pointsRequired}",
                    variant: TextVariant.labelSmall,
                    color: AppColors.kSecondaryTextColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffA59BF9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                height: 20,
                ImagesConstant.kGiftIcon,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportantNotes(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding16(context),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(appRadius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.info_outline,
                size: 20,
                color: Color(0xffA59BF9),
              ),
              CustomText(
                AppStaticStrings.important,
                variant: TextVariant.titleSmall,
                color: AppColors.kSecondaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          CustomText(
            AppStaticStrings.rewardPointsValidAtParticipating,
            variant: TextVariant.labelSmall,
            color: AppColors.kSecondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
          _buildNoteItem(AppStaticStrings.customersCanOnlyUseRewards),
          _buildNoteItem(AppStaticStrings.pointsDeductedAutomatically),
          _buildNoteItem(AppStaticStrings.enableDisableRewardsAnytime),
        ],
      ),
    );
  }

  Widget _buildNoteItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        const CustomText(
          "• ",
          variant: TextVariant.labelSmall,
          color: Color(0xffA59BF9),
          fontWeight: FontWeight.bold,
        ),
        Expanded(
          child: CustomText(
            text,
            variant: TextVariant.labelSmall,
            color: AppColors.kSecondaryTextColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
