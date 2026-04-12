class GraphqlMoveDetailEntity {
  final String name;
  final String type;
  final String category;
  final String contestType;
  final int accuracy;
  final String basePower;
  final int pp;
  final int priority;
  final String target;
  final int? maxMovePower;
  final int? zMovePower;
  final String effect;
  final String shortEffect;
  final String isFieldMove;
  final String isGMax;
  final String isNonstandard;
  final String isZ;

  const GraphqlMoveDetailEntity({
    required this.name,
    required this.type,
    required this.category,
    required this.contestType,
    required this.accuracy,
    required this.basePower,
    required this.pp,
    required this.priority,
    required this.target,
    required this.maxMovePower,
    required this.zMovePower,
    required this.effect,
    required this.shortEffect,
    required this.isFieldMove,
    required this.isGMax,
    required this.isNonstandard,
    required this.isZ,
  });
}
