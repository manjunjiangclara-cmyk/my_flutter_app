import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:my_flutter_app/core/error/failures.dart';
import 'package:my_flutter_app/core/utils/failure_mapper.dart';

/// Base BLoC class that provides common functionality for all BLoCs
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  /// Handles use case results and emits appropriate states
  ///
  /// [result] - The Either<Failure, T> result from a use case
  /// [onSuccess] - Callback to handle successful results
  /// [onFailure] - Optional callback to handle failures, defaults to emitting error state
  void handleUseCaseResult<T>(
    Either<Failure, T> result,
    void Function(T data) onSuccess, {
    void Function(Failure failure)? onFailure,
  }) {
    result.fold((failure) {
      if (onFailure != null) {
        onFailure(failure);
      } else {
        // Default error handling - subclasses should override this
        throw UnimplementedError('Error handling not implemented');
      }
    }, onSuccess);
  }

  /// Maps a failure to a user-friendly error message
  String mapFailureToMessage(Failure failure) {
    return FailureMapper.mapFailureToMessage(failure);
  }

  /// Maps a failure to a user-friendly error message with context
  String mapFailureToMessageWithContext(Failure failure, String context) {
    return FailureMapper.mapFailureToMessageWithContext(failure, context);
  }

  /// Maps a failure to a user-friendly error message with prefix
  String mapFailureToMessageWithPrefix(Failure failure, String prefix) {
    return FailureMapper.mapFailureToMessageWithPrefix(failure, prefix);
  }
}
