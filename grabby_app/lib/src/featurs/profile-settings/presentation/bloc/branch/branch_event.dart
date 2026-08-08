part of 'branch_bloc.dart';

abstract class BranchEvent {
  const BranchEvent();

}

class GetBranchesEvent extends BranchEvent {}

class CreateBranchEvent extends BranchEvent {
  final Map<String, dynamic> data;

  const CreateBranchEvent(this.data);

}

class UpdateBranchEvent extends BranchEvent {
  final String branchId;
  final Map<String, dynamic> data;

  const UpdateBranchEvent(this.branchId, this.data);

}

class DeleteBranchEvent extends BranchEvent {
  final String branchId;

  const DeleteBranchEvent(this.branchId);

}

class GetBranchAvailabilityEvent extends BranchEvent {
  final String branchId;

  const GetBranchAvailabilityEvent(this.branchId);

}

class UpdateBranchAvailabilityEvent extends BranchEvent {
  final String branchId;
  final List<Map<String, dynamic>> availability;

  const UpdateBranchAvailabilityEvent(this.branchId, this.availability);

}

class GetBranchDetailsEvent extends BranchEvent {
  final String branchId;

  const GetBranchDetailsEvent(this.branchId);
}
