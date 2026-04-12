import '../../data/datasources/graphql_pokemon_remote_data_source.dart';
import '../entities/graphql_ability_detail_entity.dart';

class GetGraphqlAbilityDetailUseCase {
  final GraphqlPokemonRemoteDataSource remoteDataSource;

  GetGraphqlAbilityDetailUseCase(this.remoteDataSource);

  Future<GraphqlAbilityDetailEntity> call(String name) {
    return remoteDataSource.getAbilityDetail(name);
  }
}
