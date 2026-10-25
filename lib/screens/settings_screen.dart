import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../services/export_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _clearCache(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsClearCacheTitle),
        content: Text(l10n.settingsClearCacheMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.profileCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.settingsClearButton),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final tempDir = await getTemporaryDirectory();

      if (await tempDir.exists()) {
        await for (final entity in tempDir.list()) {
          try {
            await entity.delete(recursive: true);
          } catch (_) {}
        }
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.settingsCacheCleared),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.settingsClearCacheFailed(e.toString()),
          ),
          backgroundColor: const Color(0xFFB3261E),
        ),
      );
    }
  }

  Future<void> _exportData(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final uid = context.read<AuthProvider>().firebaseUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.previewLoginRequired),
        ),
      );
      return;
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    var loadingDialogOpen = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final result = await ExportService().exportUserData(uid);

      if (loadingDialogOpen && navigator.mounted && navigator.canPop()) {
        navigator.pop();
        loadingDialogOpen = false;
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? l10n.settingsExportSaved(result.filePath ?? '')
                : result.errorMessage ?? l10n.settingsExportFailed,
          ),
          duration: Duration(
            seconds: result.success ? 6 : 4,
          ),
          backgroundColor: result.success ? null : const Color(0xFFB3261E),
        ),
      );
    } catch (e) {
      if (loadingDialogOpen && navigator.mounted && navigator.canPop()) {
        navigator.pop();
        loadingDialogOpen = false;
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.settingsExportError(e.toString()),
          ),
          backgroundColor: const Color(0xFFB3261E),
        ),
      );
    }
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final provider = context.read<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;
    final current = provider.settings.language;

    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(l10n.settingsLanguageTitle),
        children: [
          _LanguageOption(
            label: 'Русский',
            selected: current == 'ru',
            onTap: () => Navigator.pop(dialogContext, 'ru'),
          ),
          _LanguageOption(
            label: 'English',
            selected: current == 'en',
            onTap: () => Navigator.pop(dialogContext, 'en'),
          ),
        ],
      ),
    );

    if (selected == null || selected == current || !context.mounted) {
      return;
    }

    try {
      await provider.setLanguage(selected);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.settingsLanguageFailed,
          ),
          backgroundColor: const Color(0xFFB3261E),
        ),
      );
    }
  }

  String _languageLabel(String code) {
    return code == 'en' ? 'English' : 'Русский';
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          _SettingsSectionTitle(
            title: l10n.settingsAppSection,
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsAction(
                  icon: Icons.language_rounded,
                  title: l10n.language,
                  subtitle: _languageLabel(settings.language),
                  onTap: () => _pickLanguage(context),
                ),
                const _SettingsDivider(),
                _SettingsSwitch(
                  icon: Icons.notifications_outlined,
                  title: l10n.notifications,
                  subtitle: l10n.settingsNotificationsSubtitle,
                  value: settings.notificationsEnabled,
                  onChanged: settingsProvider.setNotifications,
                ),
                const _SettingsDivider(),
                _SettingsSwitch(
                  icon: Icons.location_on_outlined,
                  title: l10n.geolocation,
                  subtitle: l10n.settingsGeolocationSubtitle,
                  value: settings.geolocationEnabled,
                  onChanged: settingsProvider.setGeolocation,
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          _SettingsSectionTitle(
            title: l10n.settingsDataSection,
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsAction(
                  icon: Icons.cleaning_services_outlined,
                  title: l10n.clearCache,
                  subtitle: l10n.settingsClearCacheSubtitle,
                  onTap: () => _clearCache(context),
                ),
                const _SettingsDivider(),
                _SettingsAction(
                  icon: Icons.download_outlined,
                  title: l10n.settingsExportTitle,
                  subtitle: l10n.settingsExportSubtitle,
                  onTap: () => _exportData(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Mushroom Identifier',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String title;

  const _SettingsSectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: scheme.outlineVariant,
          width: 0.7,
        ),
      ),
      child: child,
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 72,
      endIndent: 16,
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  final IconData icon;

  const _SettingsIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF81C784)
            : green,
        size: 23,
      ),
    );
  }
}

class _SettingsAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsAction({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        child: Row(
          children: [
            _SettingsIcon(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      softWrap: true,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Row(
          children: [
            _SettingsIcon(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      softWrap: true,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Switch(
              value: value,
              activeThumbColor: const Color(0xFF2E7D32),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected
            ? const Color(0xFF2E7D32)
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
