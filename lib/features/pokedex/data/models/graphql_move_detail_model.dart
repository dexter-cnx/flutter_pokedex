import '../../domain/entities/graphql_move_detail_entity.dart';

class GraphqlMoveDetailModel extends GraphqlMoveDetailEntity {
  const GraphqlMoveDetailModel({
    required super.name,
    required super.type,
    required super.category,
    required super.contestType,
    required super.accuracy,
    required super.basePower,
    required super.pp,
    required super.priority,
    required super.target,
    required super.maxMovePower,
    required super.zMovePower,
    required super.effect,
    required super.shortEffect,
    required super.isFieldMove,
    required super.isGMax,
    required super.isNonstandard,
    required super.isZ,
  });

  factory GraphqlMoveDetailModel.fromRaw({
    required String name,
    required String type,
    required String category,
    required String contestType,
    required int accuracy,
    required String basePower,
    required int pp,
    required int priority,
    required String target,
    required int? maxMovePower,
    required int? zMovePower,
    required String effect,
    required String shortEffect,
    required String isFieldMove,
    required String isGMax,
    required String isNonstandard,
    required String isZ,
  }) {
    return GraphqlMoveDetailModel(
      name: name,
      type: type,
      category: category,
      contestType: contestType,
      accuracy: accuracy,
      basePower: basePower,
      pp: pp,
      priority: priority,
      target: target,
      maxMovePower: maxMovePower,
      zMovePower: zMovePower,
      effect: effect,
      shortEffect: shortEffect,
      isFieldMove: isFieldMove,
      isGMax: isGMax,
      isNonstandard: isNonstandard,
      isZ: isZ,
    );
  }
}
