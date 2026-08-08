import '../../src_export.dart';

enum TextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  labelLarge,
  labelMedium,
  labelSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
}

class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    super.key,
    this.variant = TextVariant.labelMedium,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.letterSpacing,
    this.decoration,
    this.decorationColor,
    this.softWrap,
    this.style,
  });

  final String text;
  final TextVariant variant;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final bool? softWrap;

  /// Fully overrides all styling when provided
  final TextStyle? style;

  TextStyle? _resolveStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final base = switch (variant) {
      TextVariant.displayLarge => textTheme.displayLarge,
      TextVariant.displayMedium => textTheme.displayMedium,
      TextVariant.displaySmall => textTheme.displaySmall,
      TextVariant.headlineLarge => textTheme.headlineLarge,
      TextVariant.headlineMedium => textTheme.headlineMedium,
      TextVariant.headlineSmall => textTheme.headlineSmall,
      TextVariant.titleLarge => textTheme.titleLarge,
      TextVariant.titleMedium => textTheme.titleMedium,
      TextVariant.titleSmall => textTheme.titleSmall,
      TextVariant.labelLarge => textTheme.labelLarge,
      TextVariant.labelMedium => textTheme.labelMedium,
      TextVariant.labelSmall => textTheme.labelSmall,
      TextVariant.bodyLarge => textTheme.bodyLarge,
      TextVariant.bodyMedium => textTheme.bodyMedium,
      TextVariant.bodySmall => textTheme.bodySmall,
    };

    return base?.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: style ?? _resolveStyle(context),
    );
  }
}
