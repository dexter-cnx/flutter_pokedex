import '../../domain/entities/graphql_pokemon_detail_entity.dart';

class GraphqlPokemonDetailModel extends GraphqlPokemonDetailEntity {
  const GraphqlPokemonDetailModel({
    required super.id,
    required super.name,
    required super.spriteUrl,
    required super.shinySpriteUrl,
    required super.backSpriteUrl,
    required super.height,
    required super.weight,
    required super.baseStatsTotal,
    required super.types,
    required super.abilities,
    required super.evolutions,
    required super.preEvolutions,
    required super.flavorText,
  });

  factory GraphqlPokemonDetailModel.fromRaw({
    required int id,
    required String name,
    required String spriteUrl,
    required String shinySpriteUrl,
    required String backSpriteUrl,
    required double height,
    required double weight,
    required int baseStatsTotal,
    required List<String> types,
    required List<String> abilities,
    required List<String> evolutions,
    required List<String> preEvolutions,
    required String flavorText,
  }) {
    return GraphqlPokemonDetailModel(
      id: id,
      name: name,
      spriteUrl: spriteUrl,
      shinySpriteUrl: shinySpriteUrl,
      backSpriteUrl: backSpriteUrl,
      height: height,
      weight: weight,
      baseStatsTotal: baseStatsTotal,
      types: types,
      abilities: abilities,
      evolutions: evolutions,
      preEvolutions: preEvolutions,
      flavorText: flavorText,
    );
  }
}
