import '../../../../src_export.dart';

class MarketingCampaignsPage extends StatefulWidget {
  const MarketingCampaignsPage({super.key});

  @override
  State<MarketingCampaignsPage> createState() => _MarketingCampaignsPageState();
}

class _MarketingCampaignsPageState extends State<MarketingCampaignsPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _campaignTiers = [];

  @override
  void initState() {
    super.initState();
    _fetchPricingPlans();
  }

  Future<void> _fetchPricingPlans() async {
    setState(() { _isLoading = true; });
    try {
      final response = await sl<ApiService>().get<List<dynamic>>(
        ApiEndpoints.pricingPlan,
        fromJson: (json) => json['data'] as List<dynamic>,
      );
      if (response.success && response.data != null) {
        final List<dynamic> data = response.data!;
        setState(() {
          _campaignTiers = data.map((item) => {
            'tier': item['name'] ?? '',
            'duration': item['name'] ?? '',
            'features': (item['details'] as String?)?.split(',').map((e) => e.trim()).toList() ?? [],
            'price': item['price']?.toString() ?? '0',
            'perDay': item['perDay']?.toString() ?? '0',
            'icon': item['icon'] ?? '',
            'color': const Color(0xFF1E88E5),
            'fullData': item,
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() { _isLoading = false; _campaignTiers = []; });
      }
    } catch (e) {
      setState(() { _isLoading = false; _campaignTiers = []; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          AppStaticStrings.marketingCampaigns,
          variant: TextVariant.headlineSmall,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPricingPlans,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppPadding.getPadding12(context).copyWith(top: 0),
          child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "All Campaigns Include" section
            Container(
              padding: AppPadding.getPadding10(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 20,
                        color: AppColors.kPrimaryColor,
                      ),
                      space8W,
                      const CustomText(
                        AppStaticStrings.allCampaignsInclude,
                        variant: TextVariant.labelLarge,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimaryColor,
                      ),
                    ],
                  ),
                  const CheckmarkListItem(
                    icon: ImagesConstant.kRewardIcon,
                    title: AppStaticStrings.topListPlacement,
                    subtitle: AppStaticStrings.topListPlacementDesc,
                  ),
                  const CheckmarkListItem(
                    icon: ImagesConstant.kNotificationIcon,
                    title: AppStaticStrings.pushNotifications,
                    subtitle: AppStaticStrings.pushNotificationsDesc,
                  ),
                  const CheckmarkListItem(
                    // icon: ImagesConstant.kTopListPlacement,
                    title: AppStaticStrings.increasedVisibility,
                    subtitle: AppStaticStrings.increasedVisibilityDesc,
                  ),
                ],
              ),
            ),

            const CustomText(
              AppStaticStrings.chooseYourCampaignTier,
              variant: TextVariant.titleMedium,
              fontWeight: FontWeight.bold,
            ),

            // Campaign Tiers List
            _isLoading
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ))
                : _campaignTiers.isEmpty
                    ? const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("No campaigns available"),
                      ))
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _campaignTiers.length,
                        separatorBuilder: (context, index) => space12H,
                        itemBuilder: (context, index) {
                          final tier = _campaignTiers[index];
                          return TierCardWidget(tier: tier);
                        },
                      ),

            // FAQ Section
            const CustomText(
              AppStaticStrings.frequentlyAskedQuestions,
              variant: TextVariant.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            _buildFAQ(
              AppStaticStrings.howDoCampaignsWork,
              AppStaticStrings.campaignsWorkDesc,
            ),
            _buildFAQ(
              AppStaticStrings.canICancelCampaign,
              AppStaticStrings.cancelCampaignDesc,
            ),
            _buildFAQ(
              AppStaticStrings.howManyNotifications,
              AppStaticStrings.notificationsDesc,
            ),
            space24H,
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          question,
          variant: TextVariant.labelLarge,
          fontWeight: FontWeight.bold,
        ),
        space4H,
        CustomText(
          answer,
          variant: TextVariant.labelSmall,
          color: AppColors.kSecondaryTextColor,
        ),
        space12H,
      ],
    );
  }
}
