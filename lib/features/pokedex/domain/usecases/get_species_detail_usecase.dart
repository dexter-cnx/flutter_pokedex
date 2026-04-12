import '../entities/pokemon_species_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetSpeciesDetailUseCase {
  final PokedexRepository repository;

  GetSpeciesDetailUseCase(this.repository);

  Future<PokemonSpeciesDetailEntity> call(String name) {
    return repository.getPokemonSpeciesDetail(name);
  }
}
