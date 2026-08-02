import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'package:cinehubapp/shared/widgets/inputs/inputs.dart';
import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/auth/presentation/widgets/auth_widgets.dart';

/// Registration screen — full form with role picker.
///
/// Fields: first name, last name, email, password (+ strength bar), role.
/// Role picker shows only [UserRole.registrationRoles].
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _firstCtrl    = TextEditingController();
  final _lastCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _pwdCtrl      = TextEditingController();

  UserRole _selectedRole = UserRole.creator;
  String _password = '';
  bool _hasNavigated = false;

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authNotifierProvider.notifier).register(
          email: _emailCtrl.text.trim(),
          password: _pwdCtrl.text,
          firstName: _firstCtrl.text.trim(),
          lastName: _lastCtrl.text.trim(),
          role: _selectedRole.value,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

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
                  title: 'Create account.',
                  subtitle: 'Join thousands of filmmakers on CineHub.',
                ),
                const SizedBox(height: AppSpacing.massive),

                // ── Name row ──────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First name',
                        hint: 'Jane',
                        controller: _firstCtrl,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required.';
                          if (v.trim().length > 50) return 'Too long.';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Last name',
                        hint: 'Doe',
                        controller: _lastCtrl,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required.';
                          if (v.trim().length > 50) return 'Too long.';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

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

                // ── Password + strength ───────────────────────────
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _pwdCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  enabled: !isLoading,
                  onChanged: (v) => setState(() => _password = v),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required.';
                    if (v.length < 8) return 'Minimum 8 characters.';
                    final pwdRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)');
                    if (!pwdRegex.hasMatch(v)) {
                      return 'Include uppercase, lowercase, and a number.';
                    }
                    return null;
                  },
                ),
                PasswordStrengthIndicator(password: _password),
                const SizedBox(height: AppSpacing.xxl),

                // ── Role picker ───────────────────────────────────
                Text('I am a...', style: AppTypography.labelMedium),
                const SizedBox(height: AppSpacing.md),
                _RolePicker(
                  selected: _selectedRole,
                  onChanged: isLoading ? null : (r) => setState(() => _selectedRole = r),
                ),
                const SizedBox(height: AppSpacing.massive),

                // ── Create account button ─────────────────────────
                PrimaryButton(
                  label: 'Create Account',
                  isExpanded: true,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                  height: 52,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Already have account ──────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?', style: AppTypography.bodySmall),
                    TextButton(
                      onPressed: isLoading ? null : () => context.pop(),
                      child: const Text('Sign in'),
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

// ── Role Picker ───────────────────────────────────────────────

class _RolePicker extends StatelessWidget {
  const _RolePicker({required this.selected, this.onChanged});

  final UserRole selected;
  final ValueChanged<UserRole>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: UserRole.registrationRoles.map((role) {
        final isSelected = role == selected;
        return GestureDetector(
          onTap: () => onChanged?.call(role),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryMuted : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.label,
                        style: AppTypography.labelMedium.copyWith(
                          color: isSelected ? AppColors.primaryLight : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        role.description,
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
