import 'package:cached_network_image/cached_network_image.dart';
import '../../../../src_export.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String memberSince;
  final String? imageUrl;
  final String? shopName;
  final VoidCallback onEditImage;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.memberSince,
    this.imageUrl,
    this.shopName,
    required this.onEditImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.getPadding12(context),
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shopName != null && shopName!.isNotEmpty)
            CustomText(
              shopName!,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          CustomText(
            name,
            fontSize: shopName != null && shopName!.isNotEmpty ? 18 : 24,
            fontWeight: shopName != null && shopName!.isNotEmpty ? FontWeight.w600 : FontWeight.bold,
            color: Colors.white,
          ),

          CustomText(
            email,
            fontSize: 14,
            color: AppColors.kWhiteTextColor,
            fontWeight: FontWeight.w600,
          ),

          CustomText(
            phone,
            fontSize: 14,
            color: AppColors.kWhiteTextColor,
            fontWeight: FontWeight.w600,
          ),

          CustomText(
            "${AppStaticStrings.memberSince} $memberSince",
            fontSize: 12,
            color: AppColors.kWhiteTextColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
