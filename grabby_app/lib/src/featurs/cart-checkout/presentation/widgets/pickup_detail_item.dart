import '../../../../src_export.dart';

class PickupDetailItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? backgroundColor;
  const PickupDetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor ?? const Color(0xFFF3F2FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: icon.endsWith('.svg')
              ? SvgPicture.asset(
                  icon,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? const Color(0xFFA59BF9),
                    BlendMode.srcIn,
                  ),
                )
              : Icon(
                  Icons.access_time_filled,
                  color: Color(0xFFA59BF9),
                  size: 20,
                ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            CustomText(title, fontSize: 14, fontWeight: FontWeight.bold),
            CustomText(
              subtitle,
              fontSize: 12,
              color: AppColors.kSecondaryTextColor,
            ),
          ],
        ),
      ],
    );
  }
}
