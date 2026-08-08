part of 'car_plate_bloc.dart';

abstract class CarPlateEvent {}

class GetCarPlatesEvent extends CarPlateEvent {}

class AddCarPlateEvent extends CarPlateEvent {
  final Map<String, dynamic> data;
  AddCarPlateEvent(this.data);
}

class DeleteCarPlateEvent extends CarPlateEvent {
  final String id;
  DeleteCarPlateEvent(this.id);
}
