import '../entities/named_api_resource_entity.dart';
import '../entities/page_result_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetNamedApiResourcesPageUseCase {
  final PokedexRepository repository;

  GetNamedApiResourcesPageUseCase(this.repository);

  Future<PageResultEntity<NamedApiResourceEntity>> call(
    String path, {
    required int offset,
    required int limit,
  }) {
    return repository.getNamedApiResourcesPage(
      path,
      offset: offset,
      limit: limit,
    );
  }
}
