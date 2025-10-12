import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_event.dart';
import 'package:my_flutter_app/shared/presentation/widgets/image_gallery.dart';

/// Photo attachments widget for compose screen
/// Uses the shared ImageGallery component with compose-specific configuration
class PhotoAttachments extends StatelessWidget {
  final List<String> photoPaths;
  final ValueChanged<int> onRemovePhoto;

  const PhotoAttachments({
    super.key,
    required this.photoPaths,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return ImageGallery(
      imagePaths: photoPaths,
      config: ImageGalleryConfig.composeConfig,
      onRemoveImage: onRemovePhoto,
      onReorder: (oldIndex, newIndex) => context.read<ComposeBloc>().add(
        ComposePhotosReordered(oldIndex, newIndex),
      ),
    );
  }
}
