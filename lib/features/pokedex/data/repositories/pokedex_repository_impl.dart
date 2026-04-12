import '../../domain/entities/evolution_chain_entity.dart';
import '../../domain/entities/ability_detail_entity.dart';
import '../../domain/entities/berry_detail_entity.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/entities/item_detail_entity.dart';
import '../../domain/entities/location_area_detail_entity.dart';
import '../../domain/entities/location_detail_entity.dart';
import '../../domain/entities/named_api_resource_entity.dart';
import '../../domain/entities/move_detail_entity.dart';
import '../../domain/entities/pokemon_species_detail_entity.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/entities/pokemon_detail_entity.dart';
import '../../domain/entities/type_detail_entity.dart';
import '../../domain/repositories/pokedex_repository.dart';
import '../datasources/pokedex_remote_data_source.dart';

class PokedexRepositoryImpl implements PokedexRepository {
  final PokedexRemoteDataSource remoteDataSource;

  PokedexRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ItemEntity>> getItems() {
    return remoteDataSource.getItems();
  }

  @override
  Future<List<NamedApiResourceEntity>> getNamedApiResources(String path) {
    return remoteDataSource.getNamedApiResources(path);
  }

  @override
  Future<List<PokemonEntity>> getPokemons() {
    return remoteDataSource.getPokemons();
  }

  @override
  Future<ItemDetailEntity> getItemDetail(String name) {
    return remoteDataSource.getItemDetail(name);
  }

  @override
  Future<AbilityDetailEntity> getAbilityDetail(String name) {
    return remoteDataSource.getAbilityDetail(name);
  }

  @override
  Future<MoveDetailEntity> getMoveDetail(String name) {
    return remoteDataSource.getMoveDetail(name);
  }

  @override
  Future<BerryDetailEntity> getBerryDetail(String name) {
    return remoteDataSource.getBerryDetail(name);
  }

  @override
  Future<LocationDetailEntity> getLocationDetail(String name) {
    return remoteDataSource.getLocationDetail(name);
  }

  @override
  Future<TypeDetailEntity> getTypeDetail(String name) {
    return remoteDataSource.getTypeDetail(name);
  }

  @override
  Future<PokemonSpeciesDetailEntity> getPokemonSpeciesDetail(String name) {
    return remoteDataSource.getPokemonSpeciesDetail(name);
  }

  @override
  Future<EvolutionChainEntity> getEvolutionChain(int id) {
    return remoteDataSource.getEvolutionChain(id);
  }

  @override
  Future<LocationAreaDetailEntity> getLocationAreaDetail(String name) {
    return remoteDataSource.getLocationAreaDetail(name);
  }

  @override
  Future<PokemonDetailEntity> getPokemonDetail(int id) {
    return remoteDataSource.getPokemonDetail(id);
  }
}
