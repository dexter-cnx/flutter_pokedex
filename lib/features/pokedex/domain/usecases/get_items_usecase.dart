import '../entities/item_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetItemsUseCase {
  final PokedexRepository repository;

  GetItemsUseCase(this.repository);

  Future<List<ItemEntity>> call() {
    return repository.getItems();
  }
}
