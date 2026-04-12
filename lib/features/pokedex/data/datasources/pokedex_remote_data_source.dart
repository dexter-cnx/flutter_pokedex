import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/berry_detail_entity.dart';
import '../../domain/entities/location_area_detail_entity.dart';
import '../../domain/entities/page_result_entity.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/entities/named_api_resource_entity.dart';
import '../models/ability_detail_model.dart';
import '../models/berry_detail_model.dart';
import '../models/evolution_chain_model.dart';
import '../models/item_detail_model.dart';
import '../models/item_model.dart';
import '../models/location_area_detail_model.dart';
import '../models/location_detail_model.dart';
import '../models/named_api_resource_model.dart';
import '../models/move_detail_model.dart';
import '../models/pokemon_detail_model.dart';
import '../models/pokemon_model.dart';
import '../models/pokemon_species_detail_model.dart';
import '../models/type_detail_model.dart';

abstract class PokedexRemoteDataSource {
  Future<List<PokemonModel>> getPokemons();
  Future<List<ItemModel>> getItems();
  Future<List<NamedApiResourceModel>> getNamedApiResources(String path);
  Future<PageResultEntity<PokemonEntity>> getPokemonsPage({
    required int offset,
    required int limit,
  });
  Future<PageResultEntity<ItemEntity>> getItemsPage({
    required int offset,
    required int limit,
  });
  Future<PageResultEntity<NamedApiResourceEntity>> getNamedApiResourcesPage(
    String path, {
    required int offset,
    required int limit,
  });
  Future<PokemonDetailModel> getPokemonDetail(int id);
  Future<ItemDetailModel> getItemDetail(String name);
  Future<AbilityDetailModel> getAbilityDetail(String name);
  Future<MoveDetailModel> getMoveDetail(String name);
  Future<BerryDetailModel> getBerryDetail(String name);
  Future<LocationDetailModel> getLocationDetail(String name);
  Future<TypeDetailModel> getTypeDetail(String name);
  Future<PokemonSpeciesDetailModel> getPokemonSpeciesDetail(String name);
  Future<EvolutionChainModel> getEvolutionChain(int id);
  Future<LocationAreaDetailModel> getLocationAreaDetail(String name);
}

class PokedexRemoteDataSourceImpl implements PokedexRemoteDataSource {
  final Dio dio;

  PokedexRemoteDataSourceImpl(this.dio);

  int _extractIdFromUrl(String url) {
    final parts =
        url.split('/').where((element) => element.isNotEmpty).toList();
    return int.parse(parts.last);
  }

  String _resourceNameFromUrl(String url, {String prefix = 'resource'}) {
    final id = _extractIdFromUrl(url);
    return '$prefix-$id';
  }

  String _extractString(Map<String, dynamic> json, List<String> path,
      {String fallback = ''}) {
    dynamic current = json;
    for (final key in path) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return fallback;
      }
    }
    return current is String && current.isNotEmpty ? current : fallback;
  }

  List<String> _extractStringList(
    List<dynamic>? values,
    List<String> path, {
    String fallback = '',
  }) {
    if (values == null || values.isEmpty) return const [];
    return values
        .cast<Map<String, dynamic>>()
        .map((entry) => _extractString(entry, path, fallback: fallback))
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
  }

  String _extractEnglishEffect(List<dynamic>? effectEntries,
      {String fallback = ''}) {
    if (effectEntries == null || effectEntries.isEmpty) return fallback;
    for (final entry in effectEntries.cast<Map<String, dynamic>>()) {
      final language = entry['language'] as Map<String, dynamic>?;
      if (language?['name'] == 'en') {
        final effect = (entry['short_effect'] as String?) ??
            (entry['effect'] as String?) ??
            '';
        if (effect.isNotEmpty) {
          return effect;
        }
      }
    }
    return fallback;
  }

  PageResultEntity<T> _buildPageResult<T>({
    required List<T> items,
    required int count,
    required int offset,
    required int limit,
  }) {
    return PageResultEntity<T>(
      items: items,
      count: count,
      offset: offset,
      limit: limit,
    );
  }

  String _extractEnglishFlavorText(List<dynamic>? flavorEntries,
      {String fallback = ''}) {
    if (flavorEntries == null || flavorEntries.isEmpty) return fallback;
    for (final entry in flavorEntries.cast<Map<String, dynamic>>()) {
      final language = entry['language'] as Map<String, dynamic>?;
      if (language?['name'] == 'en') {
        final text = (entry['flavor_text'] as String?) ?? '';
        if (text.isNotEmpty) {
          return text.replaceAll('\f', ' ');
        }
      }
    }
    return fallback;
  }

  String _extractEvolutionTrigger(Map<String, dynamic> detail) {
    final parts = <String>[];
    final trigger = _extractString(detail, ['trigger', 'name']);
    if (trigger.isNotEmpty) {
      parts.add(trigger.replaceAll('-', ' '));
    }
    final minLevel = detail['min_level'] as int?;
    if (minLevel != null) {
      parts.add('level $minLevel');
    }
    final item = _extractString(detail, ['item', 'name']);
    if (item.isNotEmpty) {
      parts.add('item $item');
    }
    final gender = detail['gender'] as int?;
    if (gender != null) {
      parts.add(gender == 1 ? 'female' : 'male');
    }
    final knownMove = _extractString(detail, ['known_move', 'name']);
    if (knownMove.isNotEmpty) {
      parts.add('knows $knownMove');
    }
    final heldItem = _extractString(detail, ['held_item', 'name']);
    if (heldItem.isNotEmpty) {
      parts.add('holding $heldItem');
    }
    return parts.isEmpty ? 'conditions not specified' : parts.join(', ');
  }

  EvolutionChainNodeModel _parseEvolutionNode(Map<String, dynamic> json) {
    final evolvesTo = (json['evolves_to'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_parseEvolutionNode)
        .toList(growable: false);
    final details = (json['evolution_details'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_extractEvolutionTrigger)
        .toList(growable: false);

    return EvolutionChainNodeModel.fromRaw(
      species: _extractString(json, ['species', 'name'], fallback: 'unknown'),
      triggers: details,
      evolvesTo: evolvesTo,
    );
  }

  @override
  Future<List<PokemonModel>> getPokemons() async {
    try {
      final response =
          await dio.get('/pokemon', queryParameters: {'limit': 100000});
      final results = (response.data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      return results.map((pokemon) {
        final id = _extractIdFromUrl(pokemon['url'] as String);
        return PokemonModel.fromRaw(
          id: id,
          name: pokemon['name'] as String,
          spriteUrl: '${ApiConstants.pokemonSpriteBaseUrl}/$id.png',
        );
      }).toList(growable: false);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load Pokémon');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PageResultEntity<PokemonEntity>> getPokemonsPage({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        '/pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );
      final data = response.data as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final items = results.map((pokemon) {
        final id = _extractIdFromUrl(pokemon['url'] as String);
        return PokemonModel.fromRaw(
          id: id,
          name: pokemon['name'] as String,
          spriteUrl: '${ApiConstants.pokemonSpriteBaseUrl}/$id.png',
        );
      }).toList(growable: false);

      return _buildPageResult<PokemonEntity>(
        items: items,
        count: (data['count'] as int?) ?? items.length,
        offset: offset,
        limit: limit,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load Pokémon');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ItemModel>> getItems() async {
    try {
      final response =
          await dio.get('/item', queryParameters: {'limit': 100000});
      final results = (response.data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      return results.map((item) {
        final name = item['name'] as String;
        return ItemModel.fromRaw(
          name: name,
          spriteUrl: '${ApiConstants.itemSpriteBaseUrl}/$name.png',
        );
      }).toList(growable: false);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load items');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PageResultEntity<ItemEntity>> getItemsPage({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        '/item',
        queryParameters: {'offset': offset, 'limit': limit},
      );
      final data = response.data as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final items = results.map((item) {
        final name = item['name'] as String;
        return ItemModel.fromRaw(
          name: name,
          spriteUrl: '${ApiConstants.itemSpriteBaseUrl}/$name.png',
        );
      }).toList(growable: false);

      return _buildPageResult<ItemEntity>(
        items: items,
        count: (data['count'] as int?) ?? items.length,
        offset: offset,
        limit: limit,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load items');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<NamedApiResourceModel>> getNamedApiResources(String path) async {
    try {
      final response = await dio.get(path, queryParameters: {'limit': 100000});
      final results = (response.data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final syntheticPrefix =
          path.contains('evolution-chain') ? 'chain' : 'resource';

      return results
          .map(
            (resource) => NamedApiResourceModel.fromRaw(
              name: (resource['name'] as String?)?.isNotEmpty == true
                  ? resource['name'] as String
                  : _resourceNameFromUrl(
                      resource['url'] as String,
                      prefix: syntheticPrefix,
                    ),
              url: resource['url'] as String,
            ),
          )
          .toList(growable: false);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load resources');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PageResultEntity<NamedApiResourceEntity>> getNamedApiResourcesPage(
    String path, {
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: {'offset': offset, 'limit': limit},
      );
      final data = response.data as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final syntheticPrefix =
          path.contains('evolution-chain') ? 'chain' : 'resource';

      final items = results
          .map(
            (resource) => NamedApiResourceModel.fromRaw(
              name: (resource['name'] as String?)?.isNotEmpty == true
                  ? resource['name'] as String
                  : _resourceNameFromUrl(
                      resource['url'] as String,
                      prefix: syntheticPrefix,
                    ),
              url: resource['url'] as String,
            ),
          )
          .toList(growable: false);

      return _buildPageResult<NamedApiResourceEntity>(
        items: items,
        count: (data['count'] as int?) ?? items.length,
        offset: offset,
        limit: limit,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load resources');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PokemonDetailModel> getPokemonDetail(int id) async {
    try {
      final response = await dio.get('/pokemon/$id');
      final data = response.data as Map<String, dynamic>;
      final sprites = data['sprites'] as Map<String, dynamic>;
      final other = (sprites['other'] as Map<String, dynamic>?) ?? {};
      final officialArtwork =
          (other['official-artwork'] as Map<String, dynamic>?) ?? {};
      final spriteUrl = (officialArtwork['front_default'] as String?) ??
          (sprites['front_default'] as String?) ??
          '${ApiConstants.pokemonSpriteBaseUrl}/$id.png';
      final species = data['species'] as Map<String, dynamic>;
      final types = (data['types'] as List<dynamic>).map((typeSlot) {
        final type =
            (typeSlot as Map<String, dynamic>)['type'] as Map<String, dynamic>;
        return type['name'] as String;
      }).toList(growable: false);
      final abilities = (data['abilities'] as List<dynamic>).map((abilitySlot) {
        final ability = (abilitySlot as Map<String, dynamic>)['ability']
            as Map<String, dynamic>;
        return ability['name'] as String;
      }).toList(growable: false);

      return PokemonDetailModel.fromRaw(
        id: data['id'] as int,
        name: data['name'] as String,
        spriteUrl: spriteUrl,
        speciesName: species['name'] as String,
        speciesUrl: species['url'] as String,
        height: data['height'] as int,
        weight: data['weight'] as int,
        baseExperience: (data['base_experience'] as int?) ?? 0,
        types: types,
        abilities: abilities,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load Pokémon detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ItemDetailModel> getItemDetail(String name) async {
    try {
      final response = await dio.get('/item/$name');
      final data = response.data as Map<String, dynamic>;
      final sprites = data['sprites'] as Map<String, dynamic>;
      final englishEffect =
          _extractEnglishEffect(data['effect_entries'] as List<dynamic>?);

      return ItemDetailModel.fromRaw(
        name: data['name'] as String,
        spriteUrl: (sprites['default'] as String?) ??
            '${ApiConstants.itemSpriteBaseUrl}/$name.png',
        cost: (data['cost'] as int?) ?? 0,
        category:
            _extractString(data, ['category', 'name'], fallback: 'Unknown'),
        effect: englishEffect.isNotEmpty
            ? englishEffect
            : 'No description available.',
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load item detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AbilityDetailModel> getAbilityDetail(String name) async {
    try {
      final response = await dio.get('/ability/$name');
      final data = response.data as Map<String, dynamic>;
      final effect = _extractEnglishEffect(
        data['effect_entries'] as List<dynamic>?,
        fallback: 'No effect description available.',
      );

      return AbilityDetailModel.fromRaw(
        name: data['name'] as String,
        generation:
            _extractString(data, ['generation', 'name'], fallback: 'unknown'),
        isMainSeries: (data['is_main_series'] as bool?) ?? false,
        effect: effect,
        pokemonCount: (data['pokemon'] as List<dynamic>? ?? []).length,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load ability detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MoveDetailModel> getMoveDetail(String name) async {
    try {
      final response = await dio.get('/move/$name');
      final data = response.data as Map<String, dynamic>;
      final effect = _extractEnglishEffect(
        data['effect_entries'] as List<dynamic>?,
        fallback: 'No effect description available.',
      );

      return MoveDetailModel.fromRaw(
        name: data['name'] as String,
        type: _extractString(data, ['type', 'name'], fallback: 'unknown'),
        damageClass:
            _extractString(data, ['damage_class', 'name'], fallback: 'unknown'),
        target: _extractString(data, ['target', 'name'], fallback: 'unknown'),
        power: data['power'] as int?,
        accuracy: data['accuracy'] as int?,
        pp: (data['pp'] as int?) ?? 0,
        priority: (data['priority'] as int?) ?? 0,
        effect: effect,
        learnedByPokemonCount:
            (data['learned_by_pokemon'] as List<dynamic>? ?? []).length,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load move detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BerryDetailModel> getBerryDetail(String name) async {
    try {
      final response = await dio.get('/berry/$name');
      final data = response.data as Map<String, dynamic>;
      final flavors = (data['flavors'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(
            (entry) => BerryFlavorEntity(
              name: _extractString(entry, ['flavor', 'name'],
                  fallback: 'unknown'),
              potency: (entry['potency'] as int?) ?? 0,
            ),
          )
          .toList(growable: false);

      return BerryDetailModel.fromRaw(
        name: data['name'] as String,
        size: (data['size'] as int?) ?? 0,
        smoothness: (data['smoothness'] as int?) ?? 0,
        growthTime: (data['growth_time'] as int?) ?? 0,
        maxHarvest: (data['max_harvest'] as int?) ?? 0,
        firmness:
            _extractString(data, ['firmness', 'name'], fallback: 'unknown'),
        itemName: _extractString(data, ['item', 'name'], fallback: 'unknown'),
        flavors: flavors,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load berry detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LocationDetailModel> getLocationDetail(String name) async {
    try {
      final response = await dio.get('/location/$name');
      final data = response.data as Map<String, dynamic>;
      final names =
          (data['names'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
      final englishName = names
          .where((entry) {
            final language = entry['language'] as Map<String, dynamic>?;
            return language?['name'] == 'en';
          })
          .map((entry) => entry['name'] as String? ?? '')
          .where((value) => value.isNotEmpty)
          .cast<String?>()
          .firstWhere((value) => value != null, orElse: () => null);
      final areas = (data['areas'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map((entry) => entry['name'] as String)
          .toList(growable: false);

      return LocationDetailModel.fromRaw(
        name: data['name'] as String,
        region: _extractString(data, ['region', 'name'], fallback: 'unknown'),
        englishName:
            englishName ?? _extractString(data, ['name'], fallback: 'unknown'),
        gameIndex: data['game_index'] as int?,
        areaNames: areas,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load location detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TypeDetailModel> getTypeDetail(String name) async {
    try {
      final response = await dio.get('/type/$name');
      final data = response.data as Map<String, dynamic>;
      final damageRelations = data['damage_relations'] as Map<String, dynamic>;
      final generation =
          _extractString(data, ['generation', 'name'], fallback: 'unknown');
      final damageClass = _extractString(data, ['move_damage_class', 'name'],
          fallback: 'unknown');

      return TypeDetailModel.fromRaw(
        name: data['name'] as String,
        damageClass: damageClass,
        generation: generation,
        doubleDamageFrom: _extractStringList(
          damageRelations['double_damage_from'] as List<dynamic>?,
          ['name'],
        ),
        doubleDamageTo: _extractStringList(
          damageRelations['double_damage_to'] as List<dynamic>?,
          ['name'],
        ),
        halfDamageFrom: _extractStringList(
          damageRelations['half_damage_from'] as List<dynamic>?,
          ['name'],
        ),
        halfDamageTo: _extractStringList(
          damageRelations['half_damage_to'] as List<dynamic>?,
          ['name'],
        ),
        noDamageFrom: _extractStringList(
          damageRelations['no_damage_from'] as List<dynamic>?,
          ['name'],
        ),
        noDamageTo: _extractStringList(
          damageRelations['no_damage_to'] as List<dynamic>?,
          ['name'],
        ),
        pokemonCount: (data['pokemon'] as List<dynamic>? ?? []).length,
        moveCount: (data['moves'] as List<dynamic>? ?? []).length,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load type detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PokemonSpeciesDetailModel> getPokemonSpeciesDetail(String name) async {
    try {
      final response = await dio.get('/pokemon-species/$name');
      final data = response.data as Map<String, dynamic>;

      return PokemonSpeciesDetailModel.fromRaw(
        name: data['name'] as String,
        captureRate: (data['capture_rate'] as int?) ?? 0,
        baseHappiness: (data['base_happiness'] as int?) ?? 0,
        color: _extractString(data, ['color', 'name'], fallback: 'unknown'),
        habitat: data['habitat'] == null
            ? null
            : _extractString(data, ['habitat', 'name'], fallback: 'unknown'),
        generation:
            _extractString(data, ['generation', 'name'], fallback: 'unknown'),
        evolvesFromSpecies: data['evolves_from_species'] == null
            ? null
            : _extractString(data, ['evolves_from_species', 'name'],
                fallback: 'unknown'),
        evolutionChainUrl: _extractString(
          data,
          ['evolution_chain', 'url'],
          fallback: '',
        ),
        eggGroups: _extractStringList(
          data['egg_groups'] as List<dynamic>?,
          ['name'],
        ),
        flavorText: _extractEnglishFlavorText(
          data['flavor_text_entries'] as List<dynamic>?,
          fallback: 'No flavor text available.',
        ),
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load species detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EvolutionChainModel> getEvolutionChain(int id) async {
    try {
      final response = await dio.get('/evolution-chain/$id');
      final data = response.data as Map<String, dynamic>;
      final chain = _parseEvolutionNode(data['chain'] as Map<String, dynamic>);

      return EvolutionChainModel.fromRaw(
        id: data['id'] as int,
        babyTriggerItem: data['baby_trigger_item'] == null
            ? null
            : _extractString(data, ['baby_trigger_item', 'name'],
                fallback: 'unknown'),
        chain: chain,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load evolution chain');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LocationAreaDetailModel> getLocationAreaDetail(String name) async {
    try {
      final response = await dio.get('/location-area/$name');
      final data = response.data as Map<String, dynamic>;
      final encounterMethods =
          (data['encounter_method_rates'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>()
              .map(
                (entry) => LocationAreaEncounterMethodEntity(
                  method: _extractString(entry, ['encounter_method', 'name'],
                      fallback: 'unknown'),
                  versions: _extractStringList(
                    entry['version_details'] as List<dynamic>?,
                    ['version', 'name'],
                  ),
                ),
              )
              .toList(growable: false);
      final pokemonEncounters = (data['pokemon_encounters'] as List<dynamic>? ??
              [])
          .cast<Map<String, dynamic>>()
          .map((entry) =>
              _extractString(entry, ['pokemon', 'name'], fallback: 'unknown'))
          .toList(growable: false);

      return LocationAreaDetailModel.fromRaw(
        name: data['name'] as String,
        location:
            _extractString(data, ['location', 'name'], fallback: 'unknown'),
        gameIndex: (data['game_index'] as int?) ?? 0,
        encounterMethods: encounterMethods,
        pokemonEncounters: pokemonEncounters,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load location area detail');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
