import '../../domain/entities/type_detail_entity.dart';

class TypeDetailModel extends TypeDetailEntity {
  const TypeDetailModel({
    required super.name,
    required super.damageClass,
    required super.generation,
    required super.doubleDamageFrom,
    required super.doubleDamageTo,
    required super.halfDamageFrom,
    required super.halfDamageTo,
    required super.noDamageFrom,
    required super.noDamageTo,
    required super.pokemonCount,
    required super.moveCount,
  });

  factory TypeDetailModel.fromRaw({
    required String name,
    required String damageClass,
    required String generation,
    required List<String> doubleDamageFrom,
    required List<String> doubleDamageTo,
    required List<String> halfDamageFrom,
    required List<String> halfDamageTo,
    required List<String> noDamageFrom,
    required List<String> noDamageTo,
    required int pokemonCount,
    required int moveCount,
  }) {
    return TypeDetailModel(
      name: name,
      damageClass: damageClass,
      generation: generation,
      doubleDamageFrom: doubleDamageFrom,
      doubleDamageTo: doubleDamageTo,
      halfDamageFrom: halfDamageFrom,
      halfDamageTo: halfDamageTo,
      noDamageFrom: noDamageFrom,
      noDamageTo: noDamageTo,
      pokemonCount: pokemonCount,
      moveCount: moveCount,
    );
  }
}
