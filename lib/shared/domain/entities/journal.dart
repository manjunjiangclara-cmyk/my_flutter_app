class Journal {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final bool isFavorite;
  final List<String> imageUrls;
  final String? location;

  const Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.isFavorite = false,
    this.imageUrls = const [],
    this.location,
  });

  Journal copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    bool? isFavorite,
    List<String>? imageUrls,
    String? location,
  }) {
    return Journal(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Journal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Journal(id: $id, content: $content, createdAt: $createdAt)';
  }
}
