class MemoryCardModel {
  final String journalId;
  final DateTime date;
  final String? location;
  final List<String> locationTypes;
  final List<String> tags;
  final String description;
  final List<String> imagePaths;

  MemoryCardModel({
    required this.journalId,
    required this.date,
    this.location,
    List<String>? locationTypes,
    required this.tags,
    required this.description,
    List<String>? imagePaths,
  }) : locationTypes = locationTypes ?? const [],
       imagePaths = imagePaths ?? const [];
}
