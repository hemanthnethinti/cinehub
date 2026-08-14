import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/home/data/datasources/discovery_remote_datasource.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_page.dart';
import 'package:cinehubapp/features/home/domain/repositories/discovery_repository.dart';
import 'package:dio/dio.dart';

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  const DiscoveryRepositoryImpl(this._remote);
  
  final DiscoveryRemoteDataSource _remote;

  @override
  Future<Result<FeedPage>> getFeed({required int page, required int limit}) async {
    try {
      final dto = await _remote.discoverProjects(page: page, limit: limit);
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      if (e.error is AppError) return Result.failure(e.error as AppError);
      return Result.failure(AppError.server(
        message: e.message ?? 'Server error', 
        statusCode: e.response?.statusCode ?? 500
      ));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
