import 'package:cinehubapp/core/network/api_client.dart';
import 'package:cinehubapp/features/teams/data/models/team_dto.dart';

class TeamRemoteDataSource {
  const TeamRemoteDataSource(this._client);
  final ApiClient _client;

  static const _base = 'teams';

  Future<TeamDto> getTeamByProject(String projectId) async {
    final response = await _client.get<Map<String, dynamic>>('$_base/project/$projectId');
    final data = response.data?['data'] as Map<String, dynamic>? ?? response.data!;
    return TeamDto.fromJson(data);
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final response = await _client.get<Map<String, dynamic>>('users', queryParameters: {'search': query, 'limit': 10});
    // Backend uses ApiResponse.paginated → data is a flat array under 'data' key
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  Future<TeamDto> inviteMember(String teamId, String userId, String role) async {
    final response = await _client.post<Map<String, dynamic>>(
      '$_base/$teamId/invite',
      data: {'userId': userId, 'role': role},
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? response.data!;
    return TeamDto.fromJson(data);
  }

  Future<TeamDto> respondToInvite(String teamId, bool accept) async {
    final response = await _client.post<Map<String, dynamic>>(
      '$_base/$teamId/respond',
      data: {'accept': accept},
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? response.data!;
    return TeamDto.fromJson(data);
  }

  Future<TeamDto> removeMember(String teamId, String userId) async {
    final response = await _client.delete<Map<String, dynamic>>(
      '$_base/$teamId/members/$userId',
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? response.data!;
    return TeamDto.fromJson(data);
  }
}
