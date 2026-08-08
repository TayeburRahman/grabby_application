import '../../../../src_export.dart';

class ShopHomeHeader extends StatelessWidget {
  const ShopHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(GetProfileEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          } else if (state is ProfileLoaded) {
            final profile = state.profileData;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        profile.shopName ?? "",
                        variant: TextVariant.headlineMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        profile.addressName ?? '',
                        variant: TextVariant.bodyMedium,
                        color: AppColors.kSecondaryTextColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      ButtonTapWidget(
                        onTap: () {
                          context.pushNamed(RoutesPath.notificationPath);
                        },
                        child: SvgPicture.asset(
                          ImagesConstant.kNotificationIcon,
                          height: 24,
                          width: 24,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.kRedColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
