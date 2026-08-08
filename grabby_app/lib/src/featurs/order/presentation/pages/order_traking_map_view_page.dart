import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grabby_app/src/core/di/injection_container.dart' as di;
import 'package:url_launcher/url_launcher.dart';
import '../../../../src_export.dart';
import 'package:geolocator/geolocator.dart';

class OrderTrackingMapViewPage extends StatefulWidget {
  final String orderId;
  const OrderTrackingMapViewPage({super.key, required this.orderId});

  @override
  State<OrderTrackingMapViewPage> createState() =>
      _OrderTrackingMapViewPageState();
}

class _OrderTrackingMapViewPageState extends State<OrderTrackingMapViewPage> {
  GoogleMapController? _mapController;
  Set<Polyline> _polyLines = {};
  LatLng? _myLocation;
  final ValueNotifier<LatLng?> _myLocationNotifier = ValueNotifier(null);
  bool _isGeneratingPolyline = false;
  final LocationService _locationService = di.sl<LocationService>();

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrderDetailsEvent(widget.orderId));

    _myLocationNotifier.addListener(() {
      if (mounted) {
        setState(() {
          _myLocation = _myLocationNotifier.value;
        });
        _updatePolyline();
      }
    });

    getLocation();
  }

  Future<void> getLocation() async {
    Position? position = await _locationService.getCurrentPosition();
    if (position != null) {
      if (mounted) {
        setState(() {
          _myLocation = LatLng(position.latitude, position.longitude);
        });
        _updatePolyline();
      }
    }
  }

  void _updatePolyline() {
    final state = context.read<OrderBloc>().state;
    final order = state.selectedOrder;
    if (order == null || _myLocation == null) return;

    final branch = order.branchId is BranchInfo
        ? (order.branchId as BranchInfo)
        : null;
    if (branch == null) return;

    final shopPos = LatLng(branch.lat ?? 0, branch.lng ?? 0);
    generatePolylineBetweenPoints(shopPos, _myLocation!);
  }

  Future<void> generatePolylineBetweenPoints(LatLng origin, LatLng dest) async {
    if (_isGeneratingPolyline) return;
    _isGeneratingPolyline = true;

    try {
      PolylinePoints polylinePoints = PolylinePoints(
        apiKey: AppStaticStrings.googleMapApiKey,
      );

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(dest.latitude, dest.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        List<LatLng> routePoints = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        setState(() {
          _polyLines.clear();
          _polyLines.add(
            Polyline(
              polylineId: const PolylineId("route_line"),
              color: AppColors.kBlueColor,
              width: 6,
              points: routePoints,
              visible: true,
              geodesic: true,
            ),
          );
        });
        log("SUCCESS: Polyline generated with ${routePoints.length} points");
        zoomToFitPoints(origin, dest);
      } else {
        log("MAP ERROR: ${result.errorMessage}");
      }
    } catch (e) {
      log("Polyline Exception: $e");
    } finally {
      _isGeneratingPolyline = false;
    }
  }

  Future<void> zoomToFitPoints(LatLng shopPos, LatLng myPos) async {
    try {
      if (_mapController == null) return;
      final GoogleMapController controller = _mapController!;

      LatLngBounds bounds;
      if (shopPos.latitude > myPos.latitude &&
          shopPos.longitude > myPos.longitude) {
        bounds = LatLngBounds(southwest: myPos, northeast: shopPos);
      } else if (shopPos.longitude > myPos.longitude) {
        bounds = LatLngBounds(
          southwest: LatLng(shopPos.latitude, myPos.longitude),
          northeast: LatLng(myPos.latitude, shopPos.longitude),
        );
      } else if (shopPos.latitude > myPos.latitude) {
        bounds = LatLngBounds(
          southwest: LatLng(myPos.latitude, shopPos.longitude),
          northeast: LatLng(shopPos.latitude, myPos.longitude),
        );
      } else {
        bounds = LatLngBounds(southwest: shopPos, northeast: myPos);
      }

      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    } catch (e) {
      log("Zoom failed: $e");
    }
  }

  @override
  void dispose() {
    _locationService.stopTrackingLocation();
    _myLocationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStaticStrings.orderTracking)),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatus.success &&
              state.selectedOrder != null) {
            _updatePolyline();
          }
        },
        builder: (context, state) {
          if (state.status == OrderStatus.loading &&
              state.selectedOrder == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == OrderStatus.failure) {
            return Center(
              child: CustomText(state.errorMessage ?? "Error loading order"),
            );
          }
          final order = state.selectedOrder;
          if (order == null) {
            return const Center(child: CustomText("Order details not found"));
          }

          final branch = order.branchId is BranchInfo
              ? (order.branchId as BranchInfo)
              : null;
          final shopName = branch?.branchName ?? "no data";
          final orderId = order.orderId ?? order.id ?? "";
          final lat = branch?.lat ?? 25.2048;
          final lng = branch?.lng ?? 55.2708;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrderBloc>().add(
                FetchOrderDetailsEvent(widget.orderId),
              );
            },
            child: SingleChildScrollView(
              padding: AppPadding.getPadding12(context),
              child: Column(
                spacing: 12,
                children: [
                  // Map Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(lat, lng),
                          zoom: 14,
                        ),
                        onMapCreated: (controller) {
                          _mapController = controller;
                          _updatePolyline();
                          _locationService.startTrackingLocation(
                            markerPosition: _myLocationNotifier,
                            mapController: _mapController,
                          );
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        polylines: _polyLines,
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('shop'),
                            position: LatLng(lat, lng),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueAzure,
                            ),
                            infoWindow: const InfoWindow(title: "Shop"),
                          ),
                          if (_myLocation != null)
                            Marker(
                              markerId: const MarkerId('me'),
                              position: _myLocation!,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueOrange,
                              ),
                              infoWindow: const InfoWindow(title: "Me"),
                            ),
                        },
                      ),
                    ),
                  ),

                  // Arrived Icon Section
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        ImagesConstant.kLocationIcon,
                        height: 48,
                        width: 48,
                        colorFilter: const ColorFilter.mode(
                          AppColors.kPrimaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),

                  // Text Section
                  const CustomText(
                    AppStaticStrings.iveArrived,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),

                  CustomText(
                    AppStaticStrings.iveArrivedDesc,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    color: AppColors.kSecondaryTextColor,
                  ),

                  // Order Card Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        const CustomText(
                          AppStaticStrings.orderNumber,
                          fontSize: 12,
                          color: AppColors.kSecondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          "#$orderId",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomText(
                          shopName,
                          fontSize: 14,
                          color: AppColors.kSecondaryTextColor,
                        ),
                      ],
                    ),
                  ),

                  // Bottom Button
                  CustomButton(
                    text: AppStaticStrings.notifyShop,
                    onPressed: () {
                      // Logic for notify shop
                    },
                    backgroundColor: AppColors.kPrimaryColor,
                    borderRadius: 16,
                  ),

                  // Call Button
                  if (branch?.phoneNumber != null)
                    CustomButton(
                      text: "Call Shop",
                      onPressed: () async {
                        log("Calling ${branch!.phoneNumber}");
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: branch!.phoneNumber,
                        );
                        await launchUrl(launchUri);
                      },
                      backgroundColor: AppColors.kGreenColor,
                      borderRadius: 16,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
