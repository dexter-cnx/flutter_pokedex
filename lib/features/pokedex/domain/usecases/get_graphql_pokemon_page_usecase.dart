import '../entities/page_result_entity.dart';
import '../entities/pokemon_entity.dart';
import '../../data/datasources/graphql_pokemon_remote_data_source.dart';

class GetGraphqlPokemonPageUseCase {
  final GraphqlPokemonRemoteDataSource remoteDataSource;

  GetGraphqlPokemonPageUseCase(this.remoteDataSource);

  Future<PageResultEntity<PokemonEntity>> call({
    required int offset,
    required int limit,
  }) {
    return remoteDataSource.getPokemonsPage(offset: offset, limit: limit);
  }
}
