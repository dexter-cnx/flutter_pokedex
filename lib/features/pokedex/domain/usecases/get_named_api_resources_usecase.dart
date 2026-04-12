import '../entities/named_api_resource_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetNamedApiResourcesUseCase {
  final PokedexRepository repository;

  GetNamedApiResourcesUseCase(this.repository);

  Future<List<NamedApiResourceEntity>> call(String path) {
    return repository.getNamedApiResources(path);
  }
}
