import '../entities/item_entity.dart';
import '../entities/page_result_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetItemPageUseCase {
  final PokedexRepository repository;

  GetItemPageUseCase(this.repository);

  Future<PageResultEntity<ItemEntity>> call({
    required int offset,
    required int limit,
  }) {
    return repository.getItemsPage(offset: offset, limit: limit);
  }
}
