import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/settings/presentation/providers/theme_mode_provider.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_section.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_tile.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Appearance', style: AppTypography.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsSection(
              title: 'Theme',
              children: [
                SettingsTile(
                  icon: Icons.phone_android_rounded,
                  title: 'System Default',
                  trailing: currentMode == ThemeMode.system
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : const SizedBox.shrink(),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).updateThemeMode(ThemeMode.system);
                  },
                ),
                SettingsTile(
                  icon: Icons.light_mode_rounded,
                  title: 'Light Mode',
                  trailing: currentMode == ThemeMode.light
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : const SizedBox.shrink(),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).updateThemeMode(ThemeMode.light);
                  },
                ),
                SettingsTile(
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  trailing: currentMode == ThemeMode.dark
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : const SizedBox.shrink(),
                  onTap: () {
                    ref.read(themeModeProvider.notifier).updateThemeMode(ThemeMode.dark);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
