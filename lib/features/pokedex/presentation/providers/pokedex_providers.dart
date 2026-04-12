import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../../core/dio/dio_provider.dart';
import '../../data/datasources/pokedex_remote_data_source.dart';
import '../../data/datasources/graphql_pokemon_remote_data_source.dart';
import '../../data/repositories/pokedex_repository_impl.dart';
import '../../domain/entities/ability_detail_entity.dart';
import '../../domain/entities/berry_detail_entity.dart';
import '../../domain/entities/evolution_chain_entity.dart';
import '../../domain/entities/graphql_pokemon_detail_entity.dart';
import '../../domain/entities/item_detail_entity.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/entities/location_area_detail_entity.dart';
import '../../domain/entities/location_detail_entity.dart';
import '../../domain/entities/named_api_resource_entity.dart';
import '../../domain/entities/move_detail_entity.dart';
import '../../domain/entities/pokemon_detail_entity.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/entities/pokemon_species_detail_entity.dart';
import '../../domain/entities/type_detail_entity.dart';
import '../../domain/usecases/get_ability_detail_usecase.dart';
import '../../domain/usecases/get_berry_detail_usecase.dart';
import '../../domain/usecases/get_evolution_chain_usecase.dart';
import '../../domain/usecases/get_graphql_pokemon_detail_usecase.dart';
import '../../domain/usecases/get_graphql_pokemon_page_usecase.dart';
import '../../domain/usecases/get_item_detail_usecase.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../../domain/usecases/get_location_area_detail_usecase.dart';
import '../../domain/usecases/get_location_detail_usecase.dart';
import '../../domain/usecases/get_move_detail_usecase.dart';
import '../../domain/usecases/get_named_api_resources_usecase.dart';
import '../../domain/usecases/get_named_api_resources_page_usecase.dart';
import '../../domain/usecases/get_item_page_usecase.dart';
import '../../domain/usecases/get_pokemon_page_usecase.dart';
import '../../domain/usecases/get_pokemon_detail_usecase.dart';
import '../../domain/usecases/get_pokemons_usecase.dart';
import '../../domain/usecases/get_species_detail_usecase.dart';
import '../../domain/usecases/get_type_detail_usecase.dart';

enum PokedexTab {
  pokemon,
  items,
  abilities,
  moves,
  berries,
  types,
  species,
  evolutionChains,
  locations,
  locationAreas,
}

enum BrowseMode { pagination, lazyLoading, infiniteScroll }

enum ApiSource { pokeApi, graphqlPokemon }

final browseModeProvider = StateProvider<BrowseMode>(
  (ref) => BrowseMode.pagination,
);

final apiSourceProvider = StateProvider<ApiSource>(
  (ref) => ApiSource.pokeApi,
);

final pokedexRemoteDataSourceProvider =
    Provider<PokedexRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PokedexRemoteDataSourceImpl(dio);
});

final graphqlPokemonDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://graphqlpokemon.favware.tech/v8',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );
});

final graphqlPokemonRemoteDataSourceProvider =
    Provider<GraphqlPokemonRemoteDataSource>((ref) {
  final dio = ref.watch(graphqlPokemonDioProvider);
  return GraphqlPokemonRemoteDataSourceImpl(dio);
});

final pokedexRepositoryProvider = Provider<PokedexRepositoryImpl>((ref) {
  final remote = ref.watch(pokedexRemoteDataSourceProvider);
  return PokedexRepositoryImpl(remote);
});

final getPokemonsUseCaseProvider = Provider<GetPokemonsUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetPokemonsUseCase(repository);
});

final getItemsUseCaseProvider = Provider<GetItemsUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetItemsUseCase(repository);
});

final getPokemonDetailUseCaseProvider =
    Provider<GetPokemonDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetPokemonDetailUseCase(repository);
});

final getItemDetailUseCaseProvider = Provider<GetItemDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetItemDetailUseCase(repository);
});

final getAbilityDetailUseCaseProvider =
    Provider<GetAbilityDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetAbilityDetailUseCase(repository);
});

final getMoveDetailUseCaseProvider = Provider<GetMoveDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetMoveDetailUseCase(repository);
});

final getBerryDetailUseCaseProvider = Provider<GetBerryDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetBerryDetailUseCase(repository);
});

final getLocationDetailUseCaseProvider =
    Provider<GetLocationDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetLocationDetailUseCase(repository);
});

final getTypeDetailUseCaseProvider = Provider<GetTypeDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetTypeDetailUseCase(repository);
});

final getSpeciesDetailUseCaseProvider =
    Provider<GetSpeciesDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetSpeciesDetailUseCase(repository);
});

final getEvolutionChainUseCaseProvider =
    Provider<GetEvolutionChainUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetEvolutionChainUseCase(repository);
});

final getLocationAreaDetailUseCaseProvider =
    Provider<GetLocationAreaDetailUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetLocationAreaDetailUseCase(repository);
});

final getNamedApiResourcesUseCaseProvider =
    Provider<GetNamedApiResourcesUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetNamedApiResourcesUseCase(repository);
});

final getPokemonPageUseCaseProvider =
    Provider<GetPokemonPageUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetPokemonPageUseCase(repository);
});

final getGraphqlPokemonPageUseCaseProvider =
    Provider<GetGraphqlPokemonPageUseCase>((ref) {
  final remote = ref.watch(graphqlPokemonRemoteDataSourceProvider);
  return GetGraphqlPokemonPageUseCase(remote);
});

final getGraphqlPokemonDetailUseCaseProvider =
    Provider<GetGraphqlPokemonDetailUseCase>((ref) {
  final remote = ref.watch(graphqlPokemonRemoteDataSourceProvider);
  return GetGraphqlPokemonDetailUseCase(remote);
});

final graphqlPokemonDetailProvider =
    FutureProvider.family<GraphqlPokemonDetailEntity, int>((ref, id) async {
  final useCase = ref.watch(getGraphqlPokemonDetailUseCaseProvider);
  return useCase(id);
});

final getItemPageUseCaseProvider = Provider<GetItemPageUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetItemPageUseCase(repository);
});

final getNamedApiResourcesPageUseCaseProvider =
    Provider<GetNamedApiResourcesPageUseCase>((ref) {
  final repository = ref.watch(pokedexRepositoryProvider);
  return GetNamedApiResourcesPageUseCase(repository);
});

final pokemonsProvider = FutureProvider<List<PokemonEntity>>((ref) async {
  final useCase = ref.watch(getPokemonsUseCaseProvider);
  return useCase();
});

final itemsProvider = FutureProvider<List<ItemEntity>>((ref) async {
  final useCase = ref.watch(getItemsUseCaseProvider);
  return useCase();
});

final pokemonDetailProvider =
    FutureProvider.family<PokemonDetailEntity, int>((ref, id) async {
  final useCase = ref.watch(getPokemonDetailUseCaseProvider);
  return useCase(id);
});

final itemDetailProvider =
    FutureProvider.family<ItemDetailEntity, String>((ref, name) async {
  final useCase = ref.watch(getItemDetailUseCaseProvider);
  return useCase(name);
});

final abilityDetailProvider =
    FutureProvider.family<AbilityDetailEntity, String>((ref, name) async {
  final useCase = ref.watch(getAbilityDetailUseCaseProvider);
  return useCase(name);
});

final moveDetailProvider =
    FutureProvider.family<MoveDetailEntity, String>((ref, name) async {
  final useCase = ref.watch(getMoveDetailUseCaseProvider);
  return useCase(name);
});

final berryDetailProvider =
    FutureProvider.family<BerryDetailEntity, String>((ref, name) async {
  final useCase = ref.watch(getBerryDetailUseCaseProvider);
  return useCase(name);
});

final locationDetailProvider =
    FutureProvider.family<LocationDetailEntity, String>((ref, name) async {
  final useCase = ref.watch(getLocationDetailUseCaseProvider);
  return useCase(name);
});

final typeDetailProvider =
    FutureProvider.family<TypeDetailEntity, String>((ref, name) async {
  final useCase = ref.watch(getTypeDetailUseCaseProvider);
  return useCase(name);
});

final speciesDetailProvider =
    FutureProvider.family<PokemonSpeciesDetailEntity, String>(
        (ref, name) async {
  final useCase = ref.watch(getSpeciesDetailUseCaseProvider);
  return useCase(name);
});

final evolutionChainProvider =
    FutureProvider.family<EvolutionChainEntity, int>((ref, id) async {
  final useCase = ref.watch(getEvolutionChainUseCaseProvider);
  return useCase(id);
});

final locationAreaDetailProvider =
    FutureProvider.family<LocationAreaDetailEntity, String>((ref, name) async {
  final useCase = ref.watch(getLocationAreaDetailUseCaseProvider);
  return useCase(name);
});

final abilitiesProvider =
    FutureProvider<List<NamedApiResourceEntity>>((ref) async {
  final useCase = ref.watch(getNamedApiResourcesUseCaseProvider);
  return useCase('/ability');
});

final movesProvider = FutureProvider<List<NamedApiResourceEntity>>((ref) async {
  final useCase = ref.watch(getNamedApiResourcesUseCaseProvider);
  return useCase('/move');
});

final berriesProvider =
    FutureProvider<List<NamedApiResourceEntity>>((ref) async {
  final useCase = ref.watch(getNamedApiResourcesUseCaseProvider);
  return useCase('/berry');
});

final typesProvider = FutureProvider<List<NamedApiResourceEntity>>((ref) async {
  final useCase = ref.watch(getNamedApiResourcesUseCaseProvider);
  return useCase('/type');
});

final speciesProvider =
    FutureProvider<List<NamedApiResourceEntity>>((ref) async {
  final useCase = ref.watch(getNamedApiResourcesUseCaseProvider);
  return useCase('/pokemon-species');
});

final evolutionChainsProvider =
    FutureProvider<List<NamedApiResourceEntity>>((ref) async {
  final useCase = ref.watch(getNamedApiResourcesUseCaseProvider);
  return useCase('/evolution-chain');
});

final locationsProvider =
    FutureProvider<List<NamedApiResourceEntity>>((ref) async {
  final useCase = ref.watch(getNamedApiResourcesUseCaseProvider);
  return useCase('/location');
});

final locationAreasProvider =
    FutureProvider<List<NamedApiResourceEntity>>((ref) async {
  final useCase = ref.watch(getNamedApiResourcesUseCaseProvider);
  return useCase('/location-area');
});
