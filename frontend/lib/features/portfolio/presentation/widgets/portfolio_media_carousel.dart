import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';
import 'package:cinehubapp/shared/widgets/media/app_cached_image.dart';

class PortfolioMediaCarousel extends StatelessWidget {
  const PortfolioMediaCarousel({
    super.key,
    required this.media,
  });

  final List<PortfolioMediaEntity> media;

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) {
      return Container(
        color: AppColors.surfaceElevated,
        child: const Center(child: Icon(Icons.image_not_supported_rounded, size: 48, color: AppColors.textTertiary)),
      );
    }
    
    return PageView.builder(
      itemCount: media.length,
      itemBuilder: (context, index) {
        final item = media[index];
        return Center(
          child: AppCachedImage(
            imageUrl: item.url,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
