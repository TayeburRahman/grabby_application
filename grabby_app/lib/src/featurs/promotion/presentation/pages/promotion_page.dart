import '../../../../src_export.dart';

class PromotionPage extends StatefulWidget {
  const PromotionPage({super.key});

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  void _showEditDiscount({String? title, PromotionModel? promotion}) {
    final promotionBloc = context.read<PromotionBloc>();
    final menuBloc = context.read<MenuBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: promotionBloc),
          BlocProvider.value(value: menuBloc),
        ],
        child: EditDiscountBottomSheet(title: title, promotion: promotion),
      ),
    );
  }

  void _showDeleteDialog(PromotionModel promotion) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) =>
          DeleteDiscountDialog(discountName: promotion.discountName),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context.read<PromotionBloc>().add(DeletePromotionEvent(promotion.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PromotionBloc, PromotionState>(
      listener: (context, state) {
        if (state is PromotionOperationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is PromotionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            AppStaticStrings.promotions,
            variant: TextVariant.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () =>
                      _showEditDiscount(title: AppStaticStrings.addPromotion),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<PromotionBloc>().add(GetPromotionsEvent());
            context.read<MenuBloc>().add(GetMenuItemsEvent());
          },
          child: BlocBuilder<PromotionBloc, PromotionState>(
            builder: (context, state) {
              if (state is PromotionLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PromotionError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(state.message, variant: TextVariant.bodyLarge),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Retry',
                        onPressed: () => context.read<PromotionBloc>().add(
                          GetPromotionsEvent(),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is PromotionsLoaded) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: AppPadding.getPadding12(context),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              AppStaticStrings.upcomingEvents,
                              variant: TextVariant.titleLarge,
                              fontWeight: FontWeight.bold,
                            ),

                            if (state.upcomingEvents.isNotEmpty)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.3,
                                    ),
                                itemCount: state.upcomingEvents.length,
                                itemBuilder: (context, index) {
                                  final event = state.upcomingEvents[index];
                                  return UpcomingEventCard(
                                    title: event.name,
                                    date:
                                        "${event.startDate} - ${event.endDate}",
                                    imageUrl: event.icons.isNotEmpty
                                        ? event.icons.first
                                        : null,
                                  );
                                },
                              ),

                            Row(
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  color: AppColors.kGreenColor,
                                ),
                                CustomText(
                                  AppStaticStrings.activeDiscounts,
                                  variant: TextVariant.titleLarge,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),

                            // Dynamic active discounts from BLoC
                            ...state.data.data.map(
                              (promotion) => ActiveDiscountCard(
                                promotion: promotion,
                                onEdit: () =>
                                    _showEditDiscount(promotion: promotion),
                                onDelete: () => _showDeleteDialog(promotion),
                              ),
                            ),

                            // If no promotions, show empty state
                            if (state.data.data.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.discount_outlined,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 16),
                                      CustomText(
                                        'No active promotions',
                                        variant: TextVariant.titleMedium,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 8),
                                      CustomText(
                                        'Create your first promotion to get started',
                                        variant: TextVariant.bodyMedium,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
