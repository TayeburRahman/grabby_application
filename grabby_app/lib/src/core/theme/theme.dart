import '../../src_export.dart';

class AppTheme {
  static ThemeData getLightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Main Colors
      primaryColor: AppColors.kPrimaryColor,
      scaffoldBackgroundColor: AppColors.kBackgroundColor,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.kPrimaryColor,
        secondary: AppColors.kSecondaryColor,
        surface: AppColors.kBackgroundColor,
        error: AppColors.kRedColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.kTextColor,
        onError: Colors.white,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.kTextColor),
        titleTextStyle: TextStyle(
          color: AppColors.kTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Text Theme (Applies the text color globally)
      // ─────────────────────────────────────────────────────────────────
      //  ResponsiveTextSizes → TextTheme mapping (size-ordered reference)
      //
      //  Size Scale (mobile → desktop):
      //  small        12 → 15
      //  semiSmall    14 → 16
      //  default      16 → 18
      //  large        16 → 20
      //  extraLarge   18 → 20
      //  buttonSize   20 → 26
      //  largeFontSz  24 → 26
      //  buttonLarge  24 → 30
      //  overLarge    46 → 56
      //  forReview    36 (static)
      // ─────────────────────────────────────────────────────────────────
      textTheme: TextTheme(
        // ── Display ─────────────────────────────────────────────────────
        // Hero / banner text — largest sizes
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeOverLarge(
            context,
          ), // 46 → 56
          fontWeight: FontWeight.bold,
          color: AppColors.kTextColor,
        ),

        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getButtonFontSizeLarge(
            context,
          ), // 24 → 30
          fontWeight: FontWeight.w700,
          color: AppColors.kTextColor,
        ),

        displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getLargeFontSize(context), // 24 → 26
          fontWeight: FontWeight.w600,
          color: AppColors.kTextColor,
        ),

        // ── Headline ────────────────────────────────────────────────────
        // Section headers / page titles
        headlineLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getButtonFontSize(context), // 20 → 26
          fontWeight: FontWeight.bold,
          color: AppColors.kTextColor,
        ),

        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeExtraLarge(
            context,
          ), // 18 → 20
          fontWeight: FontWeight.w600,
          color: AppColors.kTextColor,
        ),

        headlineSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeLarge(context), // 16 → 20
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),

        // ── Title ───────────────────────────────────────────────────────
        // Card titles / list headers / modal titles
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeDefault(context), // 16 → 18
          fontWeight: FontWeight.bold,
          color: AppColors.kTextColor,
        ),

        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeDefault(context), // 16 → 18
          fontWeight: FontWeight.w600,
          color: AppColors.kTextColor,
        ),

        titleSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeSemiSmall(
            context,
          ), // 14 → 16
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),

        // ── Label ───────────────────────────────────────────────────────
        // Body text / captions / supporting text
        labelLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeSemiSmall(
            context,
          ), // 14 → 16
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),

        labelMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeSmall(context), // 12 → 15
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),

        labelSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeSmall(context), // 12 → 15
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),

        // ── Body (bonus — Flutter auto-uses these in widgets) ───────────
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeDefault(context), // 16 → 18
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),

        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeSemiSmall(
            context,
          ), // 14 → 16
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),

        bodySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveTextSizes.getFontSizeSmall(context), // 12 → 15
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.kTextColor),
    );
  }
}
