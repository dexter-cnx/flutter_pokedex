import '../../domain/entities/location_area_detail_entity.dart';

class LocationAreaDetailModel extends LocationAreaDetailEntity {
  const LocationAreaDetailModel({
    required super.name,
    required super.location,
    required super.gameIndex,
    required super.encounterMethods,
    required super.pokemonEncounters,
  });

  factory LocationAreaDetailModel.fromRaw({
    required String name,
    required String location,
    required int gameIndex,
    required List<LocationAreaEncounterMethodEntity> encounterMethods,
    required List<String> pokemonEncounters,
  }) {
    return LocationAreaDetailModel(
      name: name,
      location: location,
      gameIndex: gameIndex,
      encounterMethods: encounterMethods,
      pokemonEncounters: pokemonEncounters,
    );
  }
}
