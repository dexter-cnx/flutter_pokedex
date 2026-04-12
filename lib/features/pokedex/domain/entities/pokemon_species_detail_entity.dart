class PokemonSpeciesDetailEntity {
  final String name;
  final int captureRate;
  final int baseHappiness;
  final String color;
  final String? habitat;
  final String generation;
  final String? evolvesFromSpecies;
  final String evolutionChainUrl;
  final List<String> eggGroups;
  final String flavorText;

  const PokemonSpeciesDetailEntity({
    required this.name,
    required this.captureRate,
    required this.baseHappiness,
    required this.color,
    required this.habitat,
    required this.generation,
    required this.evolvesFromSpecies,
    required this.evolutionChainUrl,
    required this.eggGroups,
    required this.flavorText,
  });
}
