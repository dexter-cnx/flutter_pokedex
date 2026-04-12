import '../../domain/entities/move_detail_entity.dart';

class MoveDetailModel extends MoveDetailEntity {
  const MoveDetailModel({
    required super.name,
    required super.type,
    required super.damageClass,
    required super.target,
    required super.power,
    required super.accuracy,
    required super.pp,
    required super.priority,
    required super.effect,
    required super.learnedByPokemonCount,
  });

  factory MoveDetailModel.fromRaw({
    required String name,
    required String type,
    required String damageClass,
    required String target,
    required int? power,
    required int? accuracy,
    required int pp,
    required int priority,
    required String effect,
    required int learnedByPokemonCount,
  }) {
    return MoveDetailModel(
      name: name,
      type: type,
      damageClass: damageClass,
      target: target,
      power: power,
      accuracy: accuracy,
      pp: pp,
      priority: priority,
      effect: effect,
      learnedByPokemonCount: learnedByPokemonCount,
    );
  }
}
