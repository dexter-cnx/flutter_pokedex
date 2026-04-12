import '../entities/pokemon_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetPokemonsUseCase {
  final PokedexRepository repository;

  GetPokemonsUseCase(this.repository);

  Future<List<PokemonEntity>> call() {
    return repository.getPokemons();
  }
}
