import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/settings/presentation/providers/settings_providers.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_loading_skeleton.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_section.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_switch_tile.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Notifications', style: AppTypography.headlineSmall),
      ),
      body: settingsState.when(
        data: (settings) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SettingsSection(
                  title: 'Delivery',
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.phone_android_rounded,
                      title: 'Push Notifications',
                      subtitle: 'Receive push notifications on this device',
                      value: settings.pushNotifications,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(pushNotifications: val),
                        );
                      },
                    ),
                    SettingsSwitchTile(
                      icon: Icons.email_outlined,
                      title: 'Email Notifications',
                      subtitle: 'Receive daily digests and important updates via email',
                      value: settings.emailNotifications,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(emailNotifications: val),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Activity',
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.alternate_email_rounded,
                      title: 'Mentions',
                      subtitle: 'When someone mentions you in a comment',
                      value: settings.mentionNotifications,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(mentionNotifications: val),
                        );
                      },
                    ),
                    SettingsSwitchTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Messages',
                      subtitle: 'When you receive a direct message',
                      value: settings.messageNotifications,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(messageNotifications: val),
                        );
                      },
                    ),
                    SettingsSwitchTile(
                      icon: Icons.group_add_outlined,
                      title: 'Project Invites',
                      subtitle: 'When you are invited to join a project team',
                      value: settings.projectInviteNotifications,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(projectInviteNotifications: val),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Updates',
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.campaign_outlined,
                      title: 'Marketing & Offers',
                      subtitle: 'Receive personalized offers and news',
                      value: settings.marketingNotifications,
                      onChanged: (val) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(marketingNotifications: val),
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
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
