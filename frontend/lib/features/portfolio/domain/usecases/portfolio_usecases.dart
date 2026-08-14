import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';
import 'package:cinehubapp/features/portfolio/domain/repositories/portfolio_repository.dart';

class GetPortfolioUseCase {
  const GetPortfolioUseCase(this._repository);
  final PortfolioRepository _repository;

  Future<Result<List<PortfolioItemEntity>>> getFeatured({int page = 1, int limit = 20}) {
    return _repository.getFeatured(page: page, limit: limit);
  }

  Future<Result<List<PortfolioItemEntity>>> getTrending({int limit = 20}) {
    return _repository.getTrending(limit: limit);
  }

  Future<Result<List<PortfolioItemEntity>>> getByOwner(String ownerId, {int page = 1, int limit = 20}) {
    return _repository.getByOwner(ownerId, page: page, limit: limit);
  }

  Future<Result<List<PortfolioItemEntity>>> getMyPortfolio({int page = 1, int limit = 20}) {
    return _repository.getMyPortfolio(page: page, limit: limit);
  }
}

class GetPortfolioItemUseCase {
  const GetPortfolioItemUseCase(this._repository);
  final PortfolioRepository _repository;

  Future<Result<PortfolioItemEntity>> call(String id) => _repository.getById(id);
}

class CreatePortfolioItemUseCase {
  const CreatePortfolioItemUseCase(this._repository);
  final PortfolioRepository _repository;

  Future<Result<PortfolioItemEntity>> call(Map<String, dynamic> data) => _repository.create(data);
}

class UpdatePortfolioItemUseCase {
  const UpdatePortfolioItemUseCase(this._repository);
  final PortfolioRepository _repository;

  Future<Result<PortfolioItemEntity>> call(String id, Map<String, dynamic> data) => _repository.update(id, data);
}

class DeletePortfolioItemUseCase {
  const DeletePortfolioItemUseCase(this._repository);
  final PortfolioRepository _repository;

  Future<Result<void>> call(String id) => _repository.delete(id);
}
