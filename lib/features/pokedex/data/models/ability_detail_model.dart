import '../../domain/entities/ability_detail_entity.dart';

class AbilityDetailModel extends AbilityDetailEntity {
  const AbilityDetailModel({
    required super.name,
    required super.generation,
    required super.isMainSeries,
    required super.effect,
    required super.pokemonCount,
  });

  factory AbilityDetailModel.fromRaw({
    required String name,
    required String generation,
    required bool isMainSeries,
    required String effect,
    required int pokemonCount,
  }) {
    return AbilityDetailModel(
      name: name,
      generation: generation,
      isMainSeries: isMainSeries,
      effect: effect,
      pokemonCount: pokemonCount,
    );
  }
}
