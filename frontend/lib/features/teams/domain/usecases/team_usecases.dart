import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/teams/domain/entities/team.dart';
import 'package:cinehubapp/features/teams/domain/repositories/team_repository.dart';

class GetTeamUseCase {
  const GetTeamUseCase(this._repository);
  final TeamRepository _repository;

  Future<Result<Team>> call(String projectId) {
    return _repository.getTeamByProject(projectId);
  }
}

class InviteMemberUseCase {
  const InviteMemberUseCase(this._repository);
  final TeamRepository _repository;

  Future<Result<Team>> call({
    required String teamId,
    required String userId,
    required String role,
  }) {
    return _repository.inviteMember(teamId: teamId, userId: userId, role: role);
  }
}

class RemoveMemberUseCase {
  const RemoveMemberUseCase(this._repository);
  final TeamRepository _repository;

  Future<Result<Team>> call({
    required String teamId,
    required String userId,
  }) {
    return _repository.removeMember(teamId: teamId, userId: userId);
  }
}

class RespondToInviteUseCase {
  const RespondToInviteUseCase(this._repository);
  final TeamRepository _repository;

  Future<Result<Team>> call({
    required String teamId,
    required bool accept,
  }) {
    return _repository.respondToInvite(teamId: teamId, accept: accept);
  }
}
