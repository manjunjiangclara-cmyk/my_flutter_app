class MemoryCardModel {
  final String date;
  final String location;
  final List<String> tags;
  final String description;
  final String imageUrl;

  MemoryCardModel({
    required this.date,
    required this.location,
    required this.tags,
    required this.description,
    this.imageUrl =
        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
  });
}
