import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/connectivity_service.dart';
import 'tabs/favorites_tab.dart';
import 'tabs/history_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/profile_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final ConnectivityService _connectivity = ConnectivityService();
  StreamSubscription<bool>? _connectivitySub;
  bool _wasOffline = false;

  static const List<Widget> _tabs = [
    HomeTab(),
    HistoryTab(),
    FavoritesTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();

    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }

  void _onConnectivityChanged(bool connected) {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    if (!connected) {
      _wasOffline = true;

      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(l10n.navigationOfflineMessage),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF616161),
          duration: const Duration(days: 1),
        ),
      );
    } else {
      messenger.hideCurrentSnackBar();

      if (_wasOffline) {
        _wasOffline = false;

        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.navigationOnlineMessage),
            backgroundColor: const Color(0xFF2E7D32),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    const green = Color(0xFF2E7D32);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            top: BorderSide(
              color: scheme.outlineVariant,
              width: 0.7,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                indicatorColor: green.withValues(
                  alpha: isDark ? 0.22 : 0.12,
                ),
                labelTextStyle: WidgetStateProperty.resolveWith(
                  (states) {
                    final selected = states.contains(WidgetState.selected);

                    return TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? (isDark ? const Color(0xFF81C784) : green)
                          : scheme.onSurfaceVariant,
                    );
                  },
                ),
                iconTheme: WidgetStateProperty.resolveWith(
                  (states) {
                    final selected = states.contains(WidgetState.selected);

                    return IconThemeData(
                      size: 24,
                      color: selected
                          ? (isDark ? const Color(0xFF81C784) : green)
                          : scheme.onSurfaceVariant,
                    );
                  },
                ),
              ),
              child: NavigationBar(
                height: 68,
                elevation: 0,
                backgroundColor: Colors.transparent,
                selectedIndex: _currentIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.camera_alt_outlined),
                    selectedIcon: const Icon(Icons.camera_alt_rounded),
                    label: l10n.identify,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.history_outlined),
                    selectedIcon: const Icon(Icons.history_rounded),
                    label: l10n.history,
                  ),
                  NavigationDestination(
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                    ),
                    selectedIcon: const Icon(Icons.favorite_rounded),
                    label: l10n.favorites,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.person_outline_rounded),
                    selectedIcon: const Icon(Icons.person_rounded),
                    label: l10n.profile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
