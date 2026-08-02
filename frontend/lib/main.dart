import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/di/providers.dart';

/// CineHub entry point.
///
/// Async initialization order:
///   1. [WidgetsFlutterBinding.ensureInitialized] — required for platform channels
///   2. [SharedPreferences.getInstance]           — before LocalStorage is usable
///   3. [ProviderScope] with overrides            — makes prefs available to all providers
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const CineHubApp(),
    ),
  );
}

