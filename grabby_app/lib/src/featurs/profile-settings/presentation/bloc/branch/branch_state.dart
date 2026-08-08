part of 'branch_bloc.dart';

abstract class BranchState {
  const BranchState();

}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchesLoaded extends BranchState {
  final List<ShopBranchModel> branches;

  const BranchesLoaded(this.branches);

}

class BranchOperationSuccess extends BranchState {
  final String message;

  const BranchOperationSuccess(this.message);

}

class BranchAvailabilityLoaded extends BranchState {
  final ShopBranchModel branch;

  const BranchAvailabilityLoaded(this.branch);

}

class BranchError extends BranchState {
  final String message;

  const BranchError(this.message);

}

class BranchDetailsLoaded extends BranchState {
  final ShopBranchModel branch;

  const BranchDetailsLoaded(this.branch);
}
