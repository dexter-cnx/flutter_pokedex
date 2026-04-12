import '../entities/item_entity.dart';
import '../entities/item_detail_entity.dart';
import '../entities/named_api_resource_entity.dart';
import '../entities/ability_detail_entity.dart';
import '../entities/evolution_chain_entity.dart';
import '../entities/location_area_detail_entity.dart';
import '../entities/move_detail_entity.dart';
import '../entities/berry_detail_entity.dart';
import '../entities/location_detail_entity.dart';
import '../entities/page_result_entity.dart';
import '../entities/pokemon_species_detail_entity.dart';
import '../entities/pokemon_entity.dart';
import '../entities/pokemon_detail_entity.dart';
import '../entities/type_detail_entity.dart';

abstract class PokedexRepository {
  Future<List<PokemonEntity>> getPokemons();
  Future<List<ItemEntity>> getItems();
  Future<List<NamedApiResourceEntity>> getNamedApiResources(String path);
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
  Future<PokemonDetailEntity> getPokemonDetail(int id);
  Future<ItemDetailEntity> getItemDetail(String name);
  Future<AbilityDetailEntity> getAbilityDetail(String name);
  Future<MoveDetailEntity> getMoveDetail(String name);
  Future<BerryDetailEntity> getBerryDetail(String name);
  Future<LocationDetailEntity> getLocationDetail(String name);
  Future<TypeDetailEntity> getTypeDetail(String name);
  Future<PokemonSpeciesDetailEntity> getPokemonSpeciesDetail(String name);
  Future<EvolutionChainEntity> getEvolutionChain(int id);
  Future<LocationAreaDetailEntity> getLocationAreaDetail(String name);
}
