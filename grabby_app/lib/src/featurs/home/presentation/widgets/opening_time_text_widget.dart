import '../../../../src_export.dart';

class OpeningTimeTextWidget extends StatelessWidget {
  const OpeningTimeTextWidget({super.key, this.openHours, this.isOpen});

  final String? openHours;
  final bool? isOpen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time_filled,
          size: 16,
          color: isOpen == false ? AppColors.kRedColor : AppColors.kGreenColor,
        ),
        const SizedBox(width: 6),
        CustomText(
          openHours ?? "Open 24 Hours",
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isOpen == false ? AppColors.kRedColor : AppColors.kGreenColor,
        ),
      ],
    );
  }
}
