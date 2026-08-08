import '../../src_export.dart';

class CheckmarkListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? icon;
  final Color? iconColor;
  final Color? textColor;

  const CheckmarkListItem({
    this.icon,
    super.key,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.kPrimaryColor).withValues(
              alpha: 0.1,
            ),
            shape: BoxShape.circle,
          ),
          child: icon != null
              ? SvgPicture.asset(
                  icon ?? "",
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? AppColors.kPrimaryColor,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(
                  Icons.trending_up,
                  size: 16,
                  color: iconColor ?? AppColors.kPrimaryColor,
                ),
        ),
        space12W,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                variant: TextVariant.labelMedium,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              if (subtitle != null) ...[
                space2H,
                CustomText(
                  subtitle!,
                  variant: TextVariant.labelSmall,
                  color: AppColors.kSecondaryTextColor,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
