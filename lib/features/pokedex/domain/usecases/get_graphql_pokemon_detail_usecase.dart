import '../../data/datasources/graphql_pokemon_remote_data_source.dart';
import '../entities/graphql_pokemon_detail_entity.dart';

class GetGraphqlPokemonDetailUseCase {
  final GraphqlPokemonRemoteDataSource remoteDataSource;

  GetGraphqlPokemonDetailUseCase(this.remoteDataSource);

  Future<GraphqlPokemonDetailEntity> call(int id) {
    return remoteDataSource.getPokemonDetail(id);
  }
}
