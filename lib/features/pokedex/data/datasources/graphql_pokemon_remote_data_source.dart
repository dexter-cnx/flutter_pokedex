import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/graphql_pokemon_detail_entity.dart';
import '../../domain/entities/page_result_entity.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../models/graphql_pokemon_detail_model.dart';
import '../models/pokemon_model.dart';

abstract class GraphqlPokemonRemoteDataSource {
  Future<PageResultEntity<PokemonEntity>> getPokemonsPage({
    required int offset,
    required int limit,
  });
  Future<GraphqlPokemonDetailEntity> getPokemonDetail(int id);
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

  List<String> _extractPokemonTypes(Map<String, dynamic> pokemon) {
    return ((pokemon['types'] as List<dynamic>?) ?? const [])
        .map((entry) => (entry as Map<String, dynamic>)['name'] as String)
        .toList(growable: false);
  }

  List<String> _extractPokemonAbilities(Map<String, dynamic> pokemon) {
    final abilities = pokemon['abilities'] as Map<String, dynamic>? ?? {};
    final names = <String>[];
    for (final key in ['first', 'second', 'hidden', 'special']) {
      final ability = abilities[key] as Map<String, dynamic>?;
      final name = ability?['name'] as String?;
      if (name != null && name.isNotEmpty) {
        names.add(name);
      }
    }
    return names;
  }

  List<String> _extractPokemonEvolutionNames(List<dynamic>? values) {
    return (values ?? const [])
        .cast<Map<String, dynamic>>()
        .map((entry) => entry['species'] as String? ?? '')
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
  }

  String _extractFlavorText(List<dynamic>? values) {
    final entries = values ?? const [];
    if (entries.isEmpty) return 'No flavor text available.';
    final first = entries.first as Map<String, dynamic>;
    final flavor = first['flavor'] as String? ?? '';
    return flavor.isNotEmpty ? flavor : 'No flavor text available.';
  }

  @override
  Future<GraphqlPokemonDetailEntity> getPokemonDetail(int id) async {
    final data = await _postGraphqlQuery(
      r'''
      query GetPokemonByDexNumber($number: Int!) {
        getPokemonByDexNumber(number: $number) {
          num
          species
          sprite
          shinySprite
          backSprite
          height
          weight
          baseStatsTotal
          types {
            name
          }
          abilities {
            first {
              name
            }
            second {
              name
            }
            hidden {
              name
            }
            special {
              name
            }
          }
          evolutions {
            species
          }
          preevolutions {
            species
          }
          flavorTexts {
            flavor
          }
        }
      }
      ''',
      variables: {'number': id},
    );

    final pokemon = ((data['data'] as Map<String, dynamic>)
        ['getPokemonByDexNumber'] as Map<String, dynamic>?);
    if (pokemon == null) {
      throw ServerException('Pokémon not found');
    }

    return GraphqlPokemonDetailModel.fromRaw(
      id: (pokemon['num'] as num).toInt(),
      name: pokemon['species'] as String,
      spriteUrl: (pokemon['sprite'] as String?) ?? '',
      shinySpriteUrl: (pokemon['shinySprite'] as String?) ?? '',
      backSpriteUrl: (pokemon['backSprite'] as String?) ?? '',
      height: ((pokemon['height'] as num?) ?? 0).toDouble(),
      weight: ((pokemon['weight'] as num?) ?? 0).toDouble(),
      baseStatsTotal: (pokemon['baseStatsTotal'] as int?) ?? 0,
      types: _extractPokemonTypes(pokemon),
      abilities: _extractPokemonAbilities(pokemon),
      evolutions: _extractPokemonEvolutionNames(
        pokemon['evolutions'] as List<dynamic>?,
      ),
      preEvolutions: _extractPokemonEvolutionNames(
        pokemon['preevolutions'] as List<dynamic>?,
      ),
      flavorText: _extractFlavorText(
        pokemon['flavorTexts'] as List<dynamic>?,
      ),
    );
  }
}
