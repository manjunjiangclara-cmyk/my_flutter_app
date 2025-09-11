import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants.dart';

import 'compose_event.dart';
import 'compose_state.dart';

/// BLoC for managing compose screen state and business logic
class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  final TextEditingController textController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  final FocusNode textFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode tagFocusNode = FocusNode();

  ComposeBloc() : super(const ComposeInitial()) {
    on<ComposeTextChanged>(_onTextChanged);
    on<ComposePhotoAdded>(_onPhotoAdded);
    on<ComposePhotoRemoved>(_onPhotoRemoved);
    on<ComposeLocationAdded>(_onLocationAdded);
    on<ComposeLocationRemoved>(_onLocationRemoved);
    on<ComposeTagAdded>(_onTagAdded);
    on<ComposeTagRemoved>(_onTagRemoved);
    on<ComposePostSubmitted>(_onPostSubmitted);
    on<ComposeCleared>(_onCleared);

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

  void _onPhotoAdded(ComposePhotoAdded event, Emitter<ComposeState> emit) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      final newPhotos = List<String>.from(currentState.attachedPhotos)
        ..add('photo_${currentState.attachedPhotos.length + 1}');
      emit(currentState.copyWith(attachedPhotos: newPhotos));
    } else {
      emit(const ComposeContent(attachedPhotos: ['photo_1']));
    }
  }

  void _onPhotoRemoved(ComposePhotoRemoved event, Emitter<ComposeState> emit) {
    if (state is ComposeContent) {
      final currentState = state as ComposeContent;
      if (event.index >= 0 &&
          event.index < currentState.attachedPhotos.length) {
        final newPhotos = List<String>.from(currentState.attachedPhotos)
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
      // Simulate posting delay
      await Future.delayed(
        const Duration(seconds: AppConstants.postingDelaySeconds),
      );

      // Emit success state
      emit(const ComposePostSuccess());

      // Reset to initial state after successful post
      await Future.delayed(
        const Duration(milliseconds: AppConstants.postingSuccessDelayMs),
      );
      emit(const ComposeInitial());
    } catch (e) {
      emit(ComposePostFailure('Failed to post: $e'));
    }
  }

  void _onCleared(ComposeCleared event, Emitter<ComposeState> emit) {
    textController.clear();
    locationController.clear();
    tagController.clear();
    emit(const ComposeInitial());
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
