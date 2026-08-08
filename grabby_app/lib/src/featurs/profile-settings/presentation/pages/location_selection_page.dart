import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../src_export.dart';

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  GoogleMapController? _mapController;
  final LocationService _locationService = sl<LocationService>();
  final LatLng _initialPosition = const LatLng(24.466667,54.366669); // Default to Dhaka

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LocationSelectionBloc>()..add(FetchCurrentLocation()),
      child: BlocListener<LocationSelectionBloc, LocationSelectionState>(
        listenWhen: (previous, current) =>
            current is LocationSelectionUpdated ||
            current is LocationSelectionError,
        listener: (context, state) {
          if (state is LocationSelectionUpdated &&
              state.isUserAction &&
              _mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(state.position),
            );
          } else if (state is LocationSelectionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: Stack(
                children: [
                  // Google Map
                  BlocBuilder<LocationSelectionBloc, LocationSelectionState>(
                    buildWhen: (previous, current) =>
                        previous is LocationSelectionInitial ||
                        previous is LocationSelectionLoading,
                    builder: (context, state) {
                      // Only show full screen loader if we don't have a map controller yet 
                      // AND we are in an initial or loading state.
                      if (_mapController == null && 
                          (state is LocationSelectionInitial || state is LocationSelectionLoading)) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.kPrimaryColor,
                          ),
                        );
                      }

                      LatLng initialTarget = _initialPosition;
                      if (state is LocationSelectionUpdated) {
                        initialTarget = state.position;
                      }

                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: initialTarget,
                          zoom: 15,
                        ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      onCameraMove: (position) {
                        context.read<LocationSelectionBloc>().add(
                              MapCameraMoved(position: position.target),
                            );
                      },
                      onCameraIdle: () async {
                        if (_mapController != null) {
                          final LatLngBounds bounds =
                              await _mapController!.getVisibleRegion();
                          final LatLng center = LatLng(
                            (bounds.northeast.latitude +
                                    bounds.southwest.latitude) /
                                2,
                            (bounds.northeast.longitude +
                                    bounds.southwest.longitude) /
                                2,
                          );
                          if (context.mounted) {
                            context.read<LocationSelectionBloc>().add(
                                  MapCameraIdle(position: center),
                                );
                          }
                        }
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                    );
                  },
                ),

                // Center Pin (Only show if not loading)
                BlocBuilder<LocationSelectionBloc, LocationSelectionState>(
                  builder: (context, state) {
                    if (_mapController == null && 
                        (state is LocationSelectionLoading || state is LocationSelectionInitial)) {
                      return const SizedBox.shrink();
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 35),
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 34,
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                    );
                  },
                ),

                // Bottom Info & Confirm Button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'SELECTED LOCATION',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.kSecondaryTextColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<
                          LocationSelectionBloc,
                          LocationSelectionState
                        >(
                          builder: (context, state) {
                            String address = "Drag map to select location";
                            bool isFetching = false;

                            if (state is LocationSelectionUpdated) {
                              address = state.address;
                              isFetching = state.isReverseGeocoding;
                            } else if (state is LocationSelectionLoading) {
                              address = "Determining current location...";
                              isFetching = true;
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        address,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.kTextColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isFetching)
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                            AppColors.kPrimaryColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        CustomButton(
                          text: AppStaticStrings.confirmLocation,
                          onPressed: () {
                            final state = context
                                .read<LocationSelectionBloc>()
                                .state;
                            if (state is LocationSelectionUpdated) {
                              Navigator.pop(context, {
                                'position': state.position,
                                'address': state.address,
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // My Location FAB
                Positioned(
                  right: 20,
                  bottom: 180, // Above the bottom sheet
                  child: FloatingActionButton(
                    onPressed: () {
                      context.read<LocationSelectionBloc>().add(
                            FetchCurrentLocation(),
                          );
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.kPrimaryColor,
                    elevation: 4,
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
