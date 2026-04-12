import '../../domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  const PokemonModel({
    required super.id,
    required super.name,
    required super.spriteUrl,
  });

  factory PokemonModel.fromRaw({
    required int id,
    required String name,
    required String spriteUrl,
  }) {
    return PokemonModel(
      id: id,
      name: name,
      spriteUrl: spriteUrl,
    );
  }
}
