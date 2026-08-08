import 'package:grabby_app/src/featurs/home/presentation/bloc/promoted_ads_bloc.dart';
import '../../../../src_export.dart';

class PromotedShopsSheet extends StatelessWidget {
  const PromotedShopsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPadding.getPadding12(context),
      decoration: const BoxDecoration(
        color: AppColors.kBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          CustomText(
            AppStaticStrings.promotedShops,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),

          CustomText(
            AppStaticStrings.promotedShopsDesc,
            fontSize: 14,
            color: AppColors.kSecondaryTextColor,
            textAlign: TextAlign.center,
          ),

          Flexible(
            child: BlocBuilder<PromotedAdsBloc, PromotedAdsState>(
              builder: (context, state) {
                if (state is PromotedAdsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PromotedAdsError) {
                  return Center(child: CustomText(state.message));
                } else if (state is PromotedAdsLoaded) {
                  if (state.ads.isEmpty) {
                    return const Center(child: CustomText("No promoted shops found nearby."));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      spacing: 8,
                      children: state.ads.map((ad) {
                        return PromotedShopCardWidget(
                          branchId: ad.branchId,
                          shopName: ad.shopOwner.name,
                          shopImg: ad.shopOwner.profileImage != null
                              ? "${ApiEndpoints.baseUrl}${ad.shopOwner.profileImage}"
                              : "https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=2047&auto=format&fit=crop",
                          items: ad.topRatedMenus.map((m) => {
                            "title": m.itemName,
                            "price": "AED ${m.price.toStringAsFixed(1)}",
                            "image": m.image != null && m.image!.isNotEmpty
                                ? "${ApiEndpoints.baseUrl}${m.image}"
                                : "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2070&auto=format&fit=crop",
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => sl<PromotedAdsBloc>()..add(GetPromotedAdsEvent()),
        child: const FractionallySizedBox(
          heightFactor: 0.8,
          child: PromotedShopsSheet(),
        ),
      ),
    );
  }
}
