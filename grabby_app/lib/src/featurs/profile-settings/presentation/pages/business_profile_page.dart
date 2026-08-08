import 'package:grabby_app/src/core/utils/launcher_utils.dart';
import 'package:grabby_app/src/featurs/home/presentation/bloc/shop_dashboard_bloc.dart';
import 'package:grabby_app/src/featurs/support/presentation/bloc/support_bloc.dart';

import '../../../../src_export.dart';

class BusinessProfilePage extends StatelessWidget {
  const BusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProfileBloc>()..add(GetProfileEvent()),
        ),
        BlocProvider(
          create: (context) => sl<SupportBloc>()..add(GetHelpCenterEvent()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            AppStaticStrings.businessProfile,
            variant: TextVariant.headlineSmall,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) async {
            if (state is StripeConnectOnboardingLinkLoaded) {
              await context.pushNamed(
                RoutesPath.stripeConnectWebviewPath,
                extra: state.url,
              );
              if (context.mounted) {
                context.read<ProfileBloc>().add(GetProfileEvent());
              }
            } else if (state is ProfileError) {

              CustomSnackbar.show(context, state.message, isError: true);
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final profile = state.profileData;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(GetProfileEvent());
                  context.read<SupportBloc>().add(GetHelpCenterEvent());
                },
                child: SingleChildScrollView(
                  padding: AppPadding.getPadding12H(context),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBusinessHeader(context, profile),
                      space2H,
                      _buildStatsRow(context),
                      space2H,
                      _buildBankAccountItem(context, profile),
                      Divider(color: Colors.white, height: 1),
                      ProfileMenuItem(
                        title: AppStaticStrings.branchManagement,
                        icon: Icons.store_outlined,
                        onTap: () =>
                            context.pushNamed(RoutesPath.branchManagementName),
                      ),

                      Divider(color: Colors.white, height: 1),
                      ProfileMenuItem(
                        title: AppStaticStrings.branchTimings,
                        icon: Icons.location_on_outlined,
                        onTap: () =>
                            context.pushNamed(RoutesPath.branchTimingsName),
                      ),
                      Divider(color: Colors.white, height: 1),
                      ProfileMenuItem(
                        title: AppStaticStrings.marketingCampaigns,
                        icon: Icons.campaign_outlined,
                        onTap: () => context.pushNamed(
                          RoutesPath.marketingCampaignsName,
                        ),
                      ),
                      Divider(color: Colors.white, height: 1),
                      ProfileMenuItem(
                        title: AppStaticStrings.settings,
                        icon: Icons.settings_outlined,
                        onTap: () =>
                            context.pushNamed(RoutesPath.accountSettingsPath),
                      ),
                      Divider(color: Colors.white, height: 1),
                      ProfileMenuItem(
                        title: AppStaticStrings.notifications,
                        icon: Icons.notifications_none_outlined,
                        onTap: () =>
                            context.pushNamed(RoutesPath.notificationPath),
                      ),
                      // Divider(color: Colors.white, height: 1),
                      // ProfileMenuItem(
                      //   title: AppStaticStrings.rewardSettings,
                      //   icon: Icons.card_giftcard_outlined,
                      //   onTap: () => context.pushNamed(RoutesPath.rewardSettingsName),
                      // ),
                      Divider(color: Colors.white, height: 1),
                      BlocListener<SupportBloc, SupportState>(
                        listener: (context, state) {
                          if (state is SupportError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        child: ProfileMenuItem(
                          title: AppStaticStrings.helpCenter,
                          icon: Icons.help_outline,
                          onTap: () {
                            final state = context.read<SupportBloc>().state;
                            if (state is HelpCenterLoaded &&
                                state.data.isNotEmpty) {
                              LauncherUtils.makePhoneCall(
                                state.data.first.phone,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Help center contact not available",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Divider(color: Colors.white, height: 1),
                      ProfileMenuItem(
                        title: AppStaticStrings.termsAndConditions,
                        icon: Icons.description_outlined,
                        onTap: () => context.pushNamed(
                          RoutesPath.termsAndConditionsPath,
                        ),
                      ),
                      Divider(color: Colors.white, height: 1),
                      CustomButton(
                        text: AppStaticStrings.logOut,
                        onPressed: () async {
                          await sl<LocalStorageService>().clearAuthData();
                          if (context.mounted) {
                            context.goNamed(RoutesPath.loginPath);
                          }
                        },
                        icon: Icons.logout,
                        iconColor: AppColors.kRedColor,
                        textColor: AppColors.kTextColor,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBusinessHeader(BuildContext context, ProfileData profile) {
    return Container(
      padding: AppPadding.getPadding12(context),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffA59BF9), Color(0xff7B6FD8)],
        ),
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 6,
            children: [
              CustomNetworkImage(
                imageUrl: profile.profileImage != null
                    ? "${ApiEndpoints.baseUrl}${profile.profileImage}"
                    : "",
                width: 60,
                height: 60,
                radius: 12,
                imageErrorUrl: ImagesConstant.kOnboard1Img,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      profile.shopName ?? profile.name,
                      variant: TextVariant.titleLarge,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      profile.authId.role.replaceAll('_', ' '),
                      variant: TextVariant.labelSmall,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ),
              FloatingActionButton.small(
                onPressed: () {
                  context.pushNamed(RoutesPath.personalInfoPath);
                },
                child: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          CustomText(
            profile.email,
            variant: TextVariant.labelMedium,
            color: Colors.white,
          ),
          CustomText(
            profile.phoneNumber,
            variant: TextVariant.labelMedium,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return BlocBuilder<ShopDashboardBloc, ShopDashboardState>(
      builder: (context, state) {
        final stats = state.stats;
        return Row(
          spacing: 6,
          children: [
            Expanded(
              child: ProfileStatCard(
                label: AppStaticStrings.totalRevenue,
                value:
                    "AED ${stats?.totalRevenue.toStringAsFixed(2) ?? "0.00"}",
                icon: Icons.attach_money,
                iconColor: AppColors.kGreenColor,
              ),
            ),
            Expanded(
              child: ProfileStatCard(
                label: AppStaticStrings.totalOrders,
                value: "${stats?.totalOrders ?? 0}",
                icon: Icons.trending_up,
                iconColor: AppColors.kPrimaryColor,
              ),
            ),
            Expanded(
              child: ProfileStatCard(
                label: AppStaticStrings.customers,
                value: "${stats?.totalUniqueCustomers ?? 0}",
                icon: Icons.people_outline,
                iconColor: AppColors.kSecondaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBankAccountItem(BuildContext context, ProfileData profile) {
    final bool isConnected = profile.stripeAccountConnected == true;
    final String bankName = profile.bankDetails?.bankName ?? '';
    final String last4 = profile.bankDetails?.accountNumberLast4 ?? '';
    final String statusText = isConnected
        ? (bankName.isNotEmpty ? '$bankName •••• $last4' : AppStaticStrings.bankAccountConnected)
        : AppStaticStrings.connectBankAccount;

    return ProfileMenuItem(
      title: AppStaticStrings.bankAccountAndPayouts,
      icon: isConnected ? Icons.account_balance : Icons.account_balance_outlined,
      onTap: () {
        context.read<ProfileBloc>().add(GetStripeConnectOnboardingLinkEvent());
      },
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isConnected
              ? AppColors.kGreenColor.withValues(alpha: 0.15)
              : Colors.orange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          statusText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isConnected ? AppColors.kGreenColor : Colors.orange,
          ),
        ),
      ),
    );
  }
}

