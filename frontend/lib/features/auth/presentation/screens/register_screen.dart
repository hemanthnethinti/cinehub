import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/buttons/buttons.dart';
import '../../../../shared/widgets/inputs/inputs.dart';
import '../../providers/auth_provider.dart';

/// Account registration screen wired to [authProvider].
///
/// Replaces the old [SignupScreen] from `screens/auth/login_screen.dart`.
/// On successful registration [AuthState.authenticated] is emitted and
/// [CineHubApp] (in app.dart) navigates to [MainScreen] automatically.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl  = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();

  String? _selectedRole;

  static const _roles = [
    'Director',
    'Cinematographer',
    'Editor',
    'Producer',
    'Sound Designer',
    'VFX Artist',
    'Screenwriter',
    'Actor',
    'Other',
  ];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final firstName = _firstNameCtrl.text.trim();
    final lastName  = _lastNameCtrl.text.trim();
    final email     = _emailCtrl.text.trim();
    final password  = _passwordCtrl.text;

    if (firstName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First name, email and password are required.')),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters.')),
      );
      return;
    }

    await ref.read(authProvider.notifier).register(
          email:     email,
          password:  password,
          firstName: firstName,
          lastName:  lastName,
          role:      _selectedRole,
        );
    // Navigation is driven by authState change in CineHubApp (app.dart).
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.maybeWhen(loading: () => true, orElse: () => false);

    // Show error snackbar on failed registration.
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.lg,
            AppSpacing.xxl,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Account', style: AppTypography.displayMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Join thousands of filmmakers on CineHub',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: AppSpacing.huge),

              // ── Name row ──────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'First Name',
                      hint: 'Alex',
                      controller: _firstNameCtrl,
                      prefixIcon: Icons.person_outline,
                      enabled: !isLoading,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Last Name',
                      hint: 'Johnson',
                      controller: _lastNameCtrl,
                      enabled: !isLoading,
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
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Password ──────────────────────────────────────
              AppTextField(
                label: 'Password',
                hint: 'Min. 6 characters',
                controller: _passwordCtrl,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                enabled: !isLoading,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Role selector ─────────────────────────────────
              Text('Your Role', style: AppTypography.labelMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _roles.map((role) {
                  final isSelected = _selectedRole == role;
                  return GestureDetector(
                    onTap: isLoading ? null : () => setState(() => _selectedRole = role),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppGradients.primary : null,
                        color: isSelected ? null : AppColors.surfaceElevated,
                        borderRadius: AppRadii.borderFull,
                        border: Border.all(
                          color: isSelected ? Colors.transparent : AppColors.border,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        role,
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.huge),

              // ── Submit ────────────────────────────────────────
              PrimaryButton(
                label: 'Create Account',
                isExpanded: true,
                isLoading: isLoading,
                onPressed: isLoading ? null : _register,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Sign In',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
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
