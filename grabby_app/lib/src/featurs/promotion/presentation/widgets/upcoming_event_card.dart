import '../../../../src_export.dart';

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String? icon; // Can be emoji
  final String? imageUrl;

  const UpcomingEventCard({
    super.key,
    required this.title,
    required this.date,
    this.icon,
    this.imageUrl,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageUrl != null)
            CustomNetworkImage(
              imageUrl: imageUrl!.startsWith('http')
                  ? imageUrl!
                  : ApiEndpoints.baseUrl + imageUrl!,
              height: 40,
              width: 40,
              radius: 8,
            )
          else if (icon != null)
            CustomText(icon!, variant: TextVariant.headlineMedium),
          const SizedBox(height: 8),
          CustomText(
            title,
            variant: TextVariant.labelMedium,
            fontWeight: FontWeight.bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            date,
            variant: TextVariant.labelSmall,
            color: AppColors.kSecondaryTextColor,
          ),
        ],
      ),
    );
  }
}
