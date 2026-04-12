import '../../domain/entities/location_detail_entity.dart';

class LocationDetailModel extends LocationDetailEntity {
  const LocationDetailModel({
    required super.name,
    required super.region,
    required super.englishName,
    required super.gameIndex,
    required super.areaNames,
  });

  factory LocationDetailModel.fromRaw({
    required String name,
    required String region,
    required String englishName,
    required int? gameIndex,
    required List<String> areaNames,
  }) {
    return LocationDetailModel(
      name: name,
      region: region,
      englishName: englishName,
      gameIndex: gameIndex,
      areaNames: areaNames,
    );
  }
}
