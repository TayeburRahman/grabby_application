import '../../../../src_export.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      title,
      fontSize: ResponsiveTextSizes.getFontSizeSemiSmall(context),
      fontWeight: FontWeight.bold,
    );
  }
}
