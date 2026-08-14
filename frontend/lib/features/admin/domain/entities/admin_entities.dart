class DashboardStatsEntity {
  const DashboardStatsEntity({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalProjects,
    required this.totalPortfolios,
    required this.aiGenerations,
    required this.pendingReports,
    required this.storageUsageMB,
    required this.dailyActiveUsers,
  });

  final int totalUsers;
  final int activeUsers;
  final int totalProjects;
  final int totalPortfolios;
  final int aiGenerations;
  final int pendingReports;
  final double storageUsageMB;
  final List<int> dailyActiveUsers;
}

class AdminUserEntity {
  const AdminUserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.lastLoginAt,
  });

  final String id;
  final String email;
  final String fullName;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
}

class AdminProjectEntity {
  const AdminProjectEntity({
    required this.id,
    required this.title,
    required this.ownerName,
    required this.status,
    required this.visibility,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String ownerName;
  final String status;
  final String visibility;
  final DateTime createdAt;
}

class ModerationItemEntity {
  const ModerationItemEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.ownerName,
    required this.status,
    required this.submittedAt,
  });

  final String id;
  final String type; // project, portfolio, media
  final String title;
  final String ownerName;
  final String status; // pending, approved, rejected
  final DateTime submittedAt;
}

class ReportEntity {
  const ReportEntity({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.targetId,
    required this.targetType,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String reporterId;
  final String reporterName;
  final String targetId;
  final String targetType; // user, project, portfolio, comment
  final String reason;
  final String status; // open, resolved, ignored
  final DateTime createdAt;
}
