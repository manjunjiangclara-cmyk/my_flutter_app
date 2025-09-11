import 'package:equatable/equatable.dart';

/// Base class for all compose states
abstract class ComposeState extends Equatable {
  const ComposeState();

  @override
  List<Object?> get props => [];
}

/// Initial state when compose screen is first loaded
class ComposeInitial extends ComposeState {
  const ComposeInitial();
}

/// State representing the current compose content
class ComposeContent extends ComposeState {
  final String text;
  final List<String> attachedPhotos;
  final List<String> selectedTags;
  final String? selectedLocation;
  final bool isPosting;

  const ComposeContent({
    this.text = '',
    this.attachedPhotos = const [],
    this.selectedTags = const [],
    this.selectedLocation,
    this.isPosting = false,
  });

  /// Whether the compose form can be posted
  bool get canPost =>
      text.trim().isNotEmpty ||
      attachedPhotos.isNotEmpty ||
      selectedLocation != null ||
      selectedTags.isNotEmpty;

  /// Copy with method for immutable state updates
  ComposeContent copyWith({
    String? text,
    List<String>? attachedPhotos,
    List<String>? selectedTags,
    String? selectedLocation,
    bool? isPosting,
  }) {
    return ComposeContent(
      text: text ?? this.text,
      attachedPhotos: attachedPhotos ?? this.attachedPhotos,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isPosting: isPosting ?? this.isPosting,
    );
  }

  @override
  List<Object?> get props => [
    text,
    attachedPhotos,
    selectedTags,
    selectedLocation,
    isPosting,
  ];
}

/// State when posting is in progress
class ComposePosting extends ComposeState {
  final String text;
  final List<String> attachedPhotos;
  final List<String> selectedTags;
  final String? selectedLocation;

  const ComposePosting({
    required this.text,
    required this.attachedPhotos,
    required this.selectedTags,
    this.selectedLocation,
  });

  @override
  List<Object?> get props => [
    text,
    attachedPhotos,
    selectedTags,
    selectedLocation,
  ];
}

/// State when posting is successful
class ComposePostSuccess extends ComposeState {
  const ComposePostSuccess();
}

/// State when posting fails
class ComposePostFailure extends ComposeState {
  final String message;

  const ComposePostFailure(this.message);

  @override
  List<Object?> get props => [message];
}
