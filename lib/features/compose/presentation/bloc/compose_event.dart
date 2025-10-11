import 'package:equatable/equatable.dart';

/// Base class for all compose events
abstract class ComposeEvent extends Equatable {
  const ComposeEvent();

  @override
  List<Object?> get props => [];
}

/// Event for text content changes
class ComposeTextChanged extends ComposeEvent {
  final String text;

  const ComposeTextChanged(this.text);

  @override
  List<Object?> get props => [text];
}

/// Event for adding photos from gallery
class ComposePhotoAddedFromGallery extends ComposeEvent {
  const ComposePhotoAddedFromGallery();
}

/// Event for adding multiple photos
class ComposePhotosAdded extends ComposeEvent {
  final List<String> photoPaths;

  const ComposePhotosAdded(this.photoPaths);

  @override
  List<Object?> get props => [photoPaths];
}

/// Event for removing a photo
class ComposePhotoRemoved extends ComposeEvent {
  final int index;

  const ComposePhotoRemoved(this.index);

  @override
  List<Object?> get props => [index];
}

/// Event for reordering photos
class ComposePhotosReordered extends ComposeEvent {
  final int oldIndex;
  final int newIndex;

  const ComposePhotosReordered(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

/// Event for adding a location
class ComposeLocationAdded extends ComposeEvent {
  final String location;

  const ComposeLocationAdded(this.location);

  @override
  List<Object?> get props => [location];
}

/// Event for removing a location
class ComposeLocationRemoved extends ComposeEvent {
  const ComposeLocationRemoved();
}

/// Event for adding a tag
class ComposeTagAdded extends ComposeEvent {
  final String tag;

  const ComposeTagAdded(this.tag);

  @override
  List<Object?> get props => [tag];
}

/// Event for removing a tag
class ComposeTagRemoved extends ComposeEvent {
  final String tag;

  const ComposeTagRemoved(this.tag);

  @override
  List<Object?> get props => [tag];
}

/// Event for posting the compose content
class ComposePostSubmitted extends ComposeEvent {
  const ComposePostSubmitted();
}
