import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../services/data_seed_service.dart';
import '../services/preferences_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferencesService _prefs = PreferencesService();
  final DataSeedService _seedService = DataSeedService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _bootstrap();
      }
    });
  }

  Future<void> _bootstrap() async {
    try {
      await _seedService.seedIfNeeded().timeout(
            const Duration(seconds: 8),
          );
    } catch (_) {}

    if (!mounted) return;

    bool accepted;

    try {
      accepted = await _prefs.isDisclaimerAccepted();
    } catch (_) {
      accepted = false;
    }

    if (!mounted) return;

    if (!accepted) {
      context.go('/disclaimer');
      return;
    }

    final authProvider = context.read<AuthProvider>();

    await _waitForAuth(authProvider);

    if (!mounted) return;

    final firebaseUser = authProvider.firebaseUser;

    if (authProvider.isAuthenticated && firebaseUser != null) {
      final settingsProvider = context.read<SettingsProvider>();

      try {
        await settingsProvider.load(firebaseUser.uid).timeout(
              const Duration(seconds: 8),
            );
      } catch (_) {}

      if (!mounted) return;

      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  Future<void> _waitForAuth(AuthProvider provider) async {
    if (provider.status != AuthStatus.unknown) return;

    final completer = Completer<void>();

    void listener() {
      if (provider.status != AuthStatus.unknown && !completer.isCompleted) {
        completer.complete();
      }
    }

    provider.addListener(listener);

    try {
      if (provider.status != AuthStatus.unknown) {
        return;
      }

      await completer.future.timeout(
        const Duration(seconds: 10),
      );
    } on TimeoutException {
      return;
    } finally {
      provider.removeListener(listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.eco,
              size: 96,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
