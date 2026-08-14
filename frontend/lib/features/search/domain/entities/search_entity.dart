import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';

class SearchResultEntity {
  const SearchResultEntity({
    this.users = const [],
    this.projects = const [],
    this.portfolios = const [],
  });

  final List<Profile> users;
  final List<Project> projects;
  final List<PortfolioItemEntity> portfolios;

  bool get isEmpty => users.isEmpty && projects.isEmpty && portfolios.isEmpty;
}
