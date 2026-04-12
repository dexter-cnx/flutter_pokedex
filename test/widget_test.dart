import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/features/pokedex/domain/entities/ability_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/berry_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/evolution_chain_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/item_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/item_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/location_area_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/location_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/named_api_resource_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/page_result_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/move_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/pokemon_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/pokemon_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/pokemon_species_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/entities/type_detail_entity.dart';
import 'package:pokedex/features/pokedex/domain/repositories/pokedex_repository.dart';
import 'package:pokedex/features/pokedex/domain/usecases/get_item_page_usecase.dart';
import 'package:pokedex/features/pokedex/domain/usecases/get_named_api_resources_page_usecase.dart';
import 'package:pokedex/features/pokedex/domain/usecases/get_pokemon_page_usecase.dart';
import 'package:pokedex/features/pokedex/presentation/providers/pokedex_providers.dart';

class _FakePokedexRepository implements PokedexRepository {
  @override
  Future<PageResultEntity<ItemEntity>> getItemsPage({
    required int offset,
    required int limit,
  }) async {
    return PageResultEntity<ItemEntity>(
      items: const [],
      count: 0,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<PageResultEntity<NamedApiResourceEntity>> getNamedApiResourcesPage(
    String path, {
    required int offset,
    required int limit,
  }) async {
    return PageResultEntity<NamedApiResourceEntity>(
      items: const [],
      count: 0,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<PageResultEntity<PokemonEntity>> getPokemonsPage({
    required int offset,
    required int limit,
  }) async {
    return PageResultEntity<PokemonEntity>(
      items: const [],
      count: 0,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<List<ItemEntity>> getItems() => throw UnimplementedError();

  @override
  Future<List<NamedApiResourceEntity>> getNamedApiResources(String path) =>
      throw UnimplementedError();

  @override
  Future<List<PokemonEntity>> getPokemons() => throw UnimplementedError();

  @override
  Future<AbilityDetailEntity> getAbilityDetail(String name) async =>
      throw UnimplementedError();

  @override
  Future<BerryDetailEntity> getBerryDetail(String name) async =>
      throw UnimplementedError();

  @override
  Future<EvolutionChainEntity> getEvolutionChain(int id) async =>
      throw UnimplementedError();

  @override
  Future<ItemDetailEntity> getItemDetail(String name) async =>
      throw UnimplementedError();

  @override
  Future<LocationAreaDetailEntity> getLocationAreaDetail(String name) async =>
      throw UnimplementedError();

  @override
  Future<LocationDetailEntity> getLocationDetail(String name) async =>
      throw UnimplementedError();

  @override
  Future<MoveDetailEntity> getMoveDetail(String name) async =>
      throw UnimplementedError();

  @override
  Future<PokemonDetailEntity> getPokemonDetail(int id) async =>
      throw UnimplementedError();

  @override
  Future<PokemonSpeciesDetailEntity> getPokemonSpeciesDetail(
          String name) async =>
      throw UnimplementedError();

  @override
  Future<TypeDetailEntity> getTypeDetail(String name) async =>
      throw UnimplementedError();
}

void main() {
  testWidgets('renders app shell', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getPokemonPageUseCaseProvider.overrideWith(
            (ref) => GetPokemonPageUseCase(_FakePokedexRepository()),
          ),
          getItemPageUseCaseProvider.overrideWith(
            (ref) => GetItemPageUseCase(_FakePokedexRepository()),
          ),
          getNamedApiResourcesPageUseCaseProvider.overrideWith(
            (ref) => GetNamedApiResourcesPageUseCase(_FakePokedexRepository()),
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Pokedex'), findsWidgets);
    expect(find.text('Pokémon'), findsWidgets);
    expect(find.text('Items'), findsWidgets);
    expect(find.text('Abilities'), findsWidgets);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
