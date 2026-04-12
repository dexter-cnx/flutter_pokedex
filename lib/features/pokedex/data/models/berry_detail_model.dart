import '../../domain/entities/berry_detail_entity.dart';

class BerryDetailModel extends BerryDetailEntity {
  const BerryDetailModel({
    required super.name,
    required super.size,
    required super.smoothness,
    required super.growthTime,
    required super.maxHarvest,
    required super.firmness,
    required super.itemName,
    required super.flavors,
  });

  factory BerryDetailModel.fromRaw({
    required String name,
    required int size,
    required int smoothness,
    required int growthTime,
    required int maxHarvest,
    required String firmness,
    required String itemName,
    required List<BerryFlavorEntity> flavors,
  }) {
    return BerryDetailModel(
      name: name,
      size: size,
      smoothness: smoothness,
      growthTime: growthTime,
      maxHarvest: maxHarvest,
      firmness: firmness,
      itemName: itemName,
      flavors: flavors,
    );
  }
}
