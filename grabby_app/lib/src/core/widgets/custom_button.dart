import '../../src_export.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final String? iconPath; // Use SVG asset path
  final IconData? icon; // Use Flutter IconData
  final bool isOutlined;
  final bool isLoading;
  final bool isExpanding;

  final double borderRadius;
  final Color? borderColor;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.iconPath,
    this.icon,
    this.isOutlined = false,
    this.isLoading = false,

    this.borderRadius = 12.0,
    this.borderColor,
    this.textStyle,
    this.isExpanding = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = AppColors.kPrimaryColor;

    return SizedBox(
      width: isExpanding ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined
              ? Colors.transparent
              : (backgroundColor ?? defaultColor),
          foregroundColor:
              textColor ?? (isOutlined ? AppColors.kTextColor : Colors.white),
          elevation: 0,
          side: isOutlined || borderColor != null
              ? BorderSide(
                  color:
                      borderColor ??
                      AppColors.kPrimaryColor.withValues(alpha: 0.5),
                ) // Custom border color or slightly visible border for outlined
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: AppPadding.getPaddingH12V4(context),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color:
                          iconColor ??
                          textColor ??
                          (isOutlined ? AppColors.kPrimaryColor : Colors.white),
                    ),
                    const SizedBox(width: 8),
                  ] else if (iconPath != null) ...[
                    if (iconPath!.endsWith('.svg'))
                      SvgPicture.asset(
                        iconPath!,
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          iconColor ??
                              textColor ??
                              (isOutlined
                                  ? AppColors.kTextColor
                                  : Colors.white),
                          BlendMode.srcIn,
                        ),
                      )
                    else
                      Image.asset(
                        iconPath!,
                        height: 20,
                        color:
                            iconColor ??
                            textColor ??
                            (isOutlined
                                ? AppColors.kPrimaryColor
                                : Colors.white),
                      ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style:
                        textStyle ??
                        theme.textTheme.titleSmall?.copyWith(
                          color:
                              textColor ??
                              (isOutlined
                                  ? AppColors.kPrimaryColor
                                  : Colors.white),
                          // fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
