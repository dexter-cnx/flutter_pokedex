class AbilityDetailEntity {
  final String name;
  final String generation;
  final bool isMainSeries;
  final String effect;
  final int pokemonCount;

  const AbilityDetailEntity({
    required this.name,
    required this.generation,
    required this.isMainSeries,
    required this.effect,
    required this.pokemonCount,
  });
}
