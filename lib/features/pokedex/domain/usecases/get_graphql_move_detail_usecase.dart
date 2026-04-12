import '../../data/datasources/graphql_pokemon_remote_data_source.dart';
import '../entities/graphql_move_detail_entity.dart';

class GetGraphqlMoveDetailUseCase {
  final GraphqlPokemonRemoteDataSource remoteDataSource;

  GetGraphqlMoveDetailUseCase(this.remoteDataSource);

  Future<GraphqlMoveDetailEntity> call(String name) {
    return remoteDataSource.getMoveDetail(name);
  }
}
