class LocationAreaDetailEntity {
  final String name;
  final String location;
  final int gameIndex;
  final List<LocationAreaEncounterMethodEntity> encounterMethods;
  final List<String> pokemonEncounters;

  const LocationAreaDetailEntity({
    required this.name,
    required this.location,
    required this.gameIndex,
    required this.encounterMethods,
    required this.pokemonEncounters,
  });
}

class LocationAreaEncounterMethodEntity {
  final String method;
  final List<String> versions;

  const LocationAreaEncounterMethodEntity({
    required this.method,
    required this.versions,
  });
}
