import '../../../../src_export.dart';

class TimingRow extends StatelessWidget {
  final String day;
  final bool isOpen;
  final String openingTime;
  final String closingTime;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onOpeningTimeTap;
  final VoidCallback? onClosingTimeTap;

  const TimingRow({
    super.key,
    required this.day,
    required this.isOpen,
    required this.openingTime,
    required this.closingTime,
    this.onToggle,
    this.onOpeningTimeTap,
    this.onClosingTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              day,
              variant: TextVariant.titleSmall,
              fontWeight: FontWeight.bold,
            ),
            ButtonTapWidget(
              onTap: () {
                if (onToggle != null) {
                  onToggle!(!isOpen);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isOpen
                      ? AppColors.kGreenColor.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  isOpen ? "Open" : "Closed",
                  variant: TextVariant.labelSmall,
                  color: isOpen ? AppColors.kGreenColor : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        Row(
          spacing: 4,
          children: [
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    AppStaticStrings.openingTime,
                    variant: TextVariant.labelSmall,
                    color: AppColors.kSecondaryTextColor,
                  ),

                  ButtonTapWidget(
                    onTap: onOpeningTimeTap,
                    child: _buildTimeDropdown(openingTime),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    AppStaticStrings.closingTime,
                    variant: TextVariant.labelSmall,
                    color: AppColors.kSecondaryTextColor,
                  ),

                  ButtonTapWidget(
                    onTap: onClosingTimeTap,
                    child: _buildTimeDropdown(closingTime),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeDropdown(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius16),
        border: Border.all(
          color: AppColors.kSecondaryTextColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            time,
            variant: TextVariant.labelSmall,
            fontWeight: FontWeight.w600,
          ),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black),
        ],
      ),
    );
  }
}
