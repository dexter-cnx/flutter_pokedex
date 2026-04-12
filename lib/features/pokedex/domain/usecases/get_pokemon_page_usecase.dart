import '../entities/page_result_entity.dart';
import '../entities/pokemon_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetPokemonPageUseCase {
  final PokedexRepository repository;

  GetPokemonPageUseCase(this.repository);

  Future<PageResultEntity<PokemonEntity>> call({
    required int offset,
    required int limit,
  }) {
    return repository.getPokemonsPage(offset: offset, limit: limit);
  }
}
