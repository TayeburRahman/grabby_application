import '../../../../src_export.dart';

class TrackingStepperWidget extends StatelessWidget {
  final int currentStep;

  const TrackingStepperWidget({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStep(
          context,
          title: AppStaticStrings.waitingForShopConfirmation,
          subtitle: "(Auto-Cancels In 5 Minutes)",
          isCompleted: currentStep >= 0,
          isLast: false,
          time: "4:52",
        ),
        _buildStep(
          context,
          title: AppStaticStrings.preparingYourOrder,
          isCompleted: currentStep >= 1,
          isLast: false,
        ),
        _buildStep(
          context,
          title: AppStaticStrings.readyForPickup,
          subtitle: "Your order is ready! Head to the café.",
          isCompleted: currentStep >= 2,
          isLast: false,
        ),
        _buildStep(
          context,
          title: AppStaticStrings.completed,
          isCompleted: currentStep >= 3,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String title,
    String? subtitle,
    required bool isCompleted,
    required bool isLast,
    String? time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFA59BF9)
                    : Colors.grey.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Center(
                      child: CustomText(
                        "",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? const Color(0xFFA59BF9)
                    : Colors.grey.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title,
                    fontSize: 14,
                    fontWeight: isCompleted
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isCompleted ? Colors.black : Colors.grey,
                  ),
                  if (time != null)
                    Row(
                      spacing: 4,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFFA59BF9),
                        ),
                        CustomText(
                          time,
                          fontSize: 12,
                          color: const Color(0xFFA59BF9),
                        ),
                      ],
                    ),
                ],
              ),
              if (subtitle != null)
                CustomText(
                  subtitle,
                  fontSize: 12,
                  color: AppColors.kSecondaryTextColor,
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
