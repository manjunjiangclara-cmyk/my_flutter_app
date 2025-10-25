import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/services/image_picker_service.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/file_storage_service.dart';
import 'package:my_flutter_app/core/utils/performance_monitor.dart';
import 'package:my_flutter_app/features/compose/presentation/models/location_search_models.dart';
import 'package:my_flutter_app/shared/domain/entities/journal.dart';
import 'package:my_flutter_app/shared/domain/usecases/create_journal.dart';
import 'package:my_flutter_app/shared/domain/usecases/get_journal_by_id.dart';
import 'package:my_flutter_app/shared/domain/usecases/update_journal.dart';

import 'compose_event.dart';
import 'compose_state.dart';

/// BLoC for managing compose screen state and business logic
@injectable
class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  final CreateJournal _createJournal;
  final GetJournalById _getJournalById;
  final UpdateJournal _updateJournal;
  // Lazy-loaded controllers to improve initialization performance
  TextEditingController? _textController;
  TextEditingController? _locationController;
  TextEditingController? _tagController;

  FocusNode? _textFocusNode;
  FocusNode? _locationFocusNode;
  FocusNode? _tagFocusNode;

  // Lazy-loaded services to avoid blocking UI during initialization
  ImagePickerService? _imagePickerService;
  FileStorageService? _fileStorageService;

  ComposeBloc(this._createJournal, this._getJournalById, this._updateJournal)
    : super(const ComposeInitial()) {
    PerformanceMonitor.startTiming('ComposeBloc_Initialization');

    on<ComposeInitializeForEdit>(_onInitializeForEdit);
    on<ComposeTextChanged>(_onTextChanged);
    on<ComposePhotoAddedFromGallery>(_onPhotoAddedFromGallery);
    on<ComposePhotosAdded>(_onPhotosAdded);
    on<ComposePhotoRemoved>(_onPhotoRemoved);
    on<ComposeLocationAdded>(_onLocationAdded);
    on<ComposeLocationRemoved>(_onLocationRemoved);
    on<ComposeTagAdded>(_onTagAdded);
    on<ComposeTagRemoved>(_onTagRemoved);
    on<ComposePostSubmitted>(_onPostSubmitted);
    on<ComposePhotosReordered>(_onPhotosReordered);

    PerformanceMonitor.endTiming('ComposeBloc_Initialization');
  }

  Future<void> _onInitializeForEdit(
    ComposeInitializeForEdit event,
    Emitter<ComposeState> emit,
  ) async {
    try {
      final result = await _getJournalById(
        GetJournalByIdParams(event.journalId),
      );
      await result.fold(
        (failure) async {
          // If loading fails, keep current state
        },
        (journal) async {
          final content = ComposeContent(
            text: journal.content,
            attachedPhotoPaths: journal.imagePaths,
            selectedTags: journal.tags,
            selectedLocation: journal.location == null
                ? null
                : LocationSearchResult(
                    id: journal.location!,
                    name: journal.location!,
                    address: journal.location!,
                    types: journal.locationTypes,
                  ),
            editingJournalId: journal.id,
            originalCreatedAt: journal.createdAt,
          );

          // Prefill controllers for immediate UI reflection
          textController.text = journal.content;

          emit(content);
        },
      );
    } catch (_) {
      // swallow; UI remains in initial state
    }
  }

  // Lazy getters for controllers to improve initialization performance
  TextEditingController get textController {
    _textController ??= TextEditingController();
    return _textController!;
  }

  TextEditingController get locationController {
    _locationController ??= TextEditingController();
    return _locationController!;
  }

  TextEditingController get tagController {
    _tagController ??= TextEditingController();
    return _tagController!;
  }

  FocusNode get textFocusNode {
    _textFocusNode ??= FocusNode();
    return _textFocusNode!;
  }

  FocusNode get locationFocusNode {
    _locationFocusNode ??= FocusNode();
    return _locationFocusNode!;
  }

  FocusNode get tagFocusNode {
    _tagFocusNode ??= FocusNode();
    return _tagFocusNode!;
  }

  // Lazy getters for services to avoid blocking UI during initialization
  ImagePickerService get _imagePickerServiceInstance {
    _imagePickerService ??= getIt<ImagePickerService>();
    return _imagePickerService!;
  }

  FileStorageService get _fileStorageServiceInstance {
    _fileStorageService ??= getIt<FileStorageService>();
    return _fileStorageService!;
  }

  void _onTextChanged(ComposeTextChanged event, Emitter<ComposeState> emit) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      emit(currentState.copyWith(text: event.text));
    } else {
      emit(ComposeContent(text: event.text));
    }
  }

  Future<void> _onPhotoAddedFromGallery(
    ComposePhotoAddedFromGallery event,
    Emitter<ComposeState> emit,
  ) async {
    final currentState = state is ComposeContent
        ? state as ComposeContent
        : const ComposeContent();

    // Check if we can add more photos
    if (!_imagePickerServiceInstance.canAddMorePhotos(
      currentState.attachedPhotoPaths.length,
    )) {
      return;
    }

    try {
      final files = await _imagePickerServiceInstance.pickMultipleImages(
        imageQuality: UIConstants.imageQuality,
      );

      if (files.isNotEmpty) {
        // Calculate how many photos we can actually add
        final remainingSlots = _imagePickerServiceInstance
            .getRemainingPhotoSlots(currentState.attachedPhotoPaths.length);
        final photosToAdd = files.take(remainingSlots).toList();

        if (photosToAdd.isNotEmpty) {
          // Save images to local storage and get their paths
          final savedPaths = await _fileStorageServiceInstance.saveImages(
            photosToAdd,
          );

          if (savedPaths.isNotEmpty) {
            final newPhotoPaths = List<String>.from(
              currentState.attachedPhotoPaths,
            )..addAll(savedPaths);
            emit(currentState.copyWith(attachedPhotoPaths: newPhotoPaths));
          }
        }
      }
    } catch (e) {
      // Handle error silently or show user-friendly message
    }
  }

  void _onPhotosAdded(ComposePhotosAdded event, Emitter<ComposeState> emit) {
    final currentState = state is ComposeContent
        ? state as ComposeContent
        : const ComposeContent();

    if (event.photoPaths.isEmpty) return;

    // Calculate how many photos we can actually add
    final remainingSlots = _imagePickerServiceInstance.getRemainingPhotoSlots(
      currentState.attachedPhotoPaths.length,
    );
    final photoPathsToAdd = event.photoPaths.take(remainingSlots).toList();

    if (photoPathsToAdd.isNotEmpty) {
      final newPhotoPaths = List<String>.from(currentState.attachedPhotoPaths)
        ..addAll(photoPathsToAdd);
      emit(currentState.copyWith(attachedPhotoPaths: newPhotoPaths));
    }
  }

  void _onPhotoRemoved(ComposePhotoRemoved event, Emitter<ComposeState> emit) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      if (event.index >= 0 &&
          event.index < currentState.attachedPhotoPaths.length) {
        // Delete the file from local storage
        final filePathToDelete = currentState.attachedPhotoPaths[event.index];
        _fileStorageServiceInstance.deleteFile(filePathToDelete);

        final newPhotoPaths = List<String>.from(currentState.attachedPhotoPaths)
          ..removeAt(event.index);
        emit(currentState.copyWith(attachedPhotoPaths: newPhotoPaths));
      }
    }
  }

  void _onPhotosReordered(
    ComposePhotosReordered event,
    Emitter<ComposeState> emit,
  ) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      final photos = List<String>.from(currentState.attachedPhotoPaths);
      if (event.oldIndex < 0 || event.oldIndex >= photos.length) return;
      var newIndex = event.newIndex;
      if (newIndex < 0) newIndex = 0;
      if (newIndex > photos.length) newIndex = photos.length;

      final moved = photos.removeAt(event.oldIndex);
      // Adjust newIndex when moving forward as per Flutter reorder convention
      if (event.newIndex > event.oldIndex) {
        newIndex -= 1;
      }
      photos.insert(newIndex, moved);
      emit(currentState.copyWith(attachedPhotoPaths: photos));
    }
  }

  void _onLocationAdded(
    ComposeLocationAdded event,
    Emitter<ComposeState> emit,
  ) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      emit(currentState.copyWith(selectedLocation: event.location));
    } else {
      emit(ComposeContent(selectedLocation: event.location));
    }
    locationController.clear();
  }

  void _onLocationRemoved(
    ComposeLocationRemoved event,
    Emitter<ComposeState> emit,
  ) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      emit(currentState.copyWith(removeSelectedLocation: true));
    }
  }

  void _onTagAdded(ComposeTagAdded event, Emitter<ComposeState> emit) {
    final trimmedTag = event.tag.trim();
    if (trimmedTag.isNotEmpty) {
      if (state is ComposeContent) {
        final currentState = state as ComposeContent;
        if (!currentState.selectedTags.contains(trimmedTag)) {
          final newTags = List<String>.from(currentState.selectedTags)
            ..add(trimmedTag);
          emit(currentState.copyWith(selectedTags: newTags));
          tagController.clear();
        }
      } else {
        emit(ComposeContent(selectedTags: [trimmedTag]));
        tagController.clear();
      }
    }
  }

  void _onTagRemoved(ComposeTagRemoved event, Emitter<ComposeState> emit) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      final newTags = List<String>.from(currentState.selectedTags)
        ..remove(event.tag);
      emit(currentState.copyWith(selectedTags: newTags));
    }
  }

  Future<void> _onPostSubmitted(
    ComposePostSubmitted event,
    Emitter<ComposeState> emit,
  ) async {
    if (state is! ComposeContent) return;

    final currentState = state as ComposeContent;
    if (!currentState.canPost) return;

    // Emit posting state
    emit(
      ComposePosting(
        text: currentState.text,
        attachedPhotoPaths: currentState.attachedPhotoPaths,
        selectedTags: currentState.selectedTags,
        selectedLocation: currentState.selectedLocation,
      ),
    );

    try {
      final now = DateTime.now();
      final isEditing = currentState.editingJournalId != null;

      final journal = Journal(
        id: isEditing
            ? currentState.editingJournalId!
            : now.toUtc().millisecondsSinceEpoch.toString(),
        content: currentState.text,
        createdAt: isEditing ? (currentState.originalCreatedAt ?? now) : now,
        updatedAt: now,
        tags: currentState.selectedTags,
        imagePaths: currentState.attachedPhotoPaths,
        location: currentState.selectedLocation?.name,
        locationTypes: currentState.selectedLocation?.types ?? [],
      );

      final result = isEditing
          ? await _updateJournal(UpdateJournalParams(journal))
          : await _createJournal(CreateJournalParams(journal));

      result.fold(
        (failure) {
          emit(
            ComposePostFailure('Failed to save journal: ${failure.message}'),
          );
        },
        (savedJournal) {
          // Trigger haptic feedback for successful save
          HapticFeedback.mediumImpact();

          // Emit success state
          emit(const ComposePostSuccess());

          // Reset to initial state immediately after successful post
          emit(const ComposeInitial());
        },
      );
    } catch (e) {
      emit(ComposePostFailure('Failed to post: $e'));
    }
  }

  @override
  Future<void> close() {
    _textController?.dispose();
    _locationController?.dispose();
    _tagController?.dispose();
    _textFocusNode?.dispose();
    _locationFocusNode?.dispose();
    _tagFocusNode?.dispose();
    return super.close();
  }
}
