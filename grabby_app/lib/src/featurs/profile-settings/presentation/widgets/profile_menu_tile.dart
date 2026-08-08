import '../../../../src_export.dart';

class ProfileMenuTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool isBackground;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.isBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          margin: EdgeInsets.only(left: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.kAccentColor.withValues(alpha: 0.5)),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            icon,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              iconColor ?? AppColors.kPrimaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: CustomText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: iconColor ?? AppColors.kTextColor,
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.kSecondaryTextColor,
          size: 20,
        ),
      ),
    );
  }
}
