import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';

abstract interface class PortfolioRepository {
  Future<Result<List<PortfolioItemEntity>>> getFeatured({int page = 1, int limit = 20});
  Future<Result<List<PortfolioItemEntity>>> getTrending({int limit = 20});
  Future<Result<List<PortfolioItemEntity>>> getByOwner(String ownerId, {int page = 1, int limit = 20});
  Future<Result<List<PortfolioItemEntity>>> getMyPortfolio({int page = 1, int limit = 20});
  
  Future<Result<PortfolioItemEntity>> getById(String id);
  
  Future<Result<PortfolioItemEntity>> create(Map<String, dynamic> data);
  Future<Result<PortfolioItemEntity>> update(String id, Map<String, dynamic> data);
  Future<Result<void>> delete(String id);
  
  Future<Result<int>> toggleLike(String id);
}
