import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/settings/presentation/providers/settings_providers.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_loading_skeleton.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_section.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_switch_tile.dart';


class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Privacy', style: AppTypography.headlineSmall),
      ),
      body: settingsState.when(
        data: (settings) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SettingsSection(
                  title: 'Account Privacy',
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Private Account',
                      subtitle: 'Only approved followers can see your profile and projects',
                      value: settings.profileVisibility == 'private',
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(profileVisibility: val ? 'private' : 'public'),
                        );
                      },
                    ),
                    SettingsSwitchTile(
                      icon: Icons.search_rounded,
                      title: 'Discoverability',
                      subtitle: 'Show my profile in search results',
                      value: settings.discoverability,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(discoverability: val),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Contact Information',
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.email_outlined,
                      title: 'Show Email',
                      subtitle: 'Allow others to see my email address',
                      value: settings.showEmail,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(showEmail: val),
                        );
                      },
                    ),
                    SettingsSwitchTile(
                      icon: Icons.phone_outlined,
                      title: 'Show Phone',
                      subtitle: 'Allow others to see my phone number',
                      value: settings.showPhone,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(showPhone: val),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const SettingsLoadingSkeleton(),
        error: (error, _) => Center(child: Text(error.toString())), // ErrorStateWidget
      ),
    );
  }
}
