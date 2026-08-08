import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../src_export.dart';
import '../../../../core/services/socket_service.dart';

class ShopOrderDetailsPage extends StatefulWidget {
  final String orderId;
  final String socketOrderID;
  const ShopOrderDetailsPage({
    super.key,
    required this.orderId,
    required this.socketOrderID,
  });

  @override
  State<ShopOrderDetailsPage> createState() => _ShopOrderDetailsPageState();
}

class _ShopOrderDetailsPageState extends State<ShopOrderDetailsPage> {
  LatLng? _customerLocation;
  GoogleMapController? _mapController;
  Set<Polyline> _polyLines = {};
  bool _isGeneratingPolyline = false;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
    _initSocket();
  }

  void _initSocket() {
    final socketService = sl<SocketService>();
    socketService.on('locationUpdate/${widget.socketOrderID}', (data) {
      if (data != null && data['lat'] != null && data['lon'] != null) {
        log("customer location: $data");
        if (mounted) {
          setState(() {
            _customerLocation = LatLng(
              double.parse(data['lat'].toString()),
              double.parse(data['lon'].toString()),
            );
          });
          _updatePolyline();
          _updateCameraPosition();
        }
      }
    });
  }

  void _updatePolyline() {
    final state = context.read<OrderBloc>().state;
    final order = state.selectedOrder;
    if (order == null || _customerLocation == null) return;

    final branch = order.branchId is BranchInfo
        ? (order.branchId as BranchInfo)
        : null;
    if (branch == null) return;

    final shopPos = LatLng(branch.lat ?? 0, branch.lng ?? 0);
    _generatePolyline(shopPos, _customerLocation!);
  }

  Future<void> _generatePolyline(LatLng origin, LatLng dest) async {
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
      }
    } catch (e) {
      log("Polyline Exception: $e");
    } finally {
      _isGeneratingPolyline = false;
    }
  }

  void _updateCameraPosition() {
    if (_mapController == null || _customerLocation == null) return;

    // Get shop location from state (assuming it's loaded)
    final state = context.read<OrderBloc>().state;
    final order = state.selectedOrder;
    if (order == null) return;

    final branch = order.branchId is BranchInfo
        ? (order.branchId as BranchInfo)
        : null;
    if (branch == null) return;

    final shopPos = LatLng(branch.lat ?? 0, branch.lng ?? 0);

    LatLngBounds bounds;
    if (shopPos.latitude > _customerLocation!.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(
          _customerLocation!.latitude,
          _customerLocation!.longitude < shopPos.longitude
              ? _customerLocation!.longitude
              : shopPos.longitude,
        ),
        northeast: LatLng(
          shopPos.latitude,
          _customerLocation!.longitude > shopPos.longitude
              ? _customerLocation!.longitude
              : shopPos.longitude,
        ),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(
          shopPos.latitude,
          _customerLocation!.longitude < shopPos.longitude
              ? _customerLocation!.longitude
              : shopPos.longitude,
        ),
        northeast: LatLng(
          _customerLocation!.latitude,
          _customerLocation!.longitude > shopPos.longitude
              ? _customerLocation!.longitude
              : shopPos.longitude,
        ),
      );
    }

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  void dispose() {
    sl<SocketService>().off('locationUpdate/${widget.socketOrderID}');
    _mapController?.dispose();
    super.dispose();
  }

  void _fetchDetails() {
    context.read<OrderBloc>().add(FetchOrderDetailsEvent(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          "#${widget.orderId}",
          variant: TextVariant.headlineMedium,
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.status == OrderStatus.success &&
              state.successMessage != null &&
              state.successMessage!.contains("Order status updated")) {
            _fetchDetails();
            // Optional: return true to refresh parent list
          }
          if (state.status == OrderStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Error")),
            );
          }
        },
        builder: (context, state) {
          if (state.status == OrderStatus.loading &&
              state.selectedOrder == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final order = state.selectedOrder;
          if (order == null) {
            return const Center(child: CustomText("Order not found"));
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchDetails(),
            child: SingleChildScrollView(
              padding: AppPadding.getPadding12(context).copyWith(top: 0),
              child: Column(
                spacing: 8,
                children: [
                  _buildStatusStepper(order.status ?? ""),
                  _buildPickupInfo(order),
                  _buildMapSection(order),
                  _buildItemsSection(order),
                  _buildActionButtons(
                    order,
                    state.status == OrderStatus.updating,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusStepper(String currentStatus) {
    final List<String> statuses = ['placed', 'preparing', 'ready', 'completed'];

    return Container(
      padding: AppPadding.getPadding8(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        children: statuses.asMap().entries.map((entry) {
          int idx = entry.key;
          String status = entry.value;
          bool isCompleted = _isStatusCompleted(status, currentStatus);
          bool isCurrent = currentStatus.toLowerCase() == status.toLowerCase();

          return Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted || isCurrent
                          ? AppColors.kPrimaryColor
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  if (idx != statuses.length - 1)
                    Container(
                      width: 2,
                      height: 20,
                      color: isCompleted
                          ? AppColors.kPrimaryColor
                          : Colors.grey.shade300,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              CustomText(
                status.toUpperCase(),
                variant: TextVariant.bodyMedium,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCompleted || isCurrent
                    ? AppColors.kTextColor
                    : AppColors.kSecondaryTextColor,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  bool _isStatusCompleted(String status, String currentStatus) {
    final List<String> order = ['placed', 'preparing', 'ready', 'completed'];
    int currentIdx = order.indexOf(currentStatus.toLowerCase());
    int statusIdx = order.indexOf(status.toLowerCase());
    return statusIdx < currentIdx;
  }

  Widget _buildPickupInfo(OrderModel order) {
    return Container(
      padding: AppPadding.getPadding8(context),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            AppStaticStrings.pickupDetails,
            variant: TextVariant.titleMedium,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              SvgPicture.asset(ImagesConstant.kGroupIcon),
              CustomText(
                order.pickupType == "carPickup"
                    ? "Car Pickup (${order.carPlates})"
                    : "Walk-in",
                variant: TextVariant.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(OrderModel order) {
    final customer = order.customerId is CustomerInfo
        ? (order.customerId as CustomerInfo)
        : null;
    _customerLocation = LatLng(customer?.lat ?? 0, customer?.lon ?? 0);
    final branch = order.branchId is BranchInfo
        ? (order.branchId as BranchInfo)
        : null;
    final shopLat = branch?.lat ?? 25.2048;
    final shopLng = branch?.lng ?? 55.2708;
    final shopPos = LatLng(shopLat, shopLng);
    _generatePolyline(shopPos, _customerLocation!);
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kAccentColor,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(appRadius),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: shopPos, zoom: 14),
          onMapCreated: (controller) {
            _mapController = controller;
            if (_customerLocation != null) {
              _updateCameraPosition();
            }
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
              position: shopPos,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              ),
              infoWindow: const InfoWindow(title: "Shop Location"),
            ),
            if (_customerLocation != null)
              Marker(
                markerId: const MarkerId('customer'),
                position: _customerLocation!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                ),
                infoWindow: const InfoWindow(title: "Customer Location"),
              ),
          },
        ),
      ),
    );
  }

  Widget _buildItemsSection(OrderModel order) {
    return Container(
      padding: AppPadding.getPadding8(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(appRadius),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            AppStaticStrings.orderItems,
            variant: TextVariant.titleMedium,
            fontWeight: FontWeight.bold,
          ),
          ...order.items.map(
            (item) => Column(
              children: [
                _buildItemRow(
                  "${item.quantity}x ${item.menuName}",
                  "AED ${item.totalPrice?.toStringAsFixed(2)}",
                ),
                if (item.additionalItems != null &&
                    item.additionalItems!.isNotEmpty)
                  ...(item.additionalItems!
                      .map((e) => _buildItemRow("+ ${e.name}", ""))
                      .toList()),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                AppStaticStrings.orderTotal,
                variant: TextVariant.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                "${order.totalAmount.toStringAsFixed(2)} AED",
                variant: TextVariant.titleLarge,
                color: AppColors.kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(name, variant: TextVariant.bodyMedium),
        CustomText(price, variant: TextVariant.titleSmall),
      ],
    );
  }

  Widget _buildActionButtons(OrderModel order, bool isUpdating) {
    String mainButtonText = "";
    String nextStatus = "";
    final currentStatus = order.status?.toLowerCase();

    if (currentStatus == 'placed') {
      mainButtonText = AppStaticStrings.startPreparing;
      nextStatus = 'preparing';
    } else if (currentStatus == 'preparing') {
      mainButtonText = AppStaticStrings.markAsReady;
      nextStatus = 'ready';
    } else if (currentStatus == 'ready') {
      mainButtonText = AppStaticStrings.completeOrder;
      nextStatus = 'completed';
    }

    return Column(
      children: [
        if (mainButtonText.isNotEmpty)
          CustomButton(
            text: mainButtonText,
            isLoading: isUpdating,
            onPressed: () {
              context.read<OrderBloc>().add(
                UpdateOrderStatusEvent(
                  orderId: order.id ?? "",
                  status: nextStatus,
                ),
              );
            },
          ),
        CustomButton(
          text: AppStaticStrings.cancelOrder,
          onPressed: () {
            context.read<OrderBloc>().add(
              UpdateOrderStatusEvent(
                orderId: order.id ?? "",
                status: 'cancelled',
              ),
            );
          },
          backgroundColor: Colors.white,
          textColor: AppColors.kRedColor,
          borderColor: AppColors.kRedColor,
        ),
      ],
    );
  }
}
