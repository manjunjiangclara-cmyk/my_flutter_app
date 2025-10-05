import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/core/utils/file_storage_service.dart';
import 'package:my_flutter_app/core/utils/image_picker_service.dart';
import 'package:my_flutter_app/shared/domain/entities/journal.dart';
import 'package:my_flutter_app/shared/domain/usecases/create_journal.dart';

import 'compose_event.dart';
import 'compose_state.dart';

/// BLoC for managing compose screen state and business logic
@injectable
class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  final CreateJournal _createJournal;
  final ImagePickerService _imagePickerService;
  final FileStorageService _fileStorageService;
  final TextEditingController textController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  final FocusNode textFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode tagFocusNode = FocusNode();

  ComposeBloc(this._createJournal)
    : _imagePickerService = getIt<ImagePickerService>(),
      _fileStorageService = getIt<FileStorageService>(),
      super(const ComposeInitial()) {
    on<ComposeTextChanged>(_onTextChanged);
    on<ComposePhotoAddedFromGallery>(_onPhotoAddedFromGallery);
    on<ComposePhotosAdded>(_onPhotosAdded);
    on<ComposePhotoRemoved>(_onPhotoRemoved);
    on<ComposeLocationAdded>(_onLocationAdded);
    on<ComposeLocationRemoved>(_onLocationRemoved);
    on<ComposeTagAdded>(_onTagAdded);
    on<ComposeTagRemoved>(_onTagRemoved);
    on<ComposePostSubmitted>(_onPostSubmitted);

    // Initialize with empty content state
    add(const ComposeTextChanged(''));
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
    print('📸 Photo button clicked - starting photo selection...');
    
    final currentState = state is ComposeContent
        ? state as ComposeContent
        : const ComposeContent();

    print('📸 Current photo count: ${currentState.attachedPhotoPaths.length}');

    // Check if we can add more photos
    if (!_imagePickerService.canAddMorePhotos(
      currentState.attachedPhotoPaths.length,
    )) {
      print('📸 Cannot add more photos - limit reached');
      return;
    }

    try {
      print('📸 Calling image picker service...');
      final files = await _imagePickerService.pickMultipleImages(
        imageQuality: (UIConstants.imageQuality * 100).round(),
      );

      print('📸 Image picker returned ${files.length} files');

      if (files.isNotEmpty) {
        // Calculate how many photos we can actually add
        final remainingSlots = _imagePickerService.getRemainingPhotoSlots(
          currentState.attachedPhotoPaths.length,
        );
        final photosToAdd = files.take(remainingSlots).toList();

        print('📸 Can add ${photosToAdd.length} photos (${remainingSlots} slots remaining)');

        if (photosToAdd.isNotEmpty) {
          print('📸 Saving images to local storage...');
          // Save images to local storage and get their paths
          final savedPaths = await _fileStorageService.saveImages(photosToAdd);

          print('📸 Saved ${savedPaths.length} images successfully');

          if (savedPaths.isNotEmpty) {
            final newPhotoPaths = List<String>.from(
              currentState.attachedPhotoPaths,
            )..addAll(savedPaths);
            print('📸 Updated photo paths: $newPhotoPaths');
            emit(currentState.copyWith(attachedPhotoPaths: newPhotoPaths));
          }
        }
      } else {
        print('📸 No files selected or permission denied');
      }
    } catch (e) {
      print('❌ Error in photo selection: $e');
      // Handle error silently or show user-friendly message
    }
  }

  void _onPhotosAdded(ComposePhotosAdded event, Emitter<ComposeState> emit) {
    final currentState = state is ComposeContent
        ? state as ComposeContent
        : const ComposeContent();

    if (event.photoPaths.isEmpty) return;

    // Calculate how many photos we can actually add
    final remainingSlots = _imagePickerService.getRemainingPhotoSlots(
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
        _fileStorageService.deleteFile(filePathToDelete);

        final newPhotoPaths = List<String>.from(currentState.attachedPhotoPaths)
          ..removeAt(event.index);
        emit(currentState.copyWith(attachedPhotoPaths: newPhotoPaths));
      }
    }
  }

  void _onLocationAdded(
    ComposeLocationAdded event,
    Emitter<ComposeState> emit,
  ) {
    if (event.location.trim().isNotEmpty) {
      if (state is ComposeContent) {
        final currentState = state as ComposeContent;
        emit(currentState.copyWith(selectedLocation: event.location.trim()));
      } else {
        emit(ComposeContent(selectedLocation: event.location.trim()));
      }
      locationController.clear();
    }
  }

  void _onLocationRemoved(
    ComposeLocationRemoved event,
    Emitter<ComposeState> emit,
  ) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      emit(currentState.copyWith(selectedLocation: null));
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
      // Create Journal entity from compose content
      final now = DateTime.now();
      final journal = Journal(
        id: now.toUtc().millisecondsSinceEpoch.toString(),
        content: currentState.text,
        createdAt: now,
        updatedAt: now,
        tags: currentState.selectedTags,
        imagePaths: currentState.attachedPhotoPaths,
        location: currentState.selectedLocation,
      );

      // Call CreateJournal usecase - this will take as long as the actual database operation
      final result = await _createJournal(CreateJournalParams(journal));

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
    textController.dispose();
    locationController.dispose();
    tagController.dispose();
    textFocusNode.dispose();
    locationFocusNode.dispose();
    tagFocusNode.dispose();
    return super.close();
  }
}
