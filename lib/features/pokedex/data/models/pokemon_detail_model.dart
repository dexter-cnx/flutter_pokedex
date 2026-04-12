import '../../domain/entities/pokemon_detail_entity.dart';

class PokemonDetailModel extends PokemonDetailEntity {
  const PokemonDetailModel({
    required super.id,
    required super.name,
    required super.spriteUrl,
    required super.speciesName,
    required super.speciesUrl,
    required super.height,
    required super.weight,
    required super.baseExperience,
    required super.types,
    required super.abilities,
  });

  factory PokemonDetailModel.fromRaw({
    required int id,
    required String name,
    required String spriteUrl,
    required String speciesName,
    required String speciesUrl,
    required int height,
    required int weight,
    required int baseExperience,
    required List<String> types,
    required List<String> abilities,
  }) {
    return PokemonDetailModel(
      id: id,
      name: name,
      spriteUrl: spriteUrl,
      speciesName: speciesName,
      speciesUrl: speciesUrl,
      height: height,
      weight: weight,
      baseExperience: baseExperience,
      types: types,
      abilities: abilities,
    );
  }
}
