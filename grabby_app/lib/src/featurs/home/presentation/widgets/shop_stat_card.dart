import '../../../../src_export.dart';

class ShopStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? iconPath;
  final Widget? iconContent;
  final Color iconColor;
  final Color bgColor;

  const ShopStatCard({
    super.key,
    required this.title,
    required this.value,
    this.iconPath,
    this.iconContent,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding12(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: AppPadding.getPadding12(context),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child:
                iconContent ??
                SvgPicture.asset(
                  iconPath!,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                variant: TextVariant.labelSmall,
                color: AppColors.kSecondaryTextColor,
              ),
              CustomText(
                value,
                variant: TextVariant.titleLarge,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
