import '../../domain/entities/journal.dart';

class JournalModel extends Journal {
  const JournalModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
    super.tags,
    super.isFavorite,
    super.imageUrls,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      tags: List<String>.from(json['tags'] ?? []),
      isFavorite: json['is_favorite'] as bool? ?? false,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'tags': tags,
      'is_favorite': isFavorite,
      'image_urls': imageUrls,
    };
  }

  factory JournalModel.fromEntity(Journal journal) {
    return JournalModel(
      id: journal.id,
      title: journal.title,
      content: journal.content,
      createdAt: journal.createdAt,
      updatedAt: journal.updatedAt,
      tags: journal.tags,
      isFavorite: journal.isFavorite,
      imageUrls: journal.imageUrls,
    );
  }
}
