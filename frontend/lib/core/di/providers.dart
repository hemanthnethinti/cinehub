import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';

// ── Platform Services ───────────────────────────────────────────

/// Raw [FlutterSecureStorage] instance.
/// Use [secureStorageProvider] instead of accessing this directly.
final _flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  ),
  name: 'FlutterSecureStorage',
);

/// [SharedPreferences] must be initialized before the app starts.
/// Override this in [ProviderScope] after awaiting [SharedPreferences.getInstance].
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('Override sharedPreferencesProvider in ProviderScope'),
  name: 'SharedPreferences',
);

// ── Storage ─────────────────────────────────────────────────────

/// Secure token storage.
final secureStorageProvider = Provider<SecureStorage>(
  (ref) => SecureStorage(ref.watch(_flutterSecureStorageProvider)),
  name: 'SecureStorage',
);

/// Non-sensitive preference storage.
final localStorageProvider = Provider<LocalStorage>(
  (ref) => LocalStorage(ref.watch(sharedPreferencesProvider)),
  name: 'LocalStorage',
);

// ── Network ─────────────────────────────────────────────────────

/// The single [ApiClient] instance. All repositories use this.
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(storage: ref.watch(secureStorageProvider)),
  name: 'ApiClient',
);
