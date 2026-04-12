class PokemonDetailEntity {
  final int id;
  final String name;
  final String spriteUrl;
  final String speciesName;
  final String speciesUrl;
  final int height;
  final int weight;
  final int baseExperience;
  final List<String> types;
  final List<String> abilities;

  const PokemonDetailEntity({
    required this.id,
    required this.name,
    required this.spriteUrl,
    required this.speciesName,
    required this.speciesUrl,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.types,
    required this.abilities,
  });
}
