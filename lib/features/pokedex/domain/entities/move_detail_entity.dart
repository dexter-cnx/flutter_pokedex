class MoveDetailEntity {
  final String name;
  final String type;
  final String damageClass;
  final String target;
  final int? power;
  final int? accuracy;
  final int pp;
  final int priority;
  final String effect;
  final int learnedByPokemonCount;

  const MoveDetailEntity({
    required this.name,
    required this.type,
    required this.damageClass,
    required this.target,
    required this.power,
    required this.accuracy,
    required this.pp,
    required this.priority,
    required this.effect,
    required this.learnedByPokemonCount,
  });
}
