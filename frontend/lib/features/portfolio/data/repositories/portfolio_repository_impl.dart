import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/portfolio/data/datasources/portfolio_remote_datasource.dart';
import 'package:cinehubapp/features/portfolio/data/models/portfolio_dto.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';
import 'package:cinehubapp/features/portfolio/domain/repositories/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  const PortfolioRepositoryImpl(this._remote);
  final PortfolioRemoteDataSource _remote;

  @override
  Future<Result<List<PortfolioItemEntity>>> getFeatured({int page = 1, int limit = 20}) async {
    try {
      final res = await _remote.getFeatured(page: page, limit: limit);
      final items = _mapList(res);
      return Result.success(items);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<PortfolioItemEntity>>> getTrending({int limit = 20}) async {
    try {
      final res = await _remote.getTrending(limit: limit);
      final items = _mapList(res);
      return Result.success(items);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<PortfolioItemEntity>>> getByOwner(String ownerId, {int page = 1, int limit = 20}) async {
    try {
      final res = await _remote.getByOwner(ownerId, page: page, limit: limit);
      final items = _mapList(res);
      return Result.success(items);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<PortfolioItemEntity>>> getMyPortfolio({int page = 1, int limit = 20}) async {
    try {
      final res = await _remote.getMyPortfolio(page: page, limit: limit);
      final items = _mapList(res);
      return Result.success(items);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<PortfolioItemEntity>> getById(String id) async {
    try {
      final res = await _remote.getById(id);
      final entity = PortfolioDto.fromJson(res).toDomain();
      return Result.success(entity);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<PortfolioItemEntity>> create(Map<String, dynamic> data) async {
    try {
      final res = await _remote.create(data);
      final entity = PortfolioDto.fromJson(res).toDomain();
      return Result.success(entity);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<PortfolioItemEntity>> update(String id, Map<String, dynamic> data) async {
    try {
      final res = await _remote.update(id, data);
      final entity = PortfolioDto.fromJson(res).toDomain();
      return Result.success(entity);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _remote.delete(id);
      return Result.success(null);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<int>> toggleLike(String id) async {
    try {
      final res = await _remote.toggleLike(id);
      return Result.success(res['likeCount'] as int? ?? 0);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  List<PortfolioItemEntity> _mapList(Map<String, dynamic> res) {
    final data = res['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => PortfolioDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }
}
