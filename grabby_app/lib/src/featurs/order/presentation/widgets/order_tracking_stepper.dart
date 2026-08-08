import '../../../../src_export.dart';

class OrderTrackingStepper extends StatelessWidget {
  final int currentStep;

  const OrderTrackingStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding16(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        children: [
          _buildStep(
            context,
            title: AppStaticStrings.placedStatus,
            isCompleted: currentStep >= 0,
            isLast: false,
          ),
          // _buildStep(
          //   context,
          //   title: AppStaticStrings.acceptedStatus,
          //   isCompleted: currentStep >= 1,
          //   isLast: false,
          // ),
          _buildStep(
            context,
            title: AppStaticStrings.preparing,
            isCompleted: currentStep >= 1,
            isLast: false,
          ),
          _buildStep(
            context,
            title: AppStaticStrings.ready,
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
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String title,
    required bool isCompleted,
    required bool isLast,
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
                color: isCompleted ? const Color(0xFFA59BF9) : Colors.white,
                shape: BoxShape.circle,
                border: isCompleted
                    ? null
                    : Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(width: 1, height: 30, color: Colors.grey.shade400),
          ],
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: CustomText(
            title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isCompleted
                ? AppColors.kTextColor
                : AppColors.kSecondaryTextColor,
          ),
        ),
      ],
    );
  }
}
