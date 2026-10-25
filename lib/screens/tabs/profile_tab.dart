import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/loading_overlay.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  static const Color _green = Color(0xFF2E7D32);
  static const Color _red = Color(0xFFB3261E);

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileLogoutTitle),
        content: Text(l10n.profileLogoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.profileCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.profileLogoutConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final authProvider = context.read<AuthProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    await authProvider.signOut();

    if (!context.mounted) return;

    settingsProvider.reset();
    context.go('/login');
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileDeleteTitle),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.profileDeleteWarning,
                  style: const TextStyle(color: _red),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.profileConfirmPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.profileEnterPassword;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.profileCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: _red,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(l10n.profileDeleteForever),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      passwordController.dispose();
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final result = await authProvider.deleteAccount(
      password: passwordController.text,
    );

    passwordController.dispose();

    if (!context.mounted) return;

    if (result.success) {
      context.read<SettingsProvider>().reset();
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ?? l10n.profileDeleteFailed,
          ),
          backgroundColor: _red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final appUser = authProvider.appUser;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final email = appUser?.email ?? authProvider.firebaseUser?.email ?? '—';

    final createdAt = appUser?.createdAt;
    final total = appUser?.totalIdentifications ?? 0;

    final locale = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: LoadingOverlay(
        isLoading: authProvider.isLoading,
        child: RefreshIndicator(
          onRefresh: () => authProvider.refreshUser(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
            children: [
              _ProfileCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: _green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 38,
                        color: _green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.profileMyProfile,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.profilePersonalAccount,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            email,
                            softWrap: true,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.profileMyActivity,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _ProfileCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ActivityItem(
                        icon: Icons.analytics_outlined,
                        label: l10n.profileIdentifications,
                        value: '$total',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActivityItem(
                        icon: Icons.calendar_today_outlined,
                        label: l10n.profileRegistration,
                        value: createdAt != null
                            ? DateFormat('dd.MM.yyyy', locale).format(createdAt)
                            : '—',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.profileAccountManagement,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _ProfileCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    _ProfileAction(
                      icon: Icons.settings_outlined,
                      title: l10n.settings,
                      subtitle: l10n.profileAppSettings,
                      color: _green,
                      onTap: () => context.push('/settings'),
                    ),
                    const Divider(
                      indent: 72,
                      endIndent: 16,
                      height: 1,
                    ),
                    _ProfileAction(
                      icon: Icons.logout_rounded,
                      title: l10n.profileLogoutAction,
                      color: theme.colorScheme.onSurfaceVariant,
                      onTap: () => _confirmLogout(context),
                    ),
                    const Divider(
                      indent: 72,
                      endIndent: 16,
                      height: 1,
                    ),
                    _ProfileAction(
                      icon: Icons.delete_outline_rounded,
                      title: l10n.profileDeleteAction,
                      color: _red,
                      isDestructive: true,
                      onTap: () => _confirmDelete(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _ProfileCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: scheme.outlineVariant,
          width: 0.7,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ActivityItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(minHeight: 132),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: green.withValues(
          alpha: isDark ? 0.20 : 0.09,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isDark ? const Color(0xFF81C784) : green,
            size: 24,
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF81C784) : green,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            softWrap: true,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileAction({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    this.isDestructive = false,
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
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 23,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isDestructive ? color : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
