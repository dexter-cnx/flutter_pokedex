import '../entities/location_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetLocationDetailUseCase {
  final PokedexRepository repository;

  GetLocationDetailUseCase(this.repository);

  Future<LocationDetailEntity> call(String name) {
    return repository.getLocationDetail(name);
  }
}
