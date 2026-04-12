class EvolutionChainEntity {
  final int id;
  final String? babyTriggerItem;
  final EvolutionChainNodeEntity chain;

  const EvolutionChainEntity({
    required this.id,
    required this.babyTriggerItem,
    required this.chain,
  });
}

class EvolutionChainNodeEntity {
  final String species;
  final List<String> triggers;
  final List<EvolutionChainNodeEntity> evolvesTo;

  const EvolutionChainNodeEntity({
    required this.species,
    required this.triggers,
    required this.evolvesTo,
  });
}
