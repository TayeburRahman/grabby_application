import '../../src_export.dart';

class ResponsiveTextSizes {
  static double getFontSizeSmall(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 15 : 12;
  }

  static double getFontSizeSemiSmall(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 16 : 14;
  }

  static double getFontSizeDefault(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 18 : 16;
  }

  static double getFontSizeLarge(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 20 : 16;
  }

  static double getFontSizeExtraLarge(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 20 : 18;
  }

  static double getButtonFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 26 : 20;
  }

  static double getLargeFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 26 : 24;
  }

  static double getButtonFontSizeLarge(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 30 : 24;
  }

  static double getFontSizeOverLarge(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1300 ? 56 : 46;
  }

  static double getFontSizeForReview() {
    return 36; // Static size, no need for responsiveness
  }
}
