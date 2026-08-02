import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root application widget.
///
/// Wires [GoRouter] (from [appRouterProvider]) into [MaterialApp.router]
/// and applies the single [AppTheme.dark] theme.
///
/// Auth redirect logic lives inside the router's redirect guard — not here.
/// This widget has no knowledge of auth state; it is purely structural.
class CineHubApp extends ConsumerWidget {
  const CineHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'CineHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
