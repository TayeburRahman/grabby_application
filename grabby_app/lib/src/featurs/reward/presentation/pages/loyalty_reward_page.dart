import 'package:grabby_app/src/featurs/reward/presentation/bloc/reward_bloc.dart';

import '../../../../src_export.dart';

class LoyaltyRewardPage extends StatefulWidget {
  const LoyaltyRewardPage({super.key});

  @override
  State<LoyaltyRewardPage> createState() => _LoyaltyRewardPageState();
}

class _LoyaltyRewardPageState extends State<LoyaltyRewardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RewardBloc>()..add(GetWalletEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStaticStrings.loyaltyReward)),
        body: BlocBuilder<RewardBloc, RewardState>(
          builder: (context, state) {
            if (state.status == RewardStatus.loading && state.wallet == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == RewardStatus.error && state.wallet == null) {
              return Center(child: Text(state.errorMessage ?? "Error"));
            }

            final wallet = state.wallet;
            final points = wallet?.pointWallet ?? 0.0;
            final credits = wallet?.credWallet ?? 0.0;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<RewardBloc>().add(GetWalletEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppPadding.getPadding12(context).copyWith(top: 0),
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Point Card (Header)
                    Container(
                      width: double.infinity,
                      padding: AppPadding.getPadding16(context),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.kPrimaryColor,
                            AppColors.kSecondaryColor
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.emoji_events_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                          CustomText(
                            AppStaticStrings.totalPoints,
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          CustomText(
                            points.toStringAsFixed(0),
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          const Divider(color: Colors.white24, height: 12),
                          CustomText(
                            AppStaticStrings.earnedCredit,
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          CustomText(
                            "AED ${credits.toStringAsFixed(2)}",
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),

                    // Progress Cards for Tiers
                    _buildTierProgress(context, points, 500, 5),
                    _buildTierProgress(context, points, 1000, 10),
                    _buildTierProgress(context, points, 1500, 15),
                    _buildTierProgress(context, points, 2000, 20),

                    // Available Rewards Section
                    CustomText(
                      AppStaticStrings.availableRewards,
                      variant: TextVariant.titleMedium,
                    ),

                    _buildRewardCard(
                      context,
                      title: "5 ${AppStaticStrings.earnedCredit}",
                      subTitle: "500 ${AppStaticStrings.pointsRequired}",
                      isUnlocked: points >= 500,
                      currentPoints: points,
                      requiredPoints: 500,
                      rewardValue: 5,
                    ),

                    _buildRewardCard(
                      context,
                      title: "10 ${AppStaticStrings.earnedCredit}",
                      subTitle: "1000 ${AppStaticStrings.pointsRequired}",
                      isUnlocked: points >= 1000,
                      currentPoints: points,
                      requiredPoints: 1000,
                      rewardValue: 10,
                    ),

                    _buildRewardCard(
                      context,
                      title: "15 ${AppStaticStrings.earnedCredit}",
                      subTitle: "1500 ${AppStaticStrings.pointsRequired}",
                      isUnlocked: points >= 1500,
                      currentPoints: points,
                      requiredPoints: 1500,
                      rewardValue: 15,
                    ),

                    _buildRewardCard(
                      context,
                      title: "20 ${AppStaticStrings.earnedCredit}",
                      subTitle: "2000 ${AppStaticStrings.pointsRequired}",
                      isUnlocked: points >= 2000,
                      currentPoints: points,
                      requiredPoints: 2000,
                      rewardValue: 20,
                    ),

                    // Warning Banner
                    Container(
                      padding: AppPadding.getPadding12(context),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFEF3C7)),
                      ),
                      child: Row(
                        spacing: 12,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFFF59E0B),
                            size: 20,
                          ),
                          Expanded(
                            child: CustomText(
                              AppStaticStrings.validForSelectedShops,
                              fontSize: 12,
                              color: const Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // How Reward Points Work Section
                    Container(
                      width: double.infinity,
                      padding: AppPadding.getPadding16(context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          CustomText(
                            AppStaticStrings.howRewardPointsWork,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          _buildStepItem(
                            context,
                            number: "1",
                            title: AppStaticStrings.earnPoints,
                            description: AppStaticStrings.earnPointsDesc,
                          ),
                          _buildStepItem(
                            context,
                            number: "2",
                            title: AppStaticStrings.unlockRewards,
                            description: AppStaticStrings.unlockRewardsDesc,
                          ),
                          _buildStepItem(
                            context,
                            number: "3",
                            title: AppStaticStrings.redeemAndSave,
                            description: AppStaticStrings.redeemAndSaveDesc,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTierProgress(
      BuildContext context, double points, double target, double rewardValue) {
    final progress = (points / target).clamp(0.0, 1.0);
    final remaining = (target - points).clamp(0.0, target);

    return Container(
      width: double.infinity,
      padding: AppPadding.getPadding12(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Progress to $rewardValue AED Reward",
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.kTextColor,
              ),
              CustomText(
                "${points.toStringAsFixed(0)}/${target.toStringAsFixed(0)}",
                fontSize: 12,
                color: const Color(0xFFA59BF9),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFA59BF9),
              ),
            ),
          ),
          if (remaining > 0)
            CustomText(
              "${remaining.toStringAsFixed(0)} more points to unlock $rewardValue AED Grabby Credit",
              fontSize: 11,
              color: AppColors.kTextColor,
            )
          else
            const CustomText(
              "Reward Unlocked!",
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(
    BuildContext context, {
    required String title,
    required String subTitle,
    bool isUnlocked = false,
    required double currentPoints,
    required int requiredPoints,
    required double rewardValue,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ButtonTapWidget(
        onTap: isUnlocked
            ? () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: context.read<RewardBloc>(),
                    child: RedeemRewardPopup(
                      currentPoints: currentPoints,
                      requiredPoints: requiredPoints,
                      rewardValue: rewardValue,
                    ),
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 16,
            children: [
              Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? const Color(0xFFF3F2FF)
                      : Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  ImagesConstant.kGiftIcon,
                  colorFilter: ColorFilter.mode(
                    isUnlocked ? const Color(0xFFA59BF9) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    CustomText(
                      title,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isUnlocked ? const Color(0xFFA59BF9) : Colors.grey,
                    ),
                    CustomText(
                      subTitle,
                      fontSize: ResponsiveTextSizes.getFontSizeSmall(context),
                      color: AppColors.kSecondaryTextColor,
                    ),
                  ],
                ),
              ),
              if (!isUnlocked)
                const Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomText(
              number,
              fontSize: ResponsiveTextSizes.getFontSizeSmall(context),
              fontWeight: FontWeight.bold,
              color: AppColors.kPrimaryColor,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              CustomText(
                title,
                fontSize: ResponsiveTextSizes.getFontSizeSmall(context),
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                description,
                fontSize: ResponsiveTextSizes.getFontSizeSmall(context),
                color: AppColors.kSecondaryTextColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
