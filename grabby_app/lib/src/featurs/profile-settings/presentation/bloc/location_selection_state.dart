part of 'location_selection_bloc.dart';

@immutable
abstract class LocationSelectionState {}

class LocationSelectionInitial extends LocationSelectionState {}

class LocationSelectionLoading extends LocationSelectionState {}

class LocationSelectionUpdated extends LocationSelectionState {
  final LatLng position;
  final String address;
  final bool isReverseGeocoding;

  final bool isUserAction;

  LocationSelectionUpdated({
    required this.position,
    required this.address,
    this.isReverseGeocoding = false,
    this.isUserAction = false,
  });
}

class LocationSelectionError extends LocationSelectionState {
  final String message;
  LocationSelectionError({required this.message});
}
