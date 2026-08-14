import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/teams/data/datasources/team_remote_datasource.dart';
import 'package:cinehubapp/features/teams/data/repositories/team_repository_impl.dart';
import 'package:cinehubapp/features/teams/domain/entities/team.dart';
import 'package:cinehubapp/features/teams/domain/repositories/team_repository.dart';
import 'package:cinehubapp/features/teams/domain/usecases/team_usecases.dart';

// ─── Data & Domain Providers ────────────────────────────────────────────────

final teamRemoteDataSourceProvider = Provider<TeamRemoteDataSource>((ref) {
  return TeamRemoteDataSource(ref.watch(apiClientProvider));
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepositoryImpl(ref.watch(teamRemoteDataSourceProvider));
});

final getTeamUseCaseProvider = Provider<GetTeamUseCase>((ref) {
  return GetTeamUseCase(ref.watch(teamRepositoryProvider));
});

final inviteMemberUseCaseProvider = Provider<InviteMemberUseCase>((ref) {
  return InviteMemberUseCase(ref.watch(teamRepositoryProvider));
});

final removeMemberUseCaseProvider = Provider<RemoveMemberUseCase>((ref) {
  return RemoveMemberUseCase(ref.watch(teamRepositoryProvider));
});

final respondToInviteUseCaseProvider = Provider<RespondToInviteUseCase>((ref) {
  return RespondToInviteUseCase(ref.watch(teamRepositoryProvider));
});

// ─── State Providers ────────────────────────────────────────────────────────

final teamProvider = AsyncNotifierProvider.autoDispose.family<TeamNotifier, Team, String>(
  TeamNotifier.new,
);

class TeamNotifier extends AutoDisposeFamilyAsyncNotifier<Team, String> {
  @override
  Future<Team> build(String arg) async {
    final result = await ref.watch(getTeamUseCaseProvider).call(arg);
    return result.when(
      success: (team) => team,
      failure: (error) => throw Exception(error.userMessage),
    );
  }

  Future<void> inviteMember(String userId, String role) async {
    final teamId = state.valueOrNull?.id;
    if (teamId == null) return;

    final result = await ref.read(inviteMemberUseCaseProvider).call(
      teamId: teamId,
      userId: userId,
      role: role,
    );

    result.when(
      success: (team) => state = AsyncData(team),
      failure: (error) => state = AsyncError(Exception(error.userMessage), StackTrace.current),
    );
  }

  Future<void> removeMember(String userId) async {
    final teamId = state.valueOrNull?.id;
    if (teamId == null) return;

    final result = await ref.read(removeMemberUseCaseProvider).call(
      teamId: teamId,
      userId: userId,
    );

    result.when(
      success: (team) => state = AsyncData(team),
      failure: (error) => state = AsyncError(Exception(error.userMessage), StackTrace.current),
    );
  }
}
