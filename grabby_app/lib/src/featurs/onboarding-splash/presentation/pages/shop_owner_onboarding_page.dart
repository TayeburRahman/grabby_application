import 'package:flutter/gestures.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/data/models/faq_model.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/data/models/fee_structure_model.dart';
import 'package:grabby_app/src/featurs/onboarding-splash/presentation/bloc/info_bloc/onboarding_info_bloc.dart';

import '../../../../src_export.dart';

class ShopOwnerOnboardingPage extends StatefulWidget {
  const ShopOwnerOnboardingPage({super.key});

  @override
  State<ShopOwnerOnboardingPage> createState() =>
      _ShopOwnerOnboardingPageState();
}

class _ShopOwnerOnboardingPageState extends State<ShopOwnerOnboardingPage> {
  bool isTabletDedicated = false;

  final List<Map<String, String>> benefits = [
    {
      'title': AppStaticStrings.instantSetup,
      'icon': ImagesConstant.kVerifiedIcon,
    },
    {'title': AppStaticStrings.shopExposure, 'icon': ImagesConstant.kSoundIcon},
    {
      'title': AppStaticStrings.onDemandSupport,
      'icon': ImagesConstant.kCallIcon2,
    },
    {
      'title': AppStaticStrings.customerLoyalty,
      'icon': ImagesConstant.kLoyalityStamps,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<OnboardingSplashBloc>()),
        BlocProvider(
          create: (context) =>
              sl<OnboardingInfoBloc>()..add(GetOnboardingInfoEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<OnboardingSplashBloc, OnboardingSplashState>(
            listener: (context, state) {
              if (state is ShowRoleSelection) {
                context.go(RoutesPath.loginPath);
              }
            },
            child: Scaffold(
              body: SafeArea(
                child: BlocBuilder<OnboardingInfoBloc, OnboardingInfoState>(
                  builder: (context, infoState) {
                    return SingleChildScrollView(
                      padding: AppPadding.getPadding12(context),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo Header
                          Center(
                            child: Container(
                              padding: AppPadding.getPadding12(context),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(appRadius16),
                              ),
                              child: Center(
                                child: Image.asset(ImagesConstant.kAppIcon,
                                    height: 120),
                              ),
                            ),
                          ),

                          // Business Benefits Section
                          const Center(
                            child: CustomText(
                              AppStaticStrings.whatYourBusinessWillReceive,
                              variant: TextVariant.headlineSmall,
                            ),
                          ),

                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2,
                            ),
                            itemCount: benefits.length,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: AppPadding.getPadding8(context),
                                    decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor.withValues(
                                          alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      benefits[index]['icon']!,
                                      height: 24,
                                      width: 24,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.kPrimaryColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  CustomText(
                                    benefits[index]['title']!,
                                    variant: TextVariant.labelMedium,
                                    color: AppColors.kPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          ),

                          // Fees Structure Card
                          if (infoState.status == OnboardingInfoStatus.loading)
                            const Center(child: CircularProgressIndicator())
                          else if (infoState.feeStructures.isNotEmpty)
                            _buildFeeStructureCard(
                                context, infoState.feeStructures.first),

                          // Checkbox Section
                          Row(
                            children: [
                              Checkbox(
                                value: isTabletDedicated,
                                activeColor: AppColors.kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    isTabletDedicated = value ?? false;
                                  });
                                },
                              ),
                              const Expanded(
                                child: CustomText(
                                  AppStaticStrings.tabletDedicatedCheck,
                                  variant: TextVariant.labelSmall,
                                ),
                              ),
                            ],
                          ),

                          // FAQ Section
                          const Center(
                            child: CustomText(
                              AppStaticStrings.frequentlyAskedQuestions,
                              variant: TextVariant.titleMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          if (infoState.status == OnboardingInfoStatus.loading)
                             const Center(child: CircularProgressIndicator())
                          else
                            _buildFaqSection(infoState.faqs),

                          // Next Button
                          CustomButton(
                            text: AppStaticStrings.next,
                            onPressed: () {
                              context.read<OnboardingSplashBloc>().add(
                                    OnboardingCompleted(),
                                  );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeeStructureCard(
      BuildContext context, FeeStructureModel structure) {
    // Basic HTML tag removal for demonstration if specialized parser isn't available
    final cleanedDescription = structure.description
        .replaceAll(RegExp(r'<[^>]*>'), '\n')
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && !e.contains("Note:"))
        .toList();

    return Container(
      width: double.infinity,
      padding: AppPadding.getPadding8(context),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E5FF),
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(
              structure.title.isEmpty
                  ? AppStaticStrings.feesStructure
                  : structure.title,
              variant: TextVariant.titleMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...cleanedDescription.map((item) => _buildFeeItem(item)),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.kTextColor.withValues(alpha: 0.7),
                  ),
              children: [
                const TextSpan(text: "Note: The agreement is the "),
                TextSpan(
                  text: AppStaticStrings.termsAndConditions,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.pushNamed(RoutesPath.termsAndConditionsPath);
                    },
                  style: const TextStyle(
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(List<FaqModel> faqs) {
    if (faqs.isEmpty) return const SizedBox();
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          shape: const Border(),
          childrenPadding: EdgeInsets.zero,
          title: CustomText(
            "${index + 1}. ${faqs[index].question}",
            variant: TextVariant.labelMedium,
            fontWeight: FontWeight.w500,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomText(
                faqs[index].answer,
                variant: TextVariant.bodySmall,
                color: AppColors.kSecondaryTextColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText("• ", variant: TextVariant.labelMedium),
          Expanded(child: CustomText(text, variant: TextVariant.labelMedium)),
        ],
      ),
    );
  }
}
