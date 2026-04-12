import '../entities/type_detail_entity.dart';
import '../repositories/pokedex_repository.dart';

class GetTypeDetailUseCase {
  final PokedexRepository repository;

  GetTypeDetailUseCase(this.repository);

  Future<TypeDetailEntity> call(String name) {
    return repository.getTypeDetail(name);
  }
}
