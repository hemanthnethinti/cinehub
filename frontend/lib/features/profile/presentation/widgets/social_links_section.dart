import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/profile/domain/entities/social_links.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'package:url_launcher/url_launcher.dart';
// Note: In a real app we'd map these to SVGs or specific icon fonts.
// Using standard material icons as fallbacks for now.

/// Displays a row of icon buttons for populated social links.
class SocialLinksSection extends StatelessWidget {
  const SocialLinksSection({
    super.key,
    required this.links,
    this.title = 'Connect',
  });

  final SocialLinks links;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (links.website != null)
                AppIconButton(
                  icon: Icons.language,
                  tooltip: 'Website',
                  onPressed: () => _launch(links.website!),
                ),
              if (links.imdb != null)
                AppIconButton(
                  icon: Icons.movie_outlined,
                  tooltip: 'IMDb',
                  onPressed: () => _launch(links.imdb!),
                ),
              if (links.linkedin != null)
                AppIconButton(
                  icon: Icons.work_outline, // Placeholder for LinkedIn
                  tooltip: 'LinkedIn',
                  onPressed: () => _launch(links.linkedin!),
                ),
              if (links.instagram != null)
                AppIconButton(
                  icon: Icons.camera_alt_outlined, // Placeholder for Instagram
                  tooltip: 'Instagram',
                  onPressed: () => _launch(links.instagram!),
                ),
              if (links.youtube != null)
                AppIconButton(
                  icon: Icons.play_circle_outline, // Placeholder for YouTube
                  tooltip: 'YouTube',
                  onPressed: () => _launch(links.youtube!),
                ),
              if (links.vimeo != null)
                AppIconButton(
                  icon: Icons.ondemand_video, // Placeholder for Vimeo
                  tooltip: 'Vimeo',
                  onPressed: () => _launch(links.vimeo!),
                ),
              if (links.twitter != null)
                AppIconButton(
                  icon: Icons.chat_bubble_outline, // Placeholder for Twitter/X
                  tooltip: 'Twitter',
                  onPressed: () => _launch(links.twitter!),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
