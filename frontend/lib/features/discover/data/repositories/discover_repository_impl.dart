import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/discover/data/datasources/discover_remote_datasource.dart';
import 'package:cinehubapp/features/discover/domain/entities/trending_content.dart';
import 'package:cinehubapp/features/discover/domain/repositories/discover_repository.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_page.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile_page.dart';
import 'package:dio/dio.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  const DiscoverRepositoryImpl(this._remote);
  final DiscoverRemoteDataSource _remote;

  @override
  Future<Result<TrendingContent>> getTrendingContent() async {
    try {
      final dto = await _remote.getTrendingContent();
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
  Future<Result<FeedPage>> searchProjects({
    required String query,
    required int page,
    required int limit,
  }) async {
    try {
      final dto = await _remote.searchProjects(query: query, page: page, limit: limit);
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
  Future<Result<ProfilePage>> searchCreators({
    required String query,
    required int page,
    required int limit,
  }) async {
    try {
      final dto = await _remote.searchCreators(query: query, page: page, limit: limit);
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
}
