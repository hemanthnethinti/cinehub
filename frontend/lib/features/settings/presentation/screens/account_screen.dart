import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/delete_account_dialog.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_section.dart';
import 'package:cinehubapp/features/settings/presentation/widgets/settings_tile.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final email = authState is AuthAuthenticated ? authState.user.email : '';
    final username = authState is AuthAuthenticated ? '@${authState.user.id.substring(0, 8)}' : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Account', style: AppTypography.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsSection(
              title: 'Profile Information',
              children: [
                SettingsTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  onTap: () => context.push(Routes.editProfile),
                ),
                SettingsTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: email,
                ),
                SettingsTile(
                  icon: Icons.alternate_email_rounded,
                  title: 'Username',
                  subtitle: username,
                ),
              ],
            ),
            SettingsSection(
              title: 'Security',
              children: [
                SettingsTile(
                  icon: Icons.password_rounded,
                  title: 'Change Password',
                  onTap: () {
                    // Navigate to change password form
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Danger Zone',
              children: [
                SettingsTile(
                  icon: Icons.delete_forever_rounded,
                  title: 'Delete Account',
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const DeleteAccountDialog(),
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
