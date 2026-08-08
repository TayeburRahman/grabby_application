part of 'car_plate_bloc.dart';

abstract class CarPlateState {}

class CarPlateInitial extends CarPlateState {}

class CarPlateLoading extends CarPlateState {}

class CarPlatesLoaded extends CarPlateState {
  final List<CarPlateModel> carPlates;
  CarPlatesLoaded(this.carPlates);
}

class CarPlateOperationSuccess extends CarPlateState {
  final String message;
  CarPlateOperationSuccess(this.message);
}

class CarPlateError extends CarPlateState {
  final String message;
  CarPlateError(this.message);
}
