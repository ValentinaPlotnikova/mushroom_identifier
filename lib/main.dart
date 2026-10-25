import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'core/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'providers/settings_provider.dart';
import 'services/firebase_service.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseService.initialize();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const MushroomIdentifierApp());
}

class MushroomIdentifierApp extends StatelessWidget {
  const MushroomIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider<AuthProvider, FavoritesProvider>(
          create: (_) => FavoritesProvider(),
          update: (_, auth, favorites) {
            favorites ??= FavoritesProvider();
            final uid = auth.firebaseUser?.uid;
            if (uid != null) {
              favorites.bind(uid);
            } else {
              favorites.reset();
            }
            return favorites;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, HistoryProvider>(
          create: (_) => HistoryProvider(),
          update: (_, auth, history) {
            history ??= HistoryProvider();
            final uid = auth.firebaseUser?.uid;
            if (uid != null) {
              history.bind(uid);
            } else {
              history.reset();
            }
            return history;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final settingsProvider =
          context.watch<SettingsProvider>();

          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,

            routerConfig: AppRouter.router,

            locale: Locale(
              settingsProvider.settings.language,
            ),

            supportedLocales:
            AppLocalizations.supportedLocales,

            localizationsDelegates:
            AppLocalizations.localizationsDelegates,
          );
        },
      ),
    );
  }
}
