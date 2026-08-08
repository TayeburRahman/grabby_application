import '../../../../src_export.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final trailingWidget = trailing;
    return ButtonTapWidget(
      onTap: onTap,
      child: Row(
        spacing: 6,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(appRadius16),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.kPrimaryColor,
              size: 20,
            ),
          ),
          Expanded(
            child: CustomText(
              title,
              variant: TextVariant.labelMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (trailingWidget != null) trailingWidget,
          const Icon(
            Icons.chevron_right,
            color: AppColors.kSecondaryTextColor,
            size: 20,
          ),
        ],
      ),
    );
  }

}

