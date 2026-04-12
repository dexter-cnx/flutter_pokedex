import '../../domain/entities/graphql_ability_detail_entity.dart';

class GraphqlAbilityDetailModel extends GraphqlAbilityDetailEntity {
  const GraphqlAbilityDetailModel({
    required super.name,
    required super.shortEffect,
    required super.effect,
    required super.isFieldAbility,
    required super.isNonstandard,
    required super.pokemonCount,
  });

  factory GraphqlAbilityDetailModel.fromRaw({
    required String name,
    required String shortEffect,
    required String effect,
    required String isFieldAbility,
    required String isNonstandard,
    required int pokemonCount,
  }) {
    return GraphqlAbilityDetailModel(
      name: name,
      shortEffect: shortEffect,
      effect: effect,
      isFieldAbility: isFieldAbility,
      isNonstandard: isNonstandard,
      pokemonCount: pokemonCount,
    );
  }
}
