import '../entities/pokemon_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetPokemonDetailUseCase {
  final PokedexRepository repository;

  GetPokemonDetailUseCase(this.repository);

  Future<PokemonDetailEntity> call(int id) {
    return repository.getPokemonDetail(id);
  }
}
