import 'dart:async';

import 'package:flutter/foundation.dart';

/// Global error handler utility for printing errors to console
class GlobalErrorHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    // Print error details to console
    print('🚨 FLUTTER ERROR:');
    print('Exception: ${details.exception}');
    print('Library: ${details.library}');
    print('Context: ${details.context}');
    print('Stack: ${details.stack}');
    print('═══════════════════════════════════════════════════════════════');

    // 打印到 IDE console
    FlutterError.dumpErrorToConsole(details);
    // 同时保留红屏显示
    FlutterError.presentError(details);
  }

  static void handleDartError(Object error, StackTrace stack) {
    // Print error details to console
    print('🚨 DART ERROR:');
    print('Exception: $error');
    print('Stack: $stack');
    print('═══════════════════════════════════════════════════════════════');

    // Also dump to console using Flutter's error dumping
    if (error is FlutterErrorDetails) {
      FlutterError.dumpErrorToConsole(error);
    } else {
      // For non-Flutter errors, create a FlutterErrorDetails-like output
      print('Error Type: ${error.runtimeType}');
      print('Error Message: $error');
    }
  }

  static void handleAsyncError(Object error, StackTrace stack) {
    // Print error details to console
    print('🚨 ASYNC ERROR:');
    print('Exception: $error');
    print('Stack: $stack');
    print('═══════════════════════════════════════════════════════════════');

    // Also dump to console using Flutter's error dumping
    if (error is FlutterErrorDetails) {
      FlutterError.dumpErrorToConsole(error);
    } else {
      // For non-Flutter errors, create a FlutterErrorDetails-like output
      print('Error Type: ${error.runtimeType}');
      print('Error Message: $error');
    }
  }

  /// Setup global error handlers
  static void setup() {
    print('🔧 Setting up global error handlers...');

    // Handle Flutter framework errors with console output
    FlutterError.onError = (FlutterErrorDetails details) {
      // 打印到 IDE console
      FlutterError.dumpErrorToConsole(details);
      // 同时保留红屏显示
      FlutterError.presentError(details);
    };

    // Handle errors outside of Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      // 打印到 IDE console
      print('🚨 PLATFORM ERROR:');
      print('Exception: $error');
      print('Stack: $stack');
      print('═══════════════════════════════════════════════════════════════');

      // Also use Flutter's error dumping for consistency
      if (error is FlutterErrorDetails) {
        FlutterError.dumpErrorToConsole(error);
      } else {
        print('Error Type: ${error.runtimeType}');
        print('Error Message: $error');
      }

      return true; // Return true to indicate error was handled
    };

    print('✅ Global error handlers configured successfully');
  }

  /// Run app with error handling zone
  static void runAppWithErrorHandling(VoidCallback appRunner) {
    print('🚀 Starting app with error handling zone...');
    runZonedGuarded(appRunner, (error, stack) {
      handleAsyncError(error, stack);
    });
  }
}
