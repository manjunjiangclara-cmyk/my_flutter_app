import 'dart:developer' as developer;

/// Simple performance monitoring utility
class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};
  static final Map<String, List<Duration>> _measurements = {};

  /// Start timing an operation
  static void startTiming(String operation) {
    _startTimes[operation] = DateTime.now();
    developer.log('⏱️ Started: $operation');
  }

  /// End timing an operation and log the duration
  static void endTiming(String operation) {
    final startTime = _startTimes[operation];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _measurements.putIfAbsent(operation, () => []).add(duration);

      developer.log('⏱️ Completed: $operation - ${duration.inMilliseconds}ms');

      if (duration.inMilliseconds > 1000) {
        developer.log(
          '⚠️ SLOW OPERATION: $operation took ${duration.inMilliseconds}ms',
        );
      }

      _startTimes.remove(operation);
    }
  }

  /// Get average time for an operation
  static Duration getAverageTime(String operation) {
    final measurements = _measurements[operation];
    if (measurements == null || measurements.isEmpty) {
      return Duration.zero;
    }

    final totalMs = measurements.fold<int>(
      0,
      (sum, duration) => sum + duration.inMilliseconds,
    );
    return Duration(milliseconds: totalMs ~/ measurements.length);
  }

  /// Print performance summary
  static void printSummary() {
    developer.log('📊 Performance Summary:');
    for (final entry in _measurements.entries) {
      final avg = getAverageTime(entry.key);
      developer.log(
        '  ${entry.key}: ${avg.inMilliseconds}ms (${entry.value.length} runs)',
      );
    }
  }
}
