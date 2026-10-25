import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/validators.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _green = Color(0xFF2E7D32);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    final result = await authProvider.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (result.success) {
      final uid = authProvider.firebaseUser?.uid;

      if (uid == null) {
        _showError(l10n.registerFailed);
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
      _showError(result.errorMessage ?? l10n.registerFailed);
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
    final isLoading = context.watch<AuthProvider>().isLoading;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.registerTitle),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Center(
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
                            color: _green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.eco_outlined,
                            color: _green,
                            size: 42,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.registerCreateAccount,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.registerSubtitle,
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
                                l10n.registerCredentials,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 18),
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
                                validator: Validators.validatePassword,
                                onChanged: (_) {
                                  if (_confirmController.text.isNotEmpty) {
                                    _formKey.currentState?.validate();
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                controller: _confirmController,
                                label: l10n.profileConfirmPassword,
                                prefixIcon: Icons.verified_user_outlined,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                validator: (value) =>
                                    Validators.validateConfirmPassword(
                                  value,
                                  _passwordController.text,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: _green.withValues(alpha: 0.09),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: _green,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        l10n.registerPasswordHint,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: scheme.onSurface,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: isLoading ? null : _submit,
                                  icon: const Icon(
                                    Icons.person_add_alt_1_rounded,
                                  ),
                                  label: Text(l10n.loginRegister),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _green,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        _green.withValues(alpha: 0.40),
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
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          Text(
                            l10n.registerAlreadyHaveAccount,
                            style: theme.textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => context.go('/login'),
                            child: Text(l10n.loginButton),
                          ),
                        ],
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
