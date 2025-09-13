class MemoryCardModel {
  final String journalId;
  final String date;
  final String location;
  final List<String> tags;
  final String description;
  final String? imageUrl;

  MemoryCardModel({
    required this.journalId,
    required this.date,
    required this.location,
    required this.tags,
    required this.description,
    this.imageUrl,
  });
}
