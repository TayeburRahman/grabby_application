import '../../../../src_export.dart';

class PromoCodeWidget extends StatelessWidget {
  final VoidCallback onApply;
  final TextEditingController controller;
  final String? statusMessage;
  final bool? isSuccess;

  const PromoCodeWidget({
    super.key,
    required this.onApply,
    required this.controller,
    this.statusMessage,
    this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppPadding.getPadding8(context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: CustomTextField(
                  textEditingController: controller,
                  hintText: AppStaticStrings.promoCode,
                ),
              ),
              ButtonTapWidget(
                onTap: onApply,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CustomText(
                    AppStaticStrings.apply,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (statusMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: CustomText(
              statusMessage!,
              fontSize: 12,
              color: isSuccess == true ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
