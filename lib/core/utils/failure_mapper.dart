import '../error/failures.dart';

/// Utility class for mapping failures to user-friendly error messages
class FailureMapper {
  FailureMapper._();

  /// Maps failure types to user-friendly error messages
  static String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again later.';
      case CacheFailure:
        return 'Local data error occurred. Please refresh the page.';
      case NetworkFailure:
        return 'Network error occurred. Please check your connection.';
      case ValidationFailure:
        return 'Invalid data provided. Please check your input.';
      case UnauthorizedFailure:
        return 'Authentication required. Please log in again.';
      case NotFoundFailure:
        return 'Requested resource not found.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Maps failure types to user-friendly error messages with custom context
  static String mapFailureToMessageWithContext(
    Failure failure,
    String context,
  ) {
    final baseMessage = mapFailureToMessage(failure);
    return '$context: $baseMessage';
  }

  /// Maps failure types to user-friendly error messages with custom prefix
  static String mapFailureToMessageWithPrefix(Failure failure, String prefix) {
    final baseMessage = mapFailureToMessage(failure);
    return '$prefix $baseMessage';
  }
}
