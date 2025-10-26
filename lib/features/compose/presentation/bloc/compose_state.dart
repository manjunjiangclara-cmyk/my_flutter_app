import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';

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
  final List<String> attachedPhotoPaths;
  final List<String> selectedTags;
  final LocationSearchResult? selectedLocation;
  final bool isPosting;
  final String? editingJournalId;
  final DateTime? selectedCreatedAt;

  const ComposeContent({
    this.text = '',
    this.attachedPhotoPaths = const [],
    this.selectedTags = const [],
    this.selectedLocation,
    this.isPosting = false,
    this.editingJournalId,
    this.selectedCreatedAt,
  });

  /// Whether the compose form can be posted
  bool get canPost =>
      text.trim().isNotEmpty ||
      attachedPhotoPaths.isNotEmpty ||
      selectedLocation != null ||
      selectedTags.isNotEmpty;

  /// Copy with method for immutable state updates
  ComposeContent copyWith({
    String? text,
    List<String>? attachedPhotoPaths,
    List<String>? selectedTags,
    LocationSearchResult? selectedLocation,
    bool? isPosting,
    bool removeSelectedLocation = false,
    String? editingJournalId,
    DateTime? selectedCreatedAt,
  }) {
    return ComposeContent(
      text: text ?? this.text,
      attachedPhotoPaths: attachedPhotoPaths ?? this.attachedPhotoPaths,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedLocation: removeSelectedLocation
          ? null
          : (selectedLocation ?? this.selectedLocation),
      isPosting: isPosting ?? this.isPosting,
      editingJournalId: editingJournalId ?? this.editingJournalId,
      selectedCreatedAt: selectedCreatedAt ?? this.selectedCreatedAt,
    );
  }

  @override
  List<Object?> get props => [
    text,
    attachedPhotoPaths,
    selectedTags,
    selectedLocation,
    isPosting,
    editingJournalId,
    selectedCreatedAt,
  ];
}

/// State when posting is in progress
class ComposePosting extends ComposeState {
  final String text;
  final List<String> attachedPhotoPaths;
  final List<String> selectedTags;
  final LocationSearchResult? selectedLocation;
  final DateTime? selectedCreatedAt;

  const ComposePosting({
    required this.text,
    required this.attachedPhotoPaths,
    required this.selectedTags,
    this.selectedLocation,
    this.selectedCreatedAt,
  });

  @override
  List<Object?> get props => [
    text,
    attachedPhotoPaths,
    selectedTags,
    selectedLocation,
    selectedCreatedAt,
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
