import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../core/constants.dart';
import '../core/validators.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    final result = await authProvider.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result.success) {
      final uid = authProvider.firebaseUser?.uid;

      if (uid == null) {
        _showError(l10n.loginFailed);
        return;
      }

      try {
        await settingsProvider.load(uid);
      } catch (e) {
        debugPrint('Settings load failed: $e');
      }

      if (!mounted) return;

      context.go('/home');
    } else {
      _showError(
        result.errorMessage ?? l10n.loginFailed,
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFB3261E),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const green = AppTheme.primaryGreen;

    final isLoading = context.watch<AuthProvider>().isLoading;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.eco_outlined,
                            size: 42,
                            color: green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        AppConstants.appName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginWelcomeBack,
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
                              Text(
                                l10n.loginAccountTitle,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 20),
                              AppTextField(
                                controller: _emailController,
                                label: 'Email',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: _passwordController,
                                label: l10n.loginPassword,
                                prefixIcon: Icons.lock_outline,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.profileEnterPassword;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: isLoading ? null : _submit,
                                  icon: const Icon(Icons.login_rounded),
                                  label: Text(l10n.loginButton),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: green,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        green.withValues(alpha: 0.40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
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
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          Text(
                            l10n.loginNoAccount,
                            style: theme.textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: Text(l10n.loginRegister),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.loginFooter,
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
          ),
        ),
      ),
    );
  }
}
