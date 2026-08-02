import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_decorations.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';

/// Entry screen shown while checking for a stored session.
///
/// Flow:
///   1. Renders the logo with a fade-in animation.
///   2. Calls [AuthNotifier.checkSession] once.
///   3. Listens to [authNotifierProvider]:
///      - [AuthAuthenticated] → pushes to [Routes.home]
///      - [AuthUnauthenticated] → pushes to [Routes.login]
///      - [AuthLoading] → stays on splash
///
/// The check happens only once — the [_hasChecked] flag prevents
/// double-navigation from rebuilds.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeOut));
    _scaleAnim = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeOutCubic)),
    );

    _controller.forward();

    // Delay session check to let the animation start.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        ref.read(authNotifierProvider.notifier).checkSession();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen — navigate as soon as auth state resolves.
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (!mounted || _hasChecked) return;
      if (next is AuthAuthenticated) {
        _hasChecked = true;
        context.go(Routes.home);
      } else if (next is AuthUnauthenticated) {
        _hasChecked = true;
        context.go(Routes.login);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Logo gradient text ─────────────────────────
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppGradients.primary.createShader(bounds),
                  child: Text(
                    'CineHub',
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Where stories begin',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 56),
                // ── Loading indicator ──────────────────────────
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary.withValues(alpha: 0.6),
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
