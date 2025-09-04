import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/tag_chip.dart';

class JournalEditingView extends StatelessWidget {
  const JournalEditingView({super.key});
  // DATA_MODEL (static for this example, would typically be in a ChangeNotifier)
  static const String _mainImageUrl =
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';
  static const String _eventDate = 'Thursday, August 28';
  static const String _eventLocation = 'Melbourne';
  static const List<String> _tags = <String>['Life', 'Travel'];
  static const List<String> _contentParagraphs = <String>[
    'Praeterea, ex culpa non invenies unum aut non accusatis unum. Et nihil inuitam. Nemo nocere tibi erit, et non inimicos, et ne illa laederentur.',
    'Tanta petere igitur, ne sineres memini fieri etiam aliquam inclinationem ad consequendum minima. Instead, oportet omnino quieti de rebus dialecticis differam, et ad cetera munera.',
    'Quodsi haberent magnalia inter potentiam et divitias, et non illam quidem haec eo spectant haec quoque vos omnino desit illud quo solo felicitatis libertatique perficiuntur.',
    'Opus igitur est dicere possit dura omni specie, "Tu autem in specie, non videtur, nec omnino res est." Et examine ab eis praecepta eius quae',
  ];
  static const List<String> _galleryImageUrls = <String>[
    _mainImageUrl, // Using the same placeholder for all images
    _mainImageUrl,
    _mainImageUrl,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: const Icon(Icons.close),
            actions: const <Widget>[
              Icon(Icons.share),
              SizedBox(width: 16),
              Icon(Icons.edit),
              SizedBox(width: 16),
            ],
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _HeaderImage(),
                  const SizedBox(height: 16),
                  const _EventDetailsHeader(
                    date: _eventDate,
                    location: _eventLocation,
                  ),
                  const SizedBox(height: 8),
                  TagChips(tags: _tags),
                  const SizedBox(height: 16),
                  const _ContentSection(paragraphs: _contentParagraphs),
                  const SizedBox(height: 16),
                  // ImageGallery(imageUrls: _galleryImageUrls),
                  // ImageGallery(imageUrls: _galleryImageUrls),
                  // ImageGallery(
                  //   imageUrls: images,
                  //   canAddPhotos: true,
                  //   onAddPhotos: () { /* 打开相册 */ },
                  //   onImageTap: (index) { print("Tapped $index"); },
                  //   onImageDelete: (index) {
                  //     setState(() { images.removeAt(index); });
                  //   },
                  //   onReorder: (oldIndex, newIndex) {
                  //     setState(() {
                  //       final image = images.removeAt(oldIndex);
                  //       images.insert(newIndex, image);
                  //     });
                  //   },
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget to display a section of content with multiple paragraphs.
class _ContentSection extends StatelessWidget {
  final List<String> paragraphs;

  const _ContentSection({required this.paragraphs, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < paragraphs.length; i++) ...<Widget>[
          Text(paragraphs[i]),
          if (i < paragraphs.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

/// A widget to display the main header image.
class _HeaderImage extends StatelessWidget {
  const _HeaderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey[300],
      child: Image.network(
        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              );
            },
      ),
    );
  }
}

/// A widget to display event details like date and location.
class _EventDetailsHeader extends StatelessWidget {
  final String date;
  final String location;

  const _EventDetailsHeader({
    required this.date,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: <Widget>[
            const Icon(Icons.location_on, size: 16),
            const SizedBox(width: 4),
            Text(location),
          ],
        ),
      ],
    );
  }
}
