import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';

class AiResultCard extends StatefulWidget {
  const AiResultCard({
    super.key,
    required this.resultText,
    required this.onShare,
  });

  final String resultText;
  final VoidCallback onShare;

  @override
  State<AiResultCard> createState() => _AiResultCardState();
}

class _AiResultCardState extends State<AiResultCard> {
  bool _copied = false;

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.resultText));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Generated Output', style: AppTypography.bodyLarge),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _copied 
                          ? const Icon(Icons.check, color: Colors.green, key: ValueKey('check'))
                          : const Icon(Icons.copy, color: AppColors.textSecondary, key: ValueKey('copy')),
                    ),
                    onPressed: _copyToClipboard,
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: AppColors.textSecondary),
                    onPressed: widget.onShare,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(widget.resultText, style: AppTypography.bodyLarge),
        ],
      ),
    );
  }
}
