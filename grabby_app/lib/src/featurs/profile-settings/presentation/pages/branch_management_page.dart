import 'package:grabby_app/src/featurs/profile-settings/data/models/branch_model.dart';
import 'package:grabby_app/src/featurs/profile-settings/presentation/bloc/branch/branch_bloc.dart';
import '../../../../src_export.dart';

class BranchManagementPage extends StatefulWidget {
  const BranchManagementPage({super.key});

  @override
  State<BranchManagementPage> createState() => _BranchManagementPageState();
}

class _BranchManagementPageState extends State<BranchManagementPage> {
  void _showAddBranch() {
    final bloc = context.read<BranchBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          BlocProvider.value(value: bloc, child: const AddBranchBottomSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchBloc, BranchState>(
      listener: (context, state) {
        if (state is BranchOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is BranchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message, style: const TextStyle(color: Colors.white))),
          );
        } else if (state is BranchDetailsLoaded) {
          _showBranchDetails(context, state.branch);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            AppStaticStrings.branchManagement,
            variant: TextVariant.headlineSmall,
          ),
          actions: [
            FloatingActionButton.small(
              onPressed: _showAddBranch,
              child: const Icon(Icons.add),
            ),
          ],
        ),
        body: RefreshIndicator(
                onRefresh: () {
                  context.read<BranchBloc>().add(GetBranchesEvent());
                  return Future.value();
                },
          child: BlocBuilder<BranchBloc, BranchState>(
            buildWhen: (previous, current) =>
                current is BranchesLoaded ||
                current is BranchLoading ||
                current is BranchInitial ||
                current is BranchDetailsLoaded,
            builder: (context, state) {
              if (state is BranchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BranchesLoaded) {
                final branches = state.branches;
                if (branches.isEmpty) {
                  return const Center(child: Text("No branches found."));
                }
                return CustomScrollView(
               physics: AlwaysScrollableScrollPhysics(),
                  // padding: AppPadding.getPadding12H(context),
                slivers: [
                  SliverToBoxAdapter(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _buildSummaryCard(context, branches),
                        space2H,
                        ...branches.map(
                          (branch) => BranchCard(
                            name: branch.branchName.isNotEmpty
                                ? branch.branchName
                                : "Unnamed Branch",
                            address: branch.address,
                            phone: branch.phoneNumber,
                            hours: branch.availability.isNotEmpty
                                ? "Custom Hours"
                                : "Not Set",
                            onTap: () {
                              context.read<BranchBloc>().add(
                                GetBranchDetailsEvent(branch.id),
                              );
                            },
                            onEdit: () {
                              final bloc = context.read<BranchBloc>();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => BlocProvider.value(
                                  value: bloc,
                                  child: AddBranchBottomSheet(branch: branch),
                                ),
                              );
                            },
                            onDelete: () {
                              context.read<BranchBloc>().add(
                                DeleteBranchEvent(branch.id),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
               )
                ],  );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    List<ShopBranchModel> branches,
  ) {
    return Padding(
      padding: AppPadding.getPadding12(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            label: AppStaticStrings.totalBranches,
            value: "${branches.length}",
            color: AppColors.kPrimaryColor,
          ),
          _SummaryItem(
            label: AppStaticStrings.active,
            value: "${branches.length}",
            color: AppColors.kGreenColor,
          ),
          const _SummaryItem(
            label: AppStaticStrings.inactive,
            value: "0",
            color: AppColors.kSecondaryTextColor,
          ),
        ],
      ),
    );
  }

  void _showBranchDetails(BuildContext context, ShopBranchModel branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(branch.branchName),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("Address: ${branch.address}"),
              Text("Phone: ${branch.phoneNumber}"),
              Text("Lat: ${branch.lat}"),
              Text("Lng: ${branch.lng}"),
              Text("Apply Menu for All: ${branch.applyMenuForAll}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CustomText(
            value,
            variant: TextVariant.titleLarge,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            label,
            variant: TextVariant.labelSmall,
            color: AppColors.kSecondaryTextColor,
          ),
        ],
      ),
    );
  }
}
