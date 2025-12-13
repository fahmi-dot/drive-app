import 'package:driver_app/features/drive/presentation/screens/home_screen.dart';
import 'package:driver_app/shared/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class Routes {
  static const splash = '/';
  static const home = '/home';
  static const jobDetail = '/job/:id';
  static const cameraAction = '/camera';
  static const stopAction = '/stop';

  static String jobWithId(Uuid id) => '/job/$id';
}

final appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomeScreen(),
    ),
  ]
);