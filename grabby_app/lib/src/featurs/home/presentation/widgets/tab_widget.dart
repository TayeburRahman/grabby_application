import '../../../../src_export.dart';

class TabWidget extends StatelessWidget {
  final String title;
  final String img;
  final bool isSelected;
  final VoidCallback onTap;
  const TabWidget({
    super.key,
    required this.title,
    required this.img,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ButtonTapWidget(
          onTap: onTap,
          child: Padding(
            padding: AppPadding.getPadding12(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  img,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : AppColors.kSecondaryTextColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomText(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    color: isSelected
                        ? Colors.white
                        : AppColors.kSecondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
