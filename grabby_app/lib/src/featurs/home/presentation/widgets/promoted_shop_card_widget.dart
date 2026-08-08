import '../../../../src_export.dart';

class PromotedShopCardWidget extends StatelessWidget {
  final String branchId;
  final String shopName;
  final String shopImg;
  final List<Map<String, String>> items;

  const PromotedShopCardWidget({
    super.key,
    required this.branchId,
    required this.shopName,
    required this.shopImg,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: .2)),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(shopImg)),

              CustomText(shopName, fontSize: 14, fontWeight: FontWeight.w600),
              Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.cyan.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      size: 15,
                      color: Colors.lightBlue,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      AppStaticStrings.sponsored,

                      color: Colors.lightBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: items.map((item) {
                return PromotedShopItemWidget(
                  title: item['title'] ?? "",
                  price: item['price'] ?? "",
                  image: item['image'] ?? "",
                );
              }).toList(),
            ),
          ),

          CustomButton(
            text: AppStaticStrings.viewFullDetails,
            onPressed: () {
              context.pushNamed(
                RoutesPath.restruantDetailsPath,
                extra: branchId,
              );
            },
            backgroundColor: AppColors.kPrimaryColor,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }
}
