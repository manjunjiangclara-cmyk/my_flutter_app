class MemoryCardModel {
  final String journalId;
  final DateTime date;
  final String? location;
  final List<String> tags;
  final String description;
  final List<String> imagePaths;

  MemoryCardModel({
    required this.journalId,
    required this.date,
    this.location,
    required this.tags,
    required this.description,
    List<String>? imagePaths,
  }) : imagePaths = imagePaths ?? const [];
}
