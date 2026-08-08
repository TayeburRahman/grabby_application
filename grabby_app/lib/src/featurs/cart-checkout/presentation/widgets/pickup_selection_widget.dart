import '../../../../src_export.dart';

class PickupSelectionWidget extends StatelessWidget {
  final bool isCarPickup;
  final ValueChanged<bool> onSelectionChanged;

  const PickupSelectionWidget({
    super.key,
    required this.isCarPickup,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding8(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          const CustomText(
            AppStaticStrings.pickupDetails,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.kPrimaryColor,
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: _buildPickupCard(
                  context,
                  icon: ImagesConstant.kCarIcon,
                  label: AppStaticStrings.carPickup,
                  isSelected: isCarPickup,
                  onTap: () => onSelectionChanged(true),
                ),
              ),
              Expanded(
                child: _buildPickupCard(
                  context,
                  icon: ImagesConstant.kContactPickupIcon,
                  label: AppStaticStrings.counterPickup,
                  isSelected: !isCarPickup,
                  onTap: () => onSelectionChanged(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPickupCard(
    BuildContext context, {
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ButtonTapWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFA59BF9) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : const Color(0xFFA59BF9).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          spacing: 8,
          children: [
            SvgPicture.asset(
              icon,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : const Color(0xFFA59BF9),
                BlendMode.srcIn,
              ),
            ),
            CustomText(
              label,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFFA59BF9),
            ),
          ],
        ),
      ),
    );
  }
}
