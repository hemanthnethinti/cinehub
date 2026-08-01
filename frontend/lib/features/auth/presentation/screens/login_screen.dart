import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/buttons/buttons.dart';
import '../../../../shared/widgets/inputs/inputs.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

/// Auth sign-in screen wired to [authProvider].
///
/// On successful login [AuthState.authenticated] is emitted and
/// [CineHubApp] (in app.dart) automatically navigates to [MainScreen].
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );
      return;
    }
    await ref.read(authProvider.notifier).login(email: email, password: password);
    // Navigation is driven by authState change in CineHubApp (app.dart).
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.maybeWhen(loading: () => true, orElse: () => false);

    // Show error snackbar on failed login.
    ref.listen<AuthState>(authProvider, (_, next) {
      next.mapOrNull(
        error: (e) => WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }),
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.massive),
              // Logo / Brand
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: AppRadii.borderLg,
                ),
                child: const Icon(Icons.movie_filter, color: Colors.white, size: 28),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Welcome to', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
              Text('CineHub', style: AppTypography.displayMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'The AI-powered filmmaking ecosystem',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: AppSpacing.huge),
              // Form
              AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: _emailCtrl,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordCtrl,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot password?',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Sign In',
                isExpanded: true,
                isLoading: isLoading,
                onPressed: isLoading ? null : _signIn,
              ),
              const SizedBox(height: AppSpacing.lg),
              GhostButton(
                label: 'Create Account',
                isExpanded: true,
                onPressed: isLoading
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text('or continue with', style: AppTypography.caption),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Social
              Row(
                children: [
                  Expanded(
                    child: GhostButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: GhostButton(
                      label: 'Apple',
                      icon: Icons.apple,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

