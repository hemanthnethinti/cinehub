import 'package:cinehubapp/core/network/api_client.dart';
import 'package:cinehubapp/features/projects/data/models/project_dto.dart';

class ProjectRemoteDataSource {
  const ProjectRemoteDataSource(this._client);
  final ApiClient _client;

  static const _base = 'projects';

  Future<ProjectPageDto> getProjects({
    String? search,
    String? type,
    String? status,
    String? genre,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (type != null && type.isNotEmpty) query['type'] = type;
    if (status != null && status.isNotEmpty) query['status'] = status;
    if (genre != null && genre.isNotEmpty) query['genre'] = genre;

    final response = await _client.get<Map<String, dynamic>>(
      _base,
      queryParameters: query,
    );
    return ProjectPageDto.fromJson(response.data!);
  }

  Future<ProjectDto> getProjectById(String id) async {
    final response = await _client.get<Map<String, dynamic>>('$_base/$id');
    final data = response.data?['data'] as Map<String, dynamic>? ?? response.data!;
    return ProjectDto.fromJson(data);
  }

  Future<ProjectDto> createProject(Map<String, dynamic> body) async {
    final response = await _client.post<Map<String, dynamic>>(_base, data: body);
    final data = response.data?['data'] as Map<String, dynamic>? ?? response.data!;
    return ProjectDto.fromJson(data);
  }

  Future<ProjectDto> updateProject(String id, Map<String, dynamic> body) async {
    final response = await _client.patch<Map<String, dynamic>>('$_base/$id', data: body);
    final data = response.data?['data'] as Map<String, dynamic>? ?? response.data!;
    return ProjectDto.fromJson(data);
  }

  Future<void> deleteProject(String id) async {
    await _client.delete<dynamic>('$_base/$id');
  }
}
