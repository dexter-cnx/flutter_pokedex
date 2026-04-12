import '../../domain/entities/pokemon_species_detail_entity.dart';

class PokemonSpeciesDetailModel extends PokemonSpeciesDetailEntity {
  const PokemonSpeciesDetailModel({
    required super.name,
    required super.captureRate,
    required super.baseHappiness,
    required super.color,
    required super.habitat,
    required super.generation,
    required super.evolvesFromSpecies,
    required super.evolutionChainUrl,
    required super.eggGroups,
    required super.flavorText,
  });

  factory PokemonSpeciesDetailModel.fromRaw({
    required String name,
    required int captureRate,
    required int baseHappiness,
    required String color,
    required String? habitat,
    required String generation,
    required String? evolvesFromSpecies,
    required String evolutionChainUrl,
    required List<String> eggGroups,
    required String flavorText,
  }) {
    return PokemonSpeciesDetailModel(
      name: name,
      captureRate: captureRate,
      baseHappiness: baseHappiness,
      color: color,
      habitat: habitat,
      generation: generation,
      evolvesFromSpecies: evolvesFromSpecies,
      evolutionChainUrl: evolutionChainUrl,
      eggGroups: eggGroups,
      flavorText: flavorText,
    );
  }
}
