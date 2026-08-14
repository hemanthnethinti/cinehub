import 'package:cinehubapp/features/admin/domain/entities/admin_entities.dart';

// Note: Backend Admin APIs do not exist.
// These DTOs are stubbed for future implementation.

class DashboardStatsDto {
  const DashboardStatsDto({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalProjects,
  });

  final int totalUsers;
  final int activeUsers;
  final int totalProjects;

  factory DashboardStatsDto.fromJson(Map<String, dynamic> json) {
    return DashboardStatsDto(
      totalUsers: json['totalUsers'] as int? ?? 0,
      activeUsers: json['activeUsers'] as int? ?? 0,
      totalProjects: json['totalProjects'] as int? ?? 0,
    );
  }

  DashboardStatsEntity toDomain() {
    return DashboardStatsEntity(
      totalUsers: totalUsers,
      activeUsers: activeUsers,
      totalProjects: totalProjects,
      totalPortfolios: 0,
      aiGenerations: 0,
      pendingReports: 0,
      storageUsageMB: 0,
      dailyActiveUsers: [],
    );
  }
}
