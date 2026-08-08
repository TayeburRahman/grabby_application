import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core_export.dart';
import '../../data/models/car_plate_model.dart';
import '../../domain/repositories/car_plate_repository.dart';

part 'car_plate_event.dart';
part 'car_plate_state.dart';

class CarPlateBloc extends Bloc<CarPlateEvent, CarPlateState> {
  final CarPlateRepository repository;

  CarPlateBloc(this.repository) : super(CarPlateInitial()) {
    on<GetCarPlatesEvent>(_onGetCarPlates);
    on<AddCarPlateEvent>(_onAddCarPlate);
    on<DeleteCarPlateEvent>(_onDeleteCarPlate);
  }

  Future<void> _onGetCarPlates(
    GetCarPlatesEvent event,
    Emitter<CarPlateState> emit,
  ) async {
    emit(CarPlateLoading());
    try {
      final response = await repository.getCarPlates();
      if (response.success) {
        emit(CarPlatesLoaded(response.data!));
      } else {
        emit(CarPlateError(response.message));
      }
    } on ApiException catch (e) {
      emit(CarPlateError(e.message));
    } catch (e) {
      emit(CarPlateError('Failed to load car plates'));
    }
  }

  Future<void> _onAddCarPlate(
    AddCarPlateEvent event,
    Emitter<CarPlateState> emit,
  ) async {
    emit(CarPlateLoading());
    try {
      final response = await repository.addCarPlate(event.data);
      if (response.success) {
        emit(CarPlateOperationSuccess('Car plate added successfully'));
        add(GetCarPlatesEvent());
      } else {
        emit(CarPlateError(response.message));
      }
    } on ApiException catch (e) {
      emit(CarPlateError(e.message));
    } catch (e) {
      emit(CarPlateError('Failed to add car plate'));
    }
  }

  Future<void> _onDeleteCarPlate(
    DeleteCarPlateEvent event,
    Emitter<CarPlateState> emit,
  ) async {
    emit(CarPlateLoading());
    try {
      final response = await repository.deleteCarPlate(event.id);
      if (response.success) {
        emit(CarPlateOperationSuccess('Car plate deleted successfully'));
        add(GetCarPlatesEvent());
      } else {
        emit(CarPlateError(response.message));
      }
    } on ApiException catch (e) {
      emit(CarPlateError(e.message));
    } catch (e) {
      emit(CarPlateError('Failed to delete car plate'));
    }
  }
}
