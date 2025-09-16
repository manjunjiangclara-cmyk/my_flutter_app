class MemoryCardModel {
  final String journalId;
  final DateTime date;
  final String? location;
  final List<String> tags;
  final String description;
  final String? imageUrl;

  MemoryCardModel({
    required this.journalId,
    required this.date,
    this.location,
    required this.tags,
    required this.description,
    this.imageUrl,
  });
}
