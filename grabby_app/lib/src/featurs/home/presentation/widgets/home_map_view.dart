import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../src_export.dart';

class HomeMapView extends StatefulWidget {
  const HomeMapView({super.key});

  @override
  State<HomeMapView> createState() => _HomeMapViewState();
}

class _HomeMapViewState extends State<HomeMapView> {
  LatLng _initialPosition = const LatLng(23.8103, 90.4125); // Dhaka default
  bool _isLocationLoaded = false;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _customIcons = {};
  BitmapDescriptor? _placeholderIcon;

  @override
  void initState() {
    super.initState();
    _loadPlaceholder();
    _getCurrentLocation();
    
    // Check if state is already loaded and load markers
    final branchBloc = context.read<CustomerBranchBloc>();
    if (branchBloc.state is CustomerBranchesLoaded) {
      _loadMarkers((branchBloc.state as CustomerBranchesLoaded).branches);
    }
  }

  Future<void> _loadPlaceholder() async {
    _placeholderIcon = await _getPlaceholderIcon(isPlaceholder: true);
    if (mounted) setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    final position = await sl<LocationService>().getCurrentPosition();
    if (position != null && mounted) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _isLocationLoaded = true;
      });
      _fitToMarkers();
    }
  }

  Future<void> _loadMarkers(List<CustomerBranchModel> branches) async {
    bool updated = false;
    await Future.wait(branches.map((branch) async {
      if (!_customIcons.containsKey(branch.id)) {
        try {
          final icon = await _getMarkerIcon(branch);
          _customIcons[branch.id] = icon;
          updated = true;
        } catch (e) {
          debugPrint("Error loading marker for ${branch.branchName}: $e");
        }
      }
    }));

    if (updated && mounted) {
      setState(() {});
    }
  }

  Future<ui.Image> _loadNetworkImage(String path) async {
    final Completer<ui.Image> completer = Completer();
    final ImageStream stream =
        NetworkImage(path).resolve(const ImageConfiguration());
    ImageStreamListener? listener;
    listener = ImageStreamListener((ImageInfo info, bool _) {
      if (!completer.isCompleted) {
        completer.complete(info.image);
      }
      if (listener != null) stream.removeListener(listener);
    }, onError: (exception, stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(exception);
      }
      if (listener != null) stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }

  Future<BitmapDescriptor> _getPlaceholderIcon({bool isPlaceholder = false}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    const double width = 300.0;
    const double height = 100.0;
    const double radius = 50.0;

    // Draw shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(5, 5, width, height),
        const Radius.circular(radius),
      ),
      shadowPaint,
    );

    // Draw white background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(radius),
      ),
      paint,
    );

    if (isPlaceholder) {
      // Draw placeholder circle for image
      final Paint placeholderPaint = Paint()..color = Colors.grey.shade200;
      canvas.drawCircle(const Offset(50, 50), 40, placeholderPaint);
      
      // Draw placeholder lines for text
      final Paint linePaint = Paint()..color = Colors.grey.shade100;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(110, 25, 150, 20),
          const Radius.circular(4),
        ),
        linePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(110, 55, 100, 15),
          const Radius.circular(4),
        ),
        linePaint,
      );
    }

    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
          width.toInt() + 10,
          height.toInt() + 10,
        );
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _getMarkerIcon(CustomerBranchModel branch) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    const double width = 300.0;
    const double height = 100.0;
    const double radius = 50.0;
    const double imageSize = 80.0;

    // Draw shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(5, 5, width, height),
        const Radius.circular(radius),
      ),
      shadowPaint,
    );

    // Draw white background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(radius),
      ),
      paint,
    );

    // Draw branch image
    if (branch.image != null && branch.image!.isNotEmpty) {
      try {
        final ui.Image image =
            await _loadNetworkImage("${ApiEndpoints.baseUrl}${branch.image}");
        canvas.save();
        final Path clipPath = Path()
          ..addOval(const Rect.fromLTWH(10, 10, imageSize, imageSize));
        canvas.clipPath(clipPath);
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          const Rect.fromLTWH(10, 10, imageSize, imageSize),
          Paint(),
        );
        canvas.restore();
      } catch (e) {
        final Paint iconPaint = Paint()..color = AppColors.kPrimaryColor;
        canvas.drawCircle(const Offset(50, 50), 40, iconPaint);
      }
    } else {
      final Paint iconPaint = Paint()..color = AppColors.kPrimaryColor;
      canvas.drawCircle(const Offset(50, 50), 40, iconPaint);
    }

    // Draw Name and Distance
    final TextPainter namePainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    );
    namePainter.text = TextSpan(
      text: branch.branchName,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
    namePainter.layout(minWidth: 0, maxWidth: width - imageSize - 40);
    namePainter.paint(canvas, const Offset(imageSize + 20, 20));

    final TextPainter distPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    distPainter.text = TextSpan(
      text: branch.distanceText,
      style: const TextStyle(
        color: AppColors.kPrimaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),
    );
    distPainter.layout();
    distPainter.paint(canvas, const Offset(imageSize + 20, 55));

    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
          width.toInt() + 10,
          height.toInt() + 10,
        );
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _fitToMarkers() {
    if (_mapController == null) return;

    List<LatLng> points = [];
    if (_isLocationLoaded) {
      points.add(_initialPosition);
    }

    for (var marker in _markers) {
      points.add(marker.position);
    }

    if (points.isEmpty) return;

    LatLngBounds bounds;
    if (points.length == 1) {
      bounds = LatLngBounds(southwest: points.first, northeast: points.first);
    } else {
      double minLat = points.first.latitude;
      double maxLat = points.first.latitude;
      double minLng = points.first.longitude;
      double maxLng = points.first.longitude;

      for (var point in points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }
      bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 70), // 70 is padding
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerBranchBloc, CustomerBranchState>(
      listener: (context, state) {
        if (state is CustomerBranchesLoaded) {
          _loadMarkers(state.branches);
          WidgetsBinding.instance.addPostFrameCallback((_) => _fitToMarkers());
        }
      },
      child: BlocBuilder<CustomerBranchBloc, CustomerBranchState>(
        builder: (context, state) {
          LatLng targetPosition = _initialPosition;

          if (state is CustomerBranchesLoaded) {
            _markers = state.branches.map((branch) {
              return Marker(
                markerId: MarkerId(branch.id),
                position: LatLng(branch.lat, branch.lng),
                icon: _customIcons[branch.id] ?? 
                      (_placeholderIcon ?? BitmapDescriptor.defaultMarker),
                onTap: () {
                  context.pushNamed(
                    RoutesPath.restruantDetailsPath,
                    extra: branch.id,
                  );
                },
              );
            }).toSet();

            if (!_isLocationLoaded && state.branches.isNotEmpty) {
              final first = state.branches.first;
              targetPosition = LatLng(first.lat, first.lng);
            }
          }

          return SliverFillRemaining(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: targetPosition,
                zoom: 12,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                _mapController = controller;
                if (_markers.isNotEmpty || _isLocationLoaded) {
                  _fitToMarkers();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

