import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/teams/data/datasources/team_remote_datasource.dart';
import 'package:cinehubapp/features/teams/domain/entities/team.dart';
import 'package:cinehubapp/features/teams/domain/repositories/team_repository.dart';
import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

class TeamRepositoryImpl implements TeamRepository {
  const TeamRepositoryImpl(this._remote);
  final TeamRemoteDataSource _remote;

  @override
  Future<Result<Team>> getTeamByProject(String projectId) async {
    try {
      final dto = await _remote.getTeamByProject(projectId);
      return Result.success(dto.toDomain());
    } on AppError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Profile>>> searchUsers(String query) async {
    try {
      final results = await _remote.searchUsers(query);
      final profiles = results.map((json) => ProfileDto.fromJson(json).toDomain()).toList();
      return Result.success(profiles);
    } on AppError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Team>> inviteMember({
    required String teamId,
    required String userId,
    required String role,
  }) async {
    try {
      final dto = await _remote.inviteMember(teamId, userId, role);
      return Result.success(dto.toDomain());
    } on AppError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Team>> respondToInvite({
    required String teamId,
    required bool accept,
  }) async {
    try {
      final dto = await _remote.respondToInvite(teamId, accept);
      return Result.success(dto.toDomain());
    } on AppError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Team>> removeMember({
    required String teamId,
    required String userId,
  }) async {
    try {
      final dto = await _remote.removeMember(teamId, userId);
      return Result.success(dto.toDomain());
    } on AppError catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
