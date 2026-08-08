import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'socket_service.dart';
import 'local_storage_service.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String address;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  String toString() => 'LocationData(lat: $latitude, lon: $longitude, address: $address)';
}

class LocationService {
  final SocketService _socketService;
  final LocalStorageService _localStorageService;

  LocationService({
    required SocketService socketService,
    required LocalStorageService localStorageService,
  })  : _socketService = socketService,
        _localStorageService = localStorageService;

  StreamSubscription<Position>? _positionStream;
  String? _lastTripId;
  bool isRunning = false;
  /// Internal helper to check and request permissions
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return false;
    } 

    return true;
  }

  /// Get current coordinates
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await _handlePermission();
      if (!hasPermission) {
        print('Location permission denied.');
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Get reverse geocoded address
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        // Construct a readable address
        final addressParts = [
          if (place.name != null && place.name != place.subLocality) place.name,
          if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality,
          if (place.locality != null && place.locality!.isNotEmpty) place.locality,
          if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) place.administrativeArea,
          if (place.country != null && place.country!.isNotEmpty) place.country,
        ];
        
        return addressParts.where((s) => s != null).join(', ');
      }
    } catch (e) {
      print('Error getting address from coordinates ($lat, $lng): $e');
    }
    return "Unknown Address";
  }

  /// Get both coordinates and address in one call
  Future<LocationData?> getLocationData() async {
    final position = await getCurrentPosition();
    if (position == null) return null;

    final address = await getAddressFromLatLng(position.latitude, position.longitude);
    
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
    );
  }
  /// Get coordinates stream
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  /// Start tracking location and emitting to socket (Adapted from previous project)
  Future<void> startTrackingLocation({
    required ValueNotifier<LatLng?> markerPosition,
    required GoogleMapController? mapController,
    bool emitToSocket = true,
  }) async {
    try {
      if (isRunning) {
        debugPrint("Location tracking is already running.");
        return;
      }
      isRunning = true;

  

      await _positionStream?.cancel();

      _positionStream = getPositionStream().listen((Position position) {
        final newPosition = LatLng(position.latitude, position.longitude);
        markerPosition.value = newPosition;

        final token = _localStorageService.getAccessToken();
        if (token != null && token.isNotEmpty) {
          try {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
            final String role = decodedToken['role'] ?? "";
            final String userId = decodedToken['userId'] ?? "";

            // Driver specific location updates
            if (role == "CUSTOMER") {
            
                // Trip specific update
                _socketService.emit('updateLocation', {
                
                  "lat": position.latitude,
                  "lon": position.longitude,
                });
            

              // // General driver location update
              // if (_socketService.IsConnected) {
              //   _socketService.emit('updateLocation', {
              //     "lat": position.latitude,
              //     "lon": position.longitude,
              //     "userId": userId,
              //     "role": role,
              //   });
              // }
            }
          } catch (e) {
            debugPrint("Error decoding token or emitting socket: $e");
          }
        }

        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
        }
      });

    } catch (e) {
      debugPrint("Error starting location tracking: $e");
    } finally {
      isRunning = false;
    }
  }

  /// Stop tracking location
  Future<void> stopTrackingLocation() async {
    await _positionStream?.cancel();
    _positionStream = null;
    _lastTripId = null;
    isRunning = false;
  }
}
