import 'dart:async';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../src_export.dart';
import '../../../../core/services/socket_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final LocationService _locationService;
  final SocketService _socketService;
  final LocalStorageService _localStorageService;
  StreamSubscription<Position>? _locationSubscription;

  ProfileBloc({
    required ProfileRepository profileRepository,
    required LocationService locationService,
    required SocketService socketService,
    required LocalStorageService localStorageService,
  }) : _profileRepository = profileRepository,
       _locationService = locationService,
       _socketService = socketService,
       _localStorageService = localStorageService,
       super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await _profileRepository.getProfile();
      if (response.success && response.data != null) {
        final profile = response.data!;
        emit(ProfileLoaded(profile));

        // Connect Socket and Start Location Tracking
        final token = _localStorageService.getAccessToken();
        if (token != null) {
          _socketService.connect(token);

          // Initial Location Emit
          final position = await _locationService.getCurrentPosition();
          if (position != null) {
            _emitLocation(position, token);
          }

          // Start continuous tracking
          _startLocationTracking(token);
        }
      } else {
        emit(ProfileError(response.message));
      }
    } on ApiException catch (e) {
      debugPrint("ProfileBloc ApiException: ${e.message}");
      emit(ProfileError(e.message));
    } catch (e, stackTrace) {
      debugPrint("ProfileBloc catch: $e");
      debugPrint("ProfileBloc stackTrace: $stackTrace");
      emit(ProfileError('Something went wrong. Please try again.'));
    }
  }

  void _startLocationTracking(String token) {
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.getPositionStream().listen(
      (Position position) {
        _emitLocation(position, token);
      },
      onError: (error) {
        debugPrint('Location stream error: $error');
      },
    );
  }

  void _emitLocation(Position position, String token) {
    {
      try {
        final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final String userId = decodedToken['userId'] ?? '';
        final String role = decodedToken['role'] ?? '';

        if (role != 'SHOP_OWNER') {
          _socketService.emit('updateLocation', {
            // 'userId': userId,
            // 'role': role,
            'lat': position.latitude,
            'lon': position.longitude,
          });
          debugPrint(
            'Emitted location: $role - $userId (${position.latitude}, ${position.longitude})',
          );
        }
      } catch (e) {
        debugPrint('Error emitting location: $e');
      }
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _socketService.disconnect();
    return super.close();
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      // 1. Fetch current location
      final locationData = await _locationService.getLocationData();
      if (locationData == null) {
        emit(
          ProfileError(
            'Failed to get current location. Please check your permissions.',
          ),
        );
        return;
      }

      final currentState = state;
      String? userRole;
      if (currentState is ProfileLoaded) {
        userRole = currentState.profileData.authId.role;
      }

      print('Starting profile update for role: $userRole');

      // 2. Role-based Location Update
      if (userRole == 'SHOP_OWNER') {
        // Shop Owners update location via a separate POST endpoint
        final locationResponse = await _profileRepository.updateUserLocation(
          addressName: locationData.address,
          lat: locationData.latitude,
          lon: locationData.longitude,
        );
        if (!locationResponse.success) {
          emit(ProfileError(locationResponse.message));
          return;
        }
      }

      print('Profile update data:');
      print(' - Name: ${event.name}');
      print(' - Email: ${event.email}');
      print(' - Phone: ${event.phoneNumber}');
      print(' - Shop Name: ${event.shopName}');
      print(' - License: ${event.shopLicenseNumber}');
      print(' - Address: ${locationData.address}');
      print(' - Lat: ${locationData.latitude} (${locationData.latitude.runtimeType})');
      print(' - Lon: ${locationData.longitude} (${locationData.longitude.runtimeType})');

      // 3. Update Profile (For Customers, this includes the location data in the same call)
      final response = await _profileRepository.updateProfile(
        name: event.name,
        profileImage: event.profileImage,
        email: event.email,
        phoneNumber: event.phoneNumber,
        shopName: event.shopName,
        shopLicenseNumber: event.shopLicenseNumber,
        contactEmail: event.contactEmail,
        contactPhone: event.contactPhone,
        addressName: locationData.address,
        lat: locationData.latitude,
        lon: locationData.longitude,
      );

      print('Update Profile Final Response: success=${response.success}');

      if (response.success) {
        emit(ProfileUpdateSuccess());
        add(GetProfileEvent());
      } else {
        emit(ProfileError(response.message));
      }
    } on ApiException catch (e) {
      print('ProfileBloc ApiException: ${e.message}');
      emit(ProfileError(e.message));
    } catch (e, stackTrace) {
      print('ProfileBloc Unexpected Error: $e');
      print('Stacktrace: $stackTrace');
      emit(ProfileError('Something went wrong. Please try again.'));
    }
  }
}
