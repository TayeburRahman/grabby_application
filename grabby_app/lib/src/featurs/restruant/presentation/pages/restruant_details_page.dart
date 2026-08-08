import 'package:flutter/cupertino.dart';
import '../../../../src_export.dart';

class RestruantDetailsPage extends StatefulWidget {
  final String branchId;
  const RestruantDetailsPage({super.key, required this.branchId});

  @override
  State<RestruantDetailsPage> createState() => _RestruantDetailsPageState();
}

class _RestruantDetailsPageState extends State<RestruantDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerBranchBloc>().add(GetCustomerBranchDetailEvent(widget.branchId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CustomerBranchBloc, CustomerBranchState>(
        builder: (context, state) {
          if (state is CustomerBranchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerBranchError) {
            return Center(child: CustomText(state.message));
          } else if (state is CustomerBranchDetailLoaded) {
            final branch = state.branch;
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<CustomerBranchBloc>()
                    .add(GetCustomerBranchDetailEvent(widget.branchId));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    leading: Container(
                      margin: AppPadding.getPadding8(context),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ButtonTapWidget(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: AppPadding.getPadding4(context),
                          child: const Icon(CupertinoIcons.back,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    centerTitle: true,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    pinned: true,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CustomNetworkImage(
                        borderRadius: BorderRadius.circular(0),
                        imageUrl: branch.image != null
                            ? "${ApiEndpoints.baseUrl}${branch.image}"
                            : "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=2078&auto=format&fit=crop",
                        height: 200,
                        width: double.infinity,
                        isImagePreview: true,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: AppPadding.getPadding12(context),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant Info Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              CustomText(
                                branch.branchName,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.kTextColor,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: AppColors.kSecondaryTextColor,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    branch.distanceText,
                                    fontSize: 14,
                                    color: AppColors.kSecondaryTextColor,
                                  ),
                                ],
                              ),
                              OpeningTimeTextWidget(
                                openHours: branch.timing,
                                isOpen: branch.isOpen,
                              ),
                            ],
                          ),

                          // Branch Selection (Currently shown address from details)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              CustomText(
                                AppStaticStrings.selectBranch,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: .1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        branch.address,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const Icon(
                                      CupertinoIcons.chevron_right,
                                      size: 18,
                                      color: AppColors.kSecondaryTextColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Loyalty Progress (Dynamic placeholder if no explicit value from API yet)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 12,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    AppStaticStrings.loyaltyProgress,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  CustomText(
                                    "${branch.totalStamps ?? 0}/10",
                                    fontSize: 14,
                                    color: AppColors.kSecondaryTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: (branch.totalStamps ?? 0) / 10.0,
                                  minHeight: 8,
                                  backgroundColor: Colors.white,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // View Full Menu Button
                          CustomButton(
                            text: AppStaticStrings.viewFullMenu,
                            onPressed: () {
                              context.pushNamed(
                                RoutesPath.menuPath,
                                extra: branch.id,
                              );
                            },
                            backgroundColor: AppColors.kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
