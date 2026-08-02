import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'package:cinehubapp/shared/widgets/inputs/inputs.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/auth/presentation/widgets/auth_widgets.dart';

/// Forgot password screen — sends a password reset email.
///
/// Backend always returns 200 regardless of whether the email exists,
/// so the UI shows a success message unconditionally after the request.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _emailSent  = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authNotifierProvider.notifier).forgotPassword(
          email: _emailCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      if (!mounted) return;
      if (next is AuthSuccess) {
        setState(() => _emailSent = true);
        ref.read(authNotifierProvider.notifier).clearError();
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: _emailSent ? _SuccessView(email: _emailCtrl.text.trim()) : _FormView(
            formKey: _formKey,
            emailCtrl: _emailCtrl,
            isLoading: isLoading,
            onSubmit: _submit,
          ),
        ),
      ),
    );
  }
}

// ── Form View ─────────────────────────────────────────────────

class _FormView extends StatelessWidget {
  const _FormView({
    required this.formKey,
    required this.emailCtrl,
    required this.isLoading,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthHeader(
            title: 'Reset password.',
            subtitle: "Enter your email and we'll send a reset link.",
          ),
          const SizedBox(height: AppSpacing.massive),

          AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.mail_outline_rounded,
            enabled: !isLoading,
            onSubmitted: (_) => onSubmit(),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required.';
              final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              if (!regex.hasMatch(v.trim())) return 'Enter a valid email.';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          PrimaryButton(
            label: 'Send Reset Link',
            isExpanded: true,
            isLoading: isLoading,
            onPressed: isLoading ? null : onSubmit,
            height: 52,
          ),
        ],
      ),
    );
  }
}

// ── Success View ──────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.colossal),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.successMuted,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: AppColors.success,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Check your inbox', style: AppTypography.headlineLarge),
        const SizedBox(height: AppSpacing.md),
        Text(
          'If $email is registered, you will receive a reset link shortly.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxl),
        GhostButton(
          label: 'Back to Login',
          isExpanded: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
