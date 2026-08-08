import 'package:grabby_app/src/featurs/profile-settings/presentation/bloc/branch/branch_bloc.dart';

import '../../../../src_export.dart';

class BranchDropdown extends StatefulWidget {
  final Function(String branchId, String branchName) onBranchSelected;
  final String? initialBranchId;

  const BranchDropdown({
    super.key,
    required this.onBranchSelected,
    this.initialBranchId,
  });

  @override
  State<BranchDropdown> createState() => _BranchDropdownState();
}

class _BranchDropdownState extends State<BranchDropdown> {
  String? selectedBranchId;

  @override
  void initState() {
    super.initState();
    selectedBranchId = widget.initialBranchId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BranchBloc, BranchState>(
      listener: (context, state) {
        if (state is BranchesLoaded &&
            state.branches.isNotEmpty &&
            selectedBranchId == null) {
          setState(() {
            selectedBranchId = state.branches.first.id;
          });
          widget.onBranchSelected(
            state.branches.first.id,
            state.branches.first.branchName,
          );
        }
      },
      builder: (context, state) {
        if (state is BranchLoading) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }
        if (state is BranchesLoaded) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: SizedBox(
                height: 35,
                child: DropdownButton<String>(
                  value: selectedBranchId,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.kPrimaryColor,
                    size: 20,
                  ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        final branch =
                            state.branches.firstWhere((b) => b.id == newValue);
                        setState(() {
                          selectedBranchId = newValue;
                        });
                        widget.onBranchSelected(
                          branch.id,
                          branch.branchName,
                        );
                      }
                    },
                  items: state.branches.map<DropdownMenuItem<String>>((branch) {
                    return DropdownMenuItem<String>(
                      value: branch.id,
                      child: CustomText(
                        branch.branchName,
                        variant: TextVariant.labelSmall,
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
