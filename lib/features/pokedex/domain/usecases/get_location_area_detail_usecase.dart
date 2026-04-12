import '../entities/location_area_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetLocationAreaDetailUseCase {
  final PokedexRepository repository;

  GetLocationAreaDetailUseCase(this.repository);

  Future<LocationAreaDetailEntity> call(String name) {
    return repository.getLocationAreaDetail(name);
  }
}
