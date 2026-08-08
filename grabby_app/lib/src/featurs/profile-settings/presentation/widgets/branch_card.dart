import '../../../../src_export.dart';

class BranchCard extends StatelessWidget {
  final String name;
  final bool isDefault;
  final bool isActive;
  final String address;
  final String phone;
  final String hours;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const BranchCard({
    super.key,
    required this.name,
    this.isDefault = false,
    this.isActive = true,
    required this.address,
    required this.phone,
    required this.hours,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              name,
              variant: TextVariant.titleMedium,
              // fontWeight: FontWeight.bold,
            ),
            const SizedBox(width: 8),
            if (isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  "Default",
                  variant: TextVariant.labelSmall,
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: (isActive ? AppColors.kGreenColor : AppColors.kRedColor)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(appRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isActive ? AppColors.kGreenColor : AppColors.kRedColor,
              ),
              const SizedBox(width: 6),
              CustomText(
                isActive ? AppStaticStrings.active : AppStaticStrings.inactive,
                variant: TextVariant.labelSmall,
                color: isActive ? AppColors.kGreenColor : AppColors.kRedColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: AppPadding.getPadding16(context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(appRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.location_on_outlined, address),
              _buildInfoRow(Icons.phone_outlined, phone),
              _buildInfoRow(Icons.access_time, hours),
              const Divider(height: 12, color: AppColors.kBackgroundColor),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: AppStaticStrings.edit,
                      onPressed: onEdit,
                      backgroundColor: AppColors.kPrimaryColor.withValues(
                        alpha: 0.1,
                      ),
                      textColor: AppColors.kPrimaryColor,
                      icon: Icons.edit_outlined,
                      iconColor: AppColors.kPrimaryColor,
                      isExpanding: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.kRedColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(appRadius),
                    ),
                    child: IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.kRedColor,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const SizedBox(height: 24),
      ],
    ),
  );
}

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.kSecondaryTextColor),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
              text,
              variant: TextVariant.labelSmall,
              color: AppColors.kSecondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
