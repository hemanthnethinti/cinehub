import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'package:cinehubapp/shared/widgets/inputs/inputs.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/auth/presentation/widgets/auth_widgets.dart';

/// Login screen — email + password form.
///
/// Listens to [authNotifierProvider]:
/// - [AuthLoading]         → disables form, shows spinner on button
/// - [AuthAuthenticated]   → navigates to [Routes.home]
/// - [AuthFailure]         → shows SnackBar error and resets state
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl   = TextEditingController();
  bool _hasNavigated = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authNotifierProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _pwdCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    // Navigate on success.
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (!mounted || _hasNavigated) return;
      if (next is AuthAuthenticated) {
        _hasNavigated = true;
        context.go(Routes.home);
      } else if (next is AuthFailure) {
        ref.read(authNotifierProvider.notifier).clearError();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.errorMuted,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.huge,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────
                const AuthHeader(
                  title: 'Welcome back.',
                  subtitle: 'Sign in to continue your story.',
                ),
                const SizedBox(height: AppSpacing.massive),

                // ── Email ─────────────────────────────────────────
                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.mail_outline_rounded,
                  enabled: !isLoading,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email is required.';
                    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!regex.hasMatch(v.trim())) return 'Enter a valid email.';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Password ──────────────────────────────────────
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _pwdCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  enabled: !isLoading,
                  onSubmitted: (_) => _submit(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required.';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Forgot password ───────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context.push(Routes.forgotPassword),
                    child: const Text('Forgot password?'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Sign In button ────────────────────────────────
                PrimaryButton(
                  label: 'Sign In',
                  isExpanded: true,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                  height: 52,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Register link ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppTypography.bodySmall,
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.push(Routes.register),
                      child: const Text('Create account'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
