import 'dart:ui';
import '../../../../src_export.dart';

class CafeCardWidget extends StatelessWidget {
  final String title;
  final String image;
  final String distance;
  final String openHours;
  final String status;
  final List<String> tags;
  final VoidCallback onTap;

  const CafeCardWidget({
    super.key,
    required this.title,
    required this.image,
    required this.distance,
    required this.openHours,
    required this.status,
    required this.onTap,
    this.tags = const ["Car", "Counter"],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          appRadius,
        ).copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ButtonTapWidget(
        onTap: onTap,
        child: Column(
          children: [
            // Top Section: Image and Overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                // Title and Distance
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title,
                        variant: TextVariant.titleLarge,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      if (distance.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.kBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomText(
                            distance,
                            variant: TextVariant.labelSmall,
                            color: AppColors.kTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                // Open Now Tag
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      status,
                      variant: TextVariant.labelSmall,
                      color: status.toLowerCase() == "closed"
                          ? AppColors.kRedColor
                          : AppColors.kGreenColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Bottom Section: Time and Categories
            Padding(
              padding: AppPadding.getPadding8(context),
              child: Row(
                children: [
                  // Opening Time
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: AppColors.kSecondaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: CustomText(
                            "${AppStaticStrings.open} $openHours",
                            variant: TextVariant.labelSmall,
                            color: AppColors.kSecondaryTextColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tags (Car, Counter)
                  Row(
                    spacing: 8,
                    children: tags.map((tag) {
                      bool isCar = tag.toLowerCase().contains("car");
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              isCar
                                  ? ImagesConstant.kCarIcon
                                  : ImagesConstant.kGroupIcon,
                              height: 14,
                              colorFilter: ColorFilter.mode(
                                AppColors.kPrimaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                              tag,
                              variant: TextVariant.labelSmall,
                              color: AppColors.kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
