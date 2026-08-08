import 'package:grabby_app/src/featurs/reward/presentation/bloc/reward_bloc.dart';

import '../../../../src_export.dart';

class RedeemRewardPopup extends StatelessWidget {
  final double currentPoints;
  final int requiredPoints;
  final double rewardValue;

  const RedeemRewardPopup({
    super.key,
    required this.currentPoints,
    required this.requiredPoints,
    required this.rewardValue,
  });

  @override
  Widget build(BuildContext context) {
    final remainingPoints = currentPoints - requiredPoints;

    return BlocListener<RewardBloc, RewardState>(
      listener: (context, state) {
        if (state.status == RewardStatus.conversionSuccess) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? "Redemption successful!"),
            ),
          );
        } else if (state.status == RewardStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? "Error occurred")),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  ImagesConstant.kGiftIcon,
                  height: 32,
                  width: 32,
                  colorFilter: const ColorFilter.mode(
                    Colors.white, // White icon
                    BlendMode.srcIn,
                  ),
                ),
              ),

              // Title and Description
              Column(
                spacing: 4,
                children: [
                  CustomText(
                    AppStaticStrings.redeemRewardTitle,
                    fontSize: ResponsiveTextSizes.getFontSizeExtraLarge(
                      context,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    "You are about to redeem $requiredPoints points for $rewardValue AED Grabby Credit.",
                    textAlign: TextAlign.center,
                    fontSize: ResponsiveTextSizes.getFontSizeSmall(context),
                    color: AppColors.kSecondaryTextColor,
                  ),
                ],
              ),

              space12H,

              // Points Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  spacing: 4,
                  children: [
                    _buildPointRow(
                      context,
                      AppStaticStrings.currentPoints,
                      currentPoints.toStringAsFixed(0),
                      isBold: false,
                    ),
                    _buildPointRow(
                      context,
                      AppStaticStrings.pointsRequiredLabel,
                      "-$requiredPoints",
                      isBold: false,
                      color: AppColors.kRedColor,
                    ),
                    const Divider(color: Colors.black12),
                    _buildPointRow(
                      context,
                      AppStaticStrings.remainingPoints,
                      remainingPoints.toStringAsFixed(0),
                      isBold: true,
                      color: AppColors.kPrimaryColor,
                    ),
                  ],
                ),
              ),

              // space12H,

              // Buttons
              Column(
                spacing: 12,
                children: [
                  BlocBuilder<RewardBloc, RewardState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: state.status == RewardStatus.converting
                            ? "Converting..."
                            : AppStaticStrings.confirmRedemption,
                        onPressed: state.status == RewardStatus.converting
                            ? () {}
                            : () {
                                context.read<RewardBloc>().add(
                                  ConvertPointsEvent(requiredPoints),
                                );
                              },
                        backgroundColor: AppColors.kPrimaryColor,
                        borderRadius: 12,
                      );
                    },
                  ),
                  CustomButton(
                    text: AppStaticStrings.cancel,
                    onPressed: () => context.pop(),
                    backgroundColor: Colors.white,
                    textColor: AppColors.kTextColor,
                    isOutlined: true,
                    borderColor: Colors.black12,
                    borderRadius: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          fontSize: ResponsiveTextSizes.getFontSizeSmall(context),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: isBold ? AppColors.kTextColor : AppColors.kSecondaryTextColor,
        ),
        CustomText(
          value,
          fontSize: ResponsiveTextSizes.getFontSizeSmall(context),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: color,
        ),
      ],
    );
  }
}
