class GraphqlPokemonDetailEntity {
  final int id;
  final String name;
  final String spriteUrl;
  final String shinySpriteUrl;
  final String backSpriteUrl;
  final double height;
  final double weight;
  final int baseStatsTotal;
  final List<String> types;
  final List<String> abilities;
  final List<String> evolutions;
  final List<String> preEvolutions;
  final String flavorText;

  const GraphqlPokemonDetailEntity({
    required this.id,
    required this.name,
    required this.spriteUrl,
    required this.shinySpriteUrl,
    required this.backSpriteUrl,
    required this.height,
    required this.weight,
    required this.baseStatsTotal,
    required this.types,
    required this.abilities,
    required this.evolutions,
    required this.preEvolutions,
    required this.flavorText,
  });
}
