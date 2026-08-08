import '../../../../src_export.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  const OnboardingProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.getPadding12(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep(
            context,
            1,
            AppStaticStrings.businessInfoLabel,
            Icons.store_outlined,
          ),
          _buildDivider(context, 1),
          _buildStep(
            context,
            2,
            AppStaticStrings.branchesLabel,
            Icons.business_outlined,
          ),
          _buildDivider(context, 2),
          _buildStep(
            context,
            3,
            AppStaticStrings.documentsLabel,
            Icons.description_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    int step,
    String label,
    IconData icon,
  ) {
    bool isActive = currentStep >= step;
    bool isCompleted = currentStep > step;

    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.kSecondaryColor
                : isActive
                ? AppColors.kPrimaryColor
                : Colors.grey.shade100,
          ),
          child: Icon(
            isCompleted ? Icons.check_circle_outline : icon,
            size: 20,
            color: isCompleted
                ? Colors.white
                : isActive
                ? Colors.white
                : Colors.grey,
          ),
        ),
        space4H,
        CustomText(
          label,
          variant: TextVariant.labelSmall,
          color: isCompleted
              ? AppColors.kSecondaryColor
              : isActive
              ? AppColors.kPrimaryColor
              : Colors.grey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context, int afterStep) {
    bool isActive = currentStep > afterStep;
    bool isCompleted = currentStep > afterStep;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
        child: Container(
          height: 2,
          color: isCompleted
              ? AppColors.kSecondaryColor
              : isActive
              ? AppColors.kPrimaryColor
              : Colors.grey.shade200,
        ),
      ),
    );
  }
}
