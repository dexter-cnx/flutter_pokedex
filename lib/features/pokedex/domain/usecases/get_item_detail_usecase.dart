import '../entities/item_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetItemDetailUseCase {
  final PokedexRepository repository;

  GetItemDetailUseCase(this.repository);

  Future<ItemDetailEntity> call(String name) {
    return repository.getItemDetail(name);
  }
}
