import '../../../../src_export.dart';
import '../../data/repositories/branch_repository_impl.dart';


// Events
abstract class CustomerBranchEvent {}

class GetCustomerBranchesEvent extends CustomerBranchEvent {
  final String? query;
  final double? lat;
  final double? lng;
  GetCustomerBranchesEvent({this.query, this.lat, this.lng});
}

class GetCustomerBranchDetailEvent extends CustomerBranchEvent {
  final String id;
  GetCustomerBranchDetailEvent(this.id);
}

// States
abstract class CustomerBranchState {}

class CustomerBranchInitial extends CustomerBranchState {}

class CustomerBranchLoading extends CustomerBranchState {}

class CustomerBranchesLoaded extends CustomerBranchState {
  final List<CustomerBranchModel> branches;
  CustomerBranchesLoaded(this.branches);
}

class CustomerBranchDetailLoaded extends CustomerBranchState {
  final CustomerBranchModel branch;
  CustomerBranchDetailLoaded(this.branch);
}

class CustomerBranchError extends CustomerBranchState {
  final String message;
  CustomerBranchError(this.message);
}

class CustomerBranchBloc extends Bloc<CustomerBranchEvent, CustomerBranchState> {
  final BranchRepository branchRepository;

  CustomerBranchBloc({required this.branchRepository}) : super(CustomerBranchInitial()) {
    on<GetCustomerBranchesEvent>(_onGetBranches);
    on<GetCustomerBranchDetailEvent>(_onGetBranchDetail);
  }

  Future<void> _onGetBranches(
    GetCustomerBranchesEvent event,
    Emitter<CustomerBranchState> emit,
  ) async {
    emit(CustomerBranchLoading());
    try {
      final response = await branchRepository.getBranches(
        query: event.query,
        lat: event.lat,
        lng: event.lng,
      );
      if (response.success) {
        emit(CustomerBranchesLoaded(response.data ?? []));
      } else {
        emit(CustomerBranchError(response.message));
      }
    } catch (e) {
      emit(CustomerBranchError(e.toString()));
    }
  }

  Future<void> _onGetBranchDetail(
    GetCustomerBranchDetailEvent event,
    Emitter<CustomerBranchState> emit,
  ) async {
    emit(CustomerBranchLoading());
    try {
      final response = await branchRepository.getBranchDetail(event.id);
      if (response.success && response.data != null) {
        emit(CustomerBranchDetailLoaded(response.data!));
      } else {
        emit(CustomerBranchError(response.message));
      }
    } catch (e) {
      emit(CustomerBranchError(e.toString()));
    }
  }
}
