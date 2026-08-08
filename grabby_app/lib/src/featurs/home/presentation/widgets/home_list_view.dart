import '../../../../src_export.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBranchBloc, CustomerBranchState>(
      builder: (context, state) {
        if (state is CustomerBranchLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is CustomerBranchError) {
          return SliverFillRemaining(
            child: Center(child: CustomText(state.message)),
          );
        } else if (state is CustomerBranchesLoaded) {
          if (state.branches.isEmpty) {
            return const SliverFillRemaining(
              child: Center(child: CustomText("No branches found.")),
            );
          }

          return SliverPadding(
            padding: AppPadding.getPadding12(context).copyWith(top: 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final branch = state.branches[index];
                  return CafeCardWidget(
                    title: branch.branchName,
                    image: branch.image != null
                        ? "${ApiEndpoints.baseUrl}${branch.image}"
                        : "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=2078&auto=format&fit=crop",
                    distance: branch.distanceText,
                    openHours: branch.timing,
                    status: branch.statusText,
                    onTap: () {
                      context.pushNamed(
                        RoutesPath.restruantDetailsPath,
                        extra: branch.id,
                      );
                    },
                  );
                },
                childCount: state.branches.length,
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
