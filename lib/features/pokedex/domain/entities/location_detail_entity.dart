class LocationDetailEntity {
  final String name;
  final String region;
  final String englishName;
  final int? gameIndex;
  final List<String> areaNames;

  const LocationDetailEntity({
    required this.name,
    required this.region,
    required this.englishName,
    required this.gameIndex,
    required this.areaNames,
  });
}
