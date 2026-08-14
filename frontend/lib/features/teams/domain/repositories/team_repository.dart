import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/teams/domain/entities/team.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

abstract interface class TeamRepository {
  Future<Result<Team>> getTeamByProject(String projectId);
  
  Future<Result<List<Profile>>> searchUsers(String query);
  
  Future<Result<Team>> inviteMember({
    required String teamId,
    required String userId,
    required String role,
  });

  Future<Result<Team>> respondToInvite({
    required String teamId,
    required bool accept,
  });

  Future<Result<Team>> removeMember({
    required String teamId,
    required String userId,
  });
}
