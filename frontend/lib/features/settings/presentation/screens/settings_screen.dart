import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/logout_dialog.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_section.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Settings', style: AppTypography.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsSection(
              title: 'General',
              children: [
                SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Account',
                  subtitle: 'Email, username, password',
                  onTap: () => context.push(Routes.accountSettings),
                ),
                SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Push, email, marketing',
                  onTap: () => context.push(Routes.notificationSettings),
                ),
                SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Privacy',
                  subtitle: 'Visibility, data',
                  onTap: () => context.push(Routes.privacySettings),
                ),
                SettingsTile(
                  icon: Icons.color_lens_outlined,
                  title: 'Appearance',
                  subtitle: 'Theme, display',
                  onTap: () => context.push(Routes.appearanceSettings),
                ),
              ],
            ),
            SettingsSection(
              title: 'Support',
              children: [
                SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About CineHub',
                  onTap: () => context.push(Routes.aboutSettings),
                ),
              ],
            ),
            SettingsSection(
              title: 'Other',
              children: [
                SettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const LogoutDialog(),
                    );
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
