import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/page_result_entity.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../models/pokemon_model.dart';

abstract class GraphqlPokemonRemoteDataSource {
  Future<PageResultEntity<PokemonEntity>> getPokemonsPage({
    required int offset,
    required int limit,
  });
}

class GraphqlPokemonRemoteDataSourceImpl
    implements GraphqlPokemonRemoteDataSource {
  static const int _reportedPokemonCount = 1423;

  final Dio dio;

  GraphqlPokemonRemoteDataSourceImpl(this.dio);

  Future<Map<String, dynamic>> _postGraphqlQuery(
    String query, {
    Map<String, dynamic>? variables,
  }) async {
    try {
      final response = await dio.post(
        '/',
        data: {
          'query': query,
          if (variables != null) 'variables': variables,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load GraphQL Pokémon');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PageResultEntity<PokemonEntity>> getPokemonsPage({
    required int offset,
    required int limit,
  }) async {
    final data = await _postGraphqlQuery(
      r'''
      query GetAllPokemon($offset: Int!, $take: Int!) {
        getAllPokemon(offset: $offset, take: $take) {
          num
          species
          sprite
        }
      }
      ''',
      variables: {'offset': offset, 'take': limit},
    );

    final results = ((data['data'] as Map<String, dynamic>)['getAllPokemon']
            as List<dynamic>? ??
        const [])
        .cast<Map<String, dynamic>>();

    final items = results
        .map(
          (pokemon) => PokemonModel.fromRaw(
            id: (pokemon['num'] as num).toInt(),
            name: pokemon['species'] as String,
            spriteUrl: (pokemon['sprite'] as String?)?.isNotEmpty == true
                ? pokemon['sprite'] as String
                : '',
          ),
        )
        .toList(growable: false);

    return PageResultEntity<PokemonEntity>(
      items: items,
      count: _reportedPokemonCount,
      offset: offset,
      limit: limit,
    );
  }
}
