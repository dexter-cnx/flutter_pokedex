import '../../domain/entities/evolution_chain_entity.dart';

class EvolutionChainModel extends EvolutionChainEntity {
  const EvolutionChainModel({
    required super.id,
    required super.babyTriggerItem,
    required super.chain,
  });

  factory EvolutionChainModel.fromRaw({
    required int id,
    required String? babyTriggerItem,
    required EvolutionChainNodeEntity chain,
  }) {
    return EvolutionChainModel(
      id: id,
      babyTriggerItem: babyTriggerItem,
      chain: chain,
    );
  }
}

class EvolutionChainNodeModel extends EvolutionChainNodeEntity {
  const EvolutionChainNodeModel({
    required super.species,
    required super.triggers,
    required super.evolvesTo,
  });

  factory EvolutionChainNodeModel.fromRaw({
    required String species,
    required List<String> triggers,
    required List<EvolutionChainNodeEntity> evolvesTo,
  }) {
    return EvolutionChainNodeModel(
      species: species,
      triggers: triggers,
      evolvesTo: evolvesTo,
    );
  }
}
