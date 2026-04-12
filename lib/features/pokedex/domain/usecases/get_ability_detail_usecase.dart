import '../entities/ability_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetAbilityDetailUseCase {
  final PokedexRepository repository;

  GetAbilityDetailUseCase(this.repository);

  Future<AbilityDetailEntity> call(String name) {
    return repository.getAbilityDetail(name);
  }
}
