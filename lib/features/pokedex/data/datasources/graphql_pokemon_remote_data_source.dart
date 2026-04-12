import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/graphql_ability_detail_entity.dart';
import '../../domain/entities/graphql_move_detail_entity.dart';
import '../../domain/entities/graphql_pokemon_detail_entity.dart';
import '../../domain/entities/page_result_entity.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../models/graphql_ability_detail_model.dart';
import '../models/graphql_move_detail_model.dart';
import '../models/graphql_pokemon_detail_model.dart';
import '../models/pokemon_model.dart';

abstract class GraphqlPokemonRemoteDataSource {
  Future<PageResultEntity<PokemonEntity>> getPokemonsPage({
    required int offset,
    required int limit,
  });
  Future<GraphqlPokemonDetailEntity> getPokemonDetail(int id);
  Future<GraphqlAbilityDetailEntity> getAbilityDetail(String name);
  Future<GraphqlMoveDetailEntity> getMoveDetail(String name);
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

  String _normalizeGraphqlKey(String name) {
    return name.replaceAll('-', '').toLowerCase();
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

    final pokemon =
        ((data['data'] as Map<String, dynamic>)['getPokemonByDexNumber']
            as Map<String, dynamic>?);
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

  @override
  Future<GraphqlAbilityDetailEntity> getAbilityDetail(String name) async {
    final data = await _postGraphqlQuery(
      r'''
      query GetAbility($ability: AbilitiesEnum!) {
        getAbility(ability: $ability) {
          name
          shortDesc
          desc
          isFieldAbility
          isNonstandard
          pokemonThatHaveThisAbility {
            name
          }
        }
      }
      ''',
      variables: {'ability': _normalizeGraphqlKey(name)},
    );

    final ability = ((data['data'] as Map<String, dynamic>)['getAbility']
        as Map<String, dynamic>?);
    if (ability == null) {
      throw ServerException('Ability not found');
    }

    return GraphqlAbilityDetailModel.fromRaw(
      name: ability['name'] as String,
      shortEffect: (ability['shortDesc'] as String?) ?? '',
      effect: (ability['desc'] as String?)?.isNotEmpty == true
          ? ability['desc'] as String
          : (ability['shortDesc'] as String?) ??
              'No effect description available.',
      isFieldAbility: (ability['isFieldAbility'] as String?) ?? '',
      isNonstandard: (ability['isNonstandard'] as String?) ?? '',
      pokemonCount:
          ((ability['pokemonThatHaveThisAbility'] as List<dynamic>? ?? [])
              .length),
    );
  }

  @override
  Future<GraphqlMoveDetailEntity> getMoveDetail(String name) async {
    final data = await _postGraphqlQuery(
      r'''
      query GetMove($move: MovesEnum!) {
        getMove(move: $move) {
          name
          type
          category
          contestType
          desc
          shortDesc
          accuracy
          basePower
          pp
          priority
          target
          maxMovePower
          zMovePower
          isFieldMove
          isGMax
          isNonstandard
          isZ
        }
      }
      ''',
      variables: {'move': _normalizeGraphqlKey(name)},
    );

    final move = ((data['data'] as Map<String, dynamic>)['getMove']
        as Map<String, dynamic>?);
    if (move == null) {
      throw ServerException('Move not found');
    }

    return GraphqlMoveDetailModel.fromRaw(
      name: move['name'] as String,
      type: move['type'] as String,
      category: move['category'] as String,
      contestType: (move['contestType'] as String?) ?? '',
      accuracy: (move['accuracy'] as int?) ?? 0,
      basePower: (move['basePower'] as String?) ?? '—',
      pp: (move['pp'] as int?) ?? 0,
      priority: (move['priority'] as int?) ?? 0,
      target: move['target'] as String,
      maxMovePower: move['maxMovePower'] as int?,
      zMovePower: move['zMovePower'] as int?,
      effect: (move['desc'] as String?)?.isNotEmpty == true
          ? move['desc'] as String
          : (move['shortDesc'] as String?) ??
              'No effect description available.',
      shortEffect: (move['shortDesc'] as String?) ?? '',
      isFieldMove: (move['isFieldMove'] as String?) ?? '',
      isGMax: (move['isGMax'] as String?) ?? '',
      isNonstandard: (move['isNonstandard'] as String?) ?? '',
      isZ: (move['isZ'] as String?) ?? '',
    );
  }
}
