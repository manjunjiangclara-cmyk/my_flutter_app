import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
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
  final TextEditingController textController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  final FocusNode textFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode tagFocusNode = FocusNode();

  ComposeBloc(this._createJournal)
    : _imagePickerService = getIt<ImagePickerService>(),
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
    final currentState = state is ComposeContent
        ? state as ComposeContent
        : const ComposeContent();

    // Check if we can add more photos
    if (!_imagePickerService.canAddMorePhotos(
      currentState.attachedPhotos.length,
    )) {
      return;
    }

    try {
      final files = await _imagePickerService.pickMultipleImages(
        imageQuality: UIConstants.imageQuality,
      );

      if (files.isNotEmpty) {
        // Calculate how many photos we can actually add
        final remainingSlots = _imagePickerService.getRemainingPhotoSlots(
          currentState.attachedPhotos.length,
        );
        final photosToAdd = files.take(remainingSlots).toList();

        if (photosToAdd.isNotEmpty) {
          final newPhotos = List<File>.from(currentState.attachedPhotos)
            ..addAll(photosToAdd);
          emit(currentState.copyWith(attachedPhotos: newPhotos));
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

    if (event.photos.isEmpty) return;

    // Calculate how many photos we can actually add
    final remainingSlots = _imagePickerService.getRemainingPhotoSlots(
      currentState.attachedPhotos.length,
    );
    final photosToAdd = event.photos.take(remainingSlots).toList();

    if (photosToAdd.isNotEmpty) {
      final newPhotos = List<File>.from(currentState.attachedPhotos)
        ..addAll(photosToAdd);
      emit(currentState.copyWith(attachedPhotos: newPhotos));
    }
  }

  void _onPhotoRemoved(ComposePhotoRemoved event, Emitter<ComposeState> emit) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      if (event.index >= 0 &&
          event.index < currentState.attachedPhotos.length) {
        final newPhotos = List<File>.from(currentState.attachedPhotos)
          ..removeAt(event.index);
        emit(currentState.copyWith(attachedPhotos: newPhotos));
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
        attachedPhotos: currentState.attachedPhotos,
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
        imageUrls: currentState.attachedPhotos
            .map((file) => file.path)
            .toList(),
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
