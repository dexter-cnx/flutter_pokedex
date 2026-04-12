class GraphqlAbilityDetailEntity {
  final String name;
  final String shortEffect;
  final String effect;
  final String isFieldAbility;
  final String isNonstandard;
  final int pokemonCount;

  const GraphqlAbilityDetailEntity({
    required this.name,
    required this.shortEffect,
    required this.effect,
    required this.isFieldAbility,
    required this.isNonstandard,
    required this.pokemonCount,
  });
}
