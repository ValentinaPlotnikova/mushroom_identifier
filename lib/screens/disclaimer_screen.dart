import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_theme.dart';
import '../core/constants.dart';
import '../l10n/app_localizations.dart';
import '../services/preferences_service.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  final PreferencesService _prefs = PreferencesService();

  bool _accepted = false;
  bool _saving = false;

  Future<void> _onAccept() async {
    if (!_accepted || _saving) return;

    setState(() => _saving = true);

    try {
      await _prefs.setDisclaimerAccepted();

      if (!mounted) return;

      context.go('/splash');
    } catch (e) {
      if (!mounted) return;

      setState(() => _saving = false);

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.disclaimerSaveError(e.toString()),
          ),
          backgroundColor: const Color(0xFFB3261E),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final isDark = theme.brightness == Brightness.dark;
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';

    const green = AppTheme.primaryGreen;
    const amber = AppTheme.accentAmber;

    final warningBackground =
        isDark ? amber.withValues(alpha: 0.13) : const Color(0xFFFFF8E7);

    final warningTextColor =
        isDark ? const Color(0xFFFFD78A) : const Color(0xFF765019);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 42,
                      color: amber,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.disclaimerTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.disclaimerSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                Card(
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
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                color: amber,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.disclaimerSafetyTitle,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: warningBackground,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: amber.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isEnglish) ...[
                                Text(
                                  l10n.disclaimerEnglishSafetyNotice,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: warningTextColor,
                                    height: 1.55,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Divider(
                                  color: amber.withValues(alpha: 0.35),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.disclaimerOriginalTextLabel,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: warningTextColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              Text(
                                AppConstants.disclaimerText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: warningTextColor,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          decoration: BoxDecoration(
                            color: green.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CheckboxListTile(
                            value: _accepted,
                            enabled: !_saving,
                            activeColor: green,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            title: Text(
                              l10n.disclaimerAgreement,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onChanged: _saving
                                ? null
                                : (value) {
                                    setState(() {
                                      _accepted = value ?? false;
                                    });
                                  },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _accepted && !_saving ? _onAccept : null,
                            icon: _saving
                                ? const SizedBox(
                                    width: 19,
                                    height: 19,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                  ),
                            label: Text(
                              _saving
                                  ? l10n.disclaimerSaving
                                  : l10n.disclaimerAcceptContinue,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: green,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  green.withValues(alpha: 0.35),
                              disabledForegroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.disclaimerFooter,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
