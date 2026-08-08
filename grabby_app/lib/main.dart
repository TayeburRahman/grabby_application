import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'src/src_export.dart';
import 'src/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Initialize Google Maps Android Renderer
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
    initializeMapRenderer();
  }

  runApp(const MyApp());
}

void initializeMapRenderer() async {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await mapsImplementation.initializeWithRenderer(
        AndroidMapRenderer.latest,
      );
    } catch (e) {
      debugPrint('Failed to initialize latest renderer: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProfileBloc>()..add(GetProfileEvent()),
        ),
        BlocProvider(
          create: (context) => sl<CartBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Grabby App',
        theme: AppTheme.getLightTheme(context),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
