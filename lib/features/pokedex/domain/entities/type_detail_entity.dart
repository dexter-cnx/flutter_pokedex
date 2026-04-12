class TypeDetailEntity {
  final String name;
  final String damageClass;
  final String generation;
  final List<String> doubleDamageFrom;
  final List<String> doubleDamageTo;
  final List<String> halfDamageFrom;
  final List<String> halfDamageTo;
  final List<String> noDamageFrom;
  final List<String> noDamageTo;
  final int pokemonCount;
  final int moveCount;

  const TypeDetailEntity({
    required this.name,
    required this.damageClass,
    required this.generation,
    required this.doubleDamageFrom,
    required this.doubleDamageTo,
    required this.halfDamageFrom,
    required this.halfDamageTo,
    required this.noDamageFrom,
    required this.noDamageTo,
    required this.pokemonCount,
    required this.moveCount,
  });
}
