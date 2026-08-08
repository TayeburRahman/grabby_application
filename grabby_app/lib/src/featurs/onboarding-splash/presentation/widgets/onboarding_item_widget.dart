import '../../../../src_export.dart';

class OnboardingItemWidget extends StatelessWidget {
  const OnboardingItemWidget({
    super.key,
    required this.item,
    required this.onboardingData,
    required this.index,
  });

  final Map<String, dynamic> item;
  final int index;
  final List<Map<String, dynamic>> onboardingData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.6),
              BlendMode.darken,
            ),
            child: Image.asset(item['img'], fit: BoxFit.cover),
          ),
        ),
        Padding(
          padding: AppPadding.getPadding12(context),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              item['title'],
              CustomText(
                item['subtitle'],
                color: AppColors.kWhiteTextColor,
                textAlign: TextAlign.center,
              ),
              space4H,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 4,
                children: List.generate(
                  onboardingData.length,
                  (i) => Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: i == index ? Colors.white : Colors.white24,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              if (index == onboardingData.length - 1)
                Padding(
                  padding: AppPadding.getPadding12V(context),
                  child: CustomButton(
                    text: item['buttonText'] ?? AppStaticStrings.startOrdering,
                    onPressed: () {
                      context.read<OnboardingSplashBloc>().add(
                        OnboardingCompleted(),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
