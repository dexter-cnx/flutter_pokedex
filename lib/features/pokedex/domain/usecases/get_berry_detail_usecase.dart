import '../entities/berry_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetBerryDetailUseCase {
  final PokedexRepository repository;

  GetBerryDetailUseCase(this.repository);

  Future<BerryDetailEntity> call(String name) {
    return repository.getBerryDetail(name);
  }
}
