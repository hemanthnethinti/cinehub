import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/projects/data/datasources/project_remote_datasource.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/features/projects/domain/repositories/project_repository.dart';
import 'package:dio/dio.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl(this._remote);
  final ProjectRemoteDataSource _remote;

  @override
  Future<Result<ProjectPage>> getProjects({
    String? search,
    String? type,
    String? status,
    String? genre,
    required int page,
    required int limit,
  }) async {
    try {
      final dto = await _remote.getProjects(
        search: search,
        type: type,
        status: status,
        genre: genre,
        page: page,
        limit: limit,
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      if (e.error is AppError) return Result.failure(e.error as AppError);
      return Result.failure(AppError.server(
        message: e.message ?? 'Server error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Project>> getProjectById(String id) async {
    try {
      final dto = await _remote.getProjectById(id);
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      if (e.error is AppError) return Result.failure(e.error as AppError);
      return Result.failure(AppError.server(
        message: e.message ?? 'Server error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Project>> createProject(Map<String, dynamic> data) async {
    try {
      final dto = await _remote.createProject(data);
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      if (e.error is AppError) return Result.failure(e.error as AppError);
      return Result.failure(AppError.server(
        message: e.message ?? 'Server error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Project>> updateProject(String id, Map<String, dynamic> data) async {
    try {
      final dto = await _remote.updateProject(id, data);
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      if (e.error is AppError) return Result.failure(e.error as AppError);
      return Result.failure(AppError.server(
        message: e.message ?? 'Server error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteProject(String id) async {
    try {
      await _remote.deleteProject(id);
      return Result.success(null);
    } on DioException catch (e) {
      if (e.error is AppError) return Result.failure(e.error as AppError);
      return Result.failure(AppError.server(
        message: e.message ?? 'Server error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
