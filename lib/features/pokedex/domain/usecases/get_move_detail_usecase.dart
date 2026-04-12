import '../entities/move_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetMoveDetailUseCase {
  final PokedexRepository repository;

  GetMoveDetailUseCase(this.repository);

  Future<MoveDetailEntity> call(String name) {
    return repository.getMoveDetail(name);
  }
}
