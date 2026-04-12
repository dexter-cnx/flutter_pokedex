import '../../domain/entities/item_entity.dart';

class ItemModel extends ItemEntity {
  const ItemModel({
    required super.name,
    required super.spriteUrl,
  });

  factory ItemModel.fromRaw({
    required String name,
    required String spriteUrl,
  }) {
    return ItemModel(
      name: name,
      spriteUrl: spriteUrl,
    );
  }
}
