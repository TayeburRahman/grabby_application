import '../../../../src_export.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProfileBloc>()..add(GetProfileEvent()),
        ),
        BlocProvider(
          create: (context) => sl<OrderBloc>()..add(FetchMyOrdersEvent()),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                final profile = state.profileData;
                final memberSince = DateFormat(
                  'MMMM yyyy',
                ).format(profile.createdAt);

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProfileBloc>().add(GetProfileEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppPadding.getPadding12(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        // Header
                        ProfileHeader(
                          name: profile.name,
                          email: profile.email,
                          phone: profile.phoneNumber,
                          memberSince: memberSince,
                          imageUrl: profile.profileImage,
                          shopName: profile.authId.role == 'SHOP_OWNER'
                              ? profile.shopName
                              : null,
                          onEditImage: () {
                            context.pushNamed(RoutesPath.personalInfoPath);
                          },
                        ),

                        // Metric Card
                        BlocBuilder<OrderBloc, OrderState>(
                          builder: (context, orderState) {
                            return ProfileMetricCard(
                              icon: ImagesConstant.kGiftIcon,
                              value: orderState.totalOrders?.toString() ?? "0",
                              label: "Orders",
                            );
                          },
                        ),

                        // Menu List
                        Column(
                          spacing: 8,
                          children: [
                            ProfileMenuTile(
                              icon: ImagesConstant.kProfileIcon,
                              title: AppStaticStrings.personalInformation,
                              onTap: () => context.pushNamed(
                                RoutesPath.personalInfoPath,
                              ),
                            ),
                            ProfileMenuTile(
                              icon: ImagesConstant.kCardIcon,
                              title: AppStaticStrings.paymentMethods,
                              onTap: () {
                                // Navigate to payment methods
                              },
                            ),
                            ProfileMenuTile(
                              icon: ImagesConstant.kCarIcon,
                              title: AppStaticStrings.carPlates,
                              onTap: () =>
                                  context.pushNamed(RoutesPath.carPlatesPath),
                            ),
                          ],
                        ),

                        // Preferences Section
                        Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileMenuTile(
                              icon: ImagesConstant.kNotificationIcon,
                              title: AppStaticStrings.notifications,
                              onTap: () => context.pushNamed(
                                RoutesPath.notificationPath,
                              ),
                            ),
                            ProfileMenuTile(
                              icon: ImagesConstant.kSettingsIcon,
                              title: AppStaticStrings.settings,
                              onTap: () => context.pushNamed(
                                RoutesPath.accountSettingsPath,
                              ),
                            ),
                            // ProfileMenuTile(
                            //   icon: ImagesConstant.kLocationIcon,
                            //   title: AppStaticStrings.suggestAShop,
                            //   onTap: () => context.pushNamed(RoutesPath.suggestAShopPath),
                            // ),
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
                        space24H,
                      ],
                    ),
                  ),
                );
              } else if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(GetProfileEvent());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
