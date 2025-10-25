import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Global error handler utility for printing errors to console
class GlobalErrorHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    // Log error details to console
    developer.log('🚨 FLUTTER ERROR:', name: 'ErrorHandler');
    developer.log('Exception: ${details.exception}', name: 'ErrorHandler');
    developer.log('Library: ${details.library}', name: 'ErrorHandler');
    developer.log('Context: ${details.context}', name: 'ErrorHandler');
    developer.log('Stack: ${details.stack}', name: 'ErrorHandler');
    developer.log(
      '═══════════════════════════════════════════════════════════════',
      name: 'ErrorHandler',
    );

    // 打印到 IDE console
    FlutterError.dumpErrorToConsole(details);
    // 同时保留红屏显示
    FlutterError.presentError(details);
  }

  static void handleDartError(Object error, StackTrace stack) {
    // Log error details to console
    developer.log('🚨 DART ERROR:', name: 'ErrorHandler');
    developer.log('Exception: $error', name: 'ErrorHandler');
    developer.log('Stack: $stack', name: 'ErrorHandler');
    developer.log(
      '═══════════════════════════════════════════════════════════════',
      name: 'ErrorHandler',
    );

    // Also dump to console using Flutter's error dumping
    if (error is FlutterErrorDetails) {
      FlutterError.dumpErrorToConsole(error);
    } else {
      // For non-Flutter errors, create a FlutterErrorDetails-like output
      developer.log('Error Type: ${error.runtimeType}', name: 'ErrorHandler');
      developer.log('Error Message: $error', name: 'ErrorHandler');
    }
  }

  static void handleAsyncError(Object error, StackTrace stack) {
    // Log error details to console
    developer.log('🚨 ASYNC ERROR:', name: 'ErrorHandler');
    developer.log('Exception: $error', name: 'ErrorHandler');
    developer.log('Stack: $stack', name: 'ErrorHandler');
    developer.log(
      '═══════════════════════════════════════════════════════════════',
      name: 'ErrorHandler',
    );

    // Also dump to console using Flutter's error dumping
    if (error is FlutterErrorDetails) {
      FlutterError.dumpErrorToConsole(error);
    } else {
      // For non-Flutter errors, create a FlutterErrorDetails-like output
      developer.log('Error Type: ${error.runtimeType}', name: 'ErrorHandler');
      developer.log('Error Message: $error', name: 'ErrorHandler');
    }
  }

  /// Setup global error handlers
  static void setup() {
    developer.log(
      '🔧 Setting up global error handlers...',
      name: 'ErrorHandler',
    );

    // Handle Flutter framework errors with console output
    FlutterError.onError = (FlutterErrorDetails details) {
      // 打印到 IDE console
      FlutterError.dumpErrorToConsole(details);
      // 同时保留红屏显示
      FlutterError.presentError(details);
    };

    // Handle errors outside of Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      // Log to IDE console
      developer.log('🚨 PLATFORM ERROR:', name: 'ErrorHandler');
      developer.log('Exception: $error', name: 'ErrorHandler');
      developer.log('Stack: $stack', name: 'ErrorHandler');
      developer.log(
        '═══════════════════════════════════════════════════════════════',
        name: 'ErrorHandler',
      );

      // Also use Flutter's error dumping for consistency
      if (error is FlutterErrorDetails) {
        FlutterError.dumpErrorToConsole(error);
      } else {
        developer.log('Error Type: ${error.runtimeType}', name: 'ErrorHandler');
        developer.log('Error Message: $error', name: 'ErrorHandler');
      }

      return true; // Return true to indicate error was handled
    };

    developer.log(
      '✅ Global error handlers configured successfully',
      name: 'ErrorHandler',
    );
  }

  /// Run app with error handling zone
  static void runAppWithErrorHandling(VoidCallback appRunner) {
    developer.log(
      '🚀 Starting app with error handling zone...',
      name: 'ErrorHandler',
    );
    runZonedGuarded(appRunner, (error, stack) {
      handleAsyncError(error, stack);
    });
  }
}
