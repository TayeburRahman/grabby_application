import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../../../core/core_export.dart';

part 'location_selection_event.dart';
part 'location_selection_state.dart';

class LocationSelectionBloc
    extends Bloc<LocationSelectionEvent, LocationSelectionState> {
  final LocationService _locationService;
  Timer? _debounce;

  LocationSelectionBloc({required LocationService locationService})
      : _locationService = locationService,
        super(LocationSelectionInitial()) {
    on<MapCameraMoved>(_onMapCameraMoved);
    on<MapCameraIdle>(_onMapCameraIdle);
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
    on<ConfirmLocationSelected>(_onConfirmLocationSelected);
    on<_ReverseGeocodeEvent>(_onReverseGeocode);
  }

  void _onMapCameraMoved(
    MapCameraMoved event,
    Emitter<LocationSelectionState> emit,
  ) {
    // Optional: emit temporary state if needed
  }

  Future<void> _onMapCameraIdle(
    MapCameraIdle event,
    Emitter<LocationSelectionState> emit,
  ) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      add(_ReverseGeocodeEvent(event.position, isUserAction: event.isUserAction));
    });
  }

  Future<void> _onReverseGeocode(
    _ReverseGeocodeEvent event,
    Emitter<LocationSelectionState> emit,
  ) async {
    emit(
      LocationSelectionUpdated(
        position: event.position,
        address: "Fetching address...",
        isReverseGeocoding: true,
        isUserAction: event.isUserAction,
      ),
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        event.position.latitude,
        event.position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> addressParts = [
          if (place.street != null && place.street!.isNotEmpty) place.street!,
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality!,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality!,
          if (place.postalCode != null && place.postalCode!.isNotEmpty)
            place.postalCode!,
          if (place.country != null && place.country!.isNotEmpty)
            place.country!,
        ];

        String address = addressParts.join(", ");

        emit(
          LocationSelectionUpdated(
            position: event.position,
            address: address,
            isReverseGeocoding: false,
            isUserAction: event.isUserAction,
          ),
        );
      } else {
        emit(
          LocationSelectionUpdated(
            position: event.position,
            address: "Address not found",
            isReverseGeocoding: false,
            isUserAction: event.isUserAction,
          ),
        );
      }
    } catch (e) {
      emit(
        LocationSelectionUpdated(
          position: event.position,
          address: "Error fetching address",
          isReverseGeocoding: false,
          isUserAction: event.isUserAction,
        ),
      );
    }
  }

  Future<void> _onFetchCurrentLocation(
    FetchCurrentLocation event,
    Emitter<LocationSelectionState> emit,
  ) async {
    emit(LocationSelectionLoading());
    try {
      final Position? position = await _locationService.getCurrentPosition();

      if (position != null) {
        LatLng latLng = LatLng(position.latitude, position.longitude);
        add(MapCameraIdle(position: latLng, isUserAction: true));
      } else {
        emit(LocationSelectionError(message: 'Could not fetch current location. Please check your permissions.'));
      }
    } catch (e) {
      emit(LocationSelectionError(message: e.toString()));
    }
  }

  void _onConfirmLocationSelected(
    ConfirmLocationSelected event,
    Emitter<LocationSelectionState> emit,
  ) {
    // This could just be a signal to the UI to pop with the result
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

// Internal event for handling the async geocoding after debounce
class _ReverseGeocodeEvent extends LocationSelectionEvent {
  final LatLng position;
  final bool isUserAction;
  _ReverseGeocodeEvent(this.position, {this.isUserAction = false});
}
