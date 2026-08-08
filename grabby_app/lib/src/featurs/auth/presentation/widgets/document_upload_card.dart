import '../../../../src_export.dart';

class DocumentUploadCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onUpload;

  const DocumentUploadCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.getPadding8(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        spacing: 8,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.file_upload_outlined,
              color: AppColors.kPrimaryColor,
              size: 28,
            ),
          ),
          Column(
            children: [
              CustomText(
                title,
                variant: TextVariant.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              if (subtitle != null)
                CustomText(
                  subtitle!,
                  variant: TextVariant.labelSmall,
                  color: AppColors.kSecondaryTextColor,
                ),
            ],
          ),
          SizedBox(
            width: 150,
            child: CustomButton(
              text: AppStaticStrings.uploadDocument,
              onPressed: onUpload,
            ),
          ),
        ],
      ),
    );
  }
}
