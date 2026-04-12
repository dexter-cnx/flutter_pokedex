import '../../domain/entities/item_detail_entity.dart';

class ItemDetailModel extends ItemDetailEntity {
  const ItemDetailModel({
    required super.name,
    required super.spriteUrl,
    required super.cost,
    required super.category,
    required super.effect,
  });

  factory ItemDetailModel.fromRaw({
    required String name,
    required String spriteUrl,
    required int cost,
    required String category,
    required String effect,
  }) {
    return ItemDetailModel(
      name: name,
      spriteUrl: spriteUrl,
      cost: cost,
      category: category,
      effect: effect,
    );
  }
}
