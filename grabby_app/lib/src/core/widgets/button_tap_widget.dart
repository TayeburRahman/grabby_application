import '../../src_export.dart';

class ButtonTapWidget extends StatelessWidget {
  const ButtonTapWidget({
    super.key,
    required this.child,
    this.onTap,
    this.radius,
    this.shape,
  });

  final Widget child;
  final Function()? onTap;
  final double? radius;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(

        customBorder: shape,
        splashColor: AppColors.kPrimaryColor.withValues(alpha: .2),
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ??appRadius),
        child: child,
      ),
    );
  }
}