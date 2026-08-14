import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/features/notifications/presentation/providers/notification_providers.dart';
import 'package:cinehubapp/shared/widgets/chips/chips.dart';

class NotificationFilterBar extends StatelessWidget {
  const NotificationFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final NotificationFilter selectedFilter;
  final ValueChanged<NotificationFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          _buildChip('All', NotificationFilter.all),
          const SizedBox(width: AppSpacing.sm),
          _buildChip('Unread', NotificationFilter.unread),
          const SizedBox(width: AppSpacing.sm),
          _buildChip('Mentions', NotificationFilter.mentions),
          const SizedBox(width: AppSpacing.sm),
          _buildChip('Projects', NotificationFilter.projects),
          const SizedBox(width: AppSpacing.sm),
          _buildChip('Messages', NotificationFilter.messages),
          const SizedBox(width: AppSpacing.sm),
          _buildChip('Team Invites', NotificationFilter.teamInvites),
        ],
      ),
    );
  }

  Widget _buildChip(String label, NotificationFilter filter) {
    final isSelected = selectedFilter == filter;
    return RoleChip(
      label: label,
      isSelected: isSelected,
      onTap: () => onFilterSelected(filter),
    );
  }
}
