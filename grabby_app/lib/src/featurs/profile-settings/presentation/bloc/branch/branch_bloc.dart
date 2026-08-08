import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/core_export.dart';
import '../../../data/models/branch_model.dart';
import '../../../data/services/branch_service.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchService _branchService;

  BranchBloc({required BranchService branchService})
      : _branchService = branchService,
        super(BranchInitial()) {
    on<GetBranchesEvent>(_onGetBranches);
    on<CreateBranchEvent>(_onCreateBranch);
    on<UpdateBranchEvent>(_onUpdateBranch);
    on<DeleteBranchEvent>(_onDeleteBranch);
    on<GetBranchAvailabilityEvent>(_onGetBranchAvailability);
    on<UpdateBranchAvailabilityEvent>(_onUpdateBranchAvailability);
    on<GetBranchDetailsEvent>(_onGetBranchDetails);
  }

  Future<void> _onGetBranches(
    GetBranchesEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final response = await _branchService.getBranches();
      if (response.success) {
        emit(BranchesLoaded(response.data ?? []));
      } else {
        emit(BranchError(response.message));
      }
    } on ApiException catch (e) {
      emit(BranchError(e.message));
    } catch (e) {
      emit(BranchError('Failed to load branches.'));
    }
  }

  Future<void> _onCreateBranch(
    CreateBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final response = await _branchService.createBranch(event.data);
      if (response.success) {
        emit(const BranchOperationSuccess('Branch created successfully'));
        add(GetBranchesEvent());
      } else {
        emit(BranchError(response.message));
      }
    } on ApiException catch (e) {
      emit(BranchError(e.message));
    } catch (e) {
      emit(BranchError('Failed to create branch.'));
    }
  }

  Future<void> _onUpdateBranch(
    UpdateBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final response = await _branchService.updateBranch(event.branchId, event.data);
      if (response.success) {
        emit(const BranchOperationSuccess('Branch updated successfully'));
        add(GetBranchesEvent());
      } else {
        emit(BranchError(response.message));
      }
    } on ApiException catch (e) {
      emit(BranchError(e.message));
    } catch (e) {
      emit(BranchError('Failed to update branch.'));
    }
  }

  Future<void> _onDeleteBranch(
    DeleteBranchEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final response = await _branchService.deleteBranch(event.branchId);
      if (response.success) {
        emit(const BranchOperationSuccess('Branch deleted successfully'));
        add(GetBranchesEvent());
      } else {
        emit(BranchError(response.message));
      }
    } on ApiException catch (e) {
      emit(BranchError(e.message));
    } catch (e) {
      emit(BranchError('Failed to delete branch.'));
    }
  }

  Future<void> _onGetBranchAvailability(
    GetBranchAvailabilityEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final response = await _branchService.getBranchAvailability(event.branchId);
      if (response.success && response.data != null) {
        emit(BranchAvailabilityLoaded(response.data!));
      } else {
        emit(BranchError(response.message));
      }
    } on ApiException catch (e) {
      emit(BranchError(e.message));
    } catch (e) {
      emit(BranchError('Failed to load branch availability.'));
    }
  }

  Future<void> _onUpdateBranchAvailability(
    UpdateBranchAvailabilityEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final response = await _branchService.updateBranchAvailability(event.branchId, event.availability);
      if (response.success) {
        emit(const BranchOperationSuccess(
            'Branch availability updated successfully'));
        add(GetBranchesEvent());
      } else {
        emit(BranchError(response.message));
      }
    } on ApiException catch (e) {
      emit(BranchError(e.message));
    } catch (e) {
      emit(BranchError('Failed to update branch availability.'));
    }
  }
  Future<void> _onGetBranchDetails(
    GetBranchDetailsEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    try {
      final response = await _branchService.getBranchDetails(event.branchId);
      if (response.success && response.data != null) {
        emit(BranchDetailsLoaded(response.data!));
      } else {
        emit(BranchError(response.message));
      }
    } on ApiException catch (e) {
      emit(BranchError(e.message));
    } catch (e) {
      emit(BranchError('Failed to load branch details.'));
    }
  }
}
