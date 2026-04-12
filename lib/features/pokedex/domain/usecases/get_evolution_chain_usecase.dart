import '../entities/evolution_chain_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetEvolutionChainUseCase {
  final PokedexRepository repository;

  GetEvolutionChainUseCase(this.repository);

  Future<EvolutionChainEntity> call(int id) {
    return repository.getEvolutionChain(id);
  }
}
