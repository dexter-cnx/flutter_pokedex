class BerryDetailEntity {
  final String name;
  final int size;
  final int smoothness;
  final int growthTime;
  final int maxHarvest;
  final String firmness;
  final String itemName;
  final List<BerryFlavorEntity> flavors;

  const BerryDetailEntity({
    required this.name,
    required this.size,
    required this.smoothness,
    required this.growthTime,
    required this.maxHarvest,
    required this.firmness,
    required this.itemName,
    required this.flavors,
  });
}

class BerryFlavorEntity {
  final String name;
  final int potency;

  const BerryFlavorEntity({
    required this.name,
    required this.potency,
  });
}
