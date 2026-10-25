import 'package:go_router/go_router.dart';

import '../screens/disclaimer_screen.dart';
import '../screens/history_detail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/mushroom_detail_screen.dart';
import '../screens/mushroom_list_screen.dart';
import '../screens/register_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/disclaimer',
        builder: (context, state) => const DisclaimerScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/encyclopedia',
        builder: (context, state) => const MushroomListScreen(),
      ),
      GoRoute(
        path: '/mushroom/:id',
        builder: (context, state) => MushroomDetailScreen(
          mushroomId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/history/:id',
        builder: (context, state) => HistoryDetailScreen(
          identificationId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}
