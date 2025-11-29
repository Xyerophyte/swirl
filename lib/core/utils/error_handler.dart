import 'package:supabase_flutter/supabase_flutter.dart';

/// Comprehensive Error Handler for SWIRL App
/// Provides consistent error handling and user-friendly messages
/// Based on Supabase best practices
class ErrorHandler {
  /// Handle Supabase errors and return user-friendly messages
  static String handleError(Object error, {String? context}) {
    // PostgrestException - Database/API errors
    if (error is PostgrestException) {
      return _handlePostgrestError(error, context: context);
    }
    
    // AuthException - Authentication errors
    if (error is AuthException) {
      return _handleAuthError(error);
    }
    
    // StorageException - File storage errors
    if (error is StorageException) {
      return _handleStorageError(error);
    }
    
    // Generic exceptions
    return _handleGenericError(error, context: context);
  }
  
  /// Handle Postgrest (database) errors
  static String _handlePostgrestError(
    PostgrestException error, {
    String? context,
  }) {
    // Check for common error codes
    if (error.message.contains('Row not found')) {
      return 'The requested ${context ?? 'item'} was not found.';
    }
    
    if (error.message.contains('duplicate key')) {
      return 'This ${context ?? 'item'} already exists.';
    }
    
    if (error.message.contains('violates foreign key constraint')) {
      return 'Cannot complete this action due to related data.';
    }
    
    if (error.message.contains('permission denied')) {
      return 'You don\'t have permission to perform this action.';
    }
    
    // Network/connectivity issues
    if (error.message.contains('Failed host lookup') ||
        error.message.contains('No address associated')) {
      return 'No internet connection. Please check your network.';
    }
    
    if (error.message.contains('Timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    // Default database error
    return 'Database error: ${error.message}';
  }
  
  /// Handle authentication errors
  static String _handleAuthError(AuthException error) {
    // Use error code for precise error handling
    switch (error.statusCode) {
      case '400':
        return 'Invalid login credentials.';
      case '422':
        if (error.message.contains('Email not confirmed')) {
          return 'Please verify your email address.';
        }
        return 'Unable to process your request.';
      case '429':
        return 'Too many attempts. Please try again later.';
      case '500':
        return 'Authentication service unavailable. Please try again.';
      default:
        return 'Authentication error: ${error.message}';
    }
  }
  
  /// Handle storage errors
  static String _handleStorageError(StorageException error) {
    if (error.message.contains('not found')) {
      return 'File not found.';
    }
    
    if (error.message.contains('too large')) {
      return 'File is too large to upload.';
    }
    
    if (error.message.contains('invalid')) {
      return 'Invalid file type.';
    }
    
    return 'Storage error: ${error.message}';
  }
  
  /// Handle generic errors
  static String _handleGenericError(Object error, {String? context}) {
    final errorStr = error.toString();
    
    // Network errors
    if (errorStr.contains('SocketException') ||
        errorStr.contains('NetworkException')) {
      return 'Network connection error. Please check your internet.';
    }
    
    // Timeout errors
    if (errorStr.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    
    // Format errors
    if (errorStr.contains('FormatException')) {
      return 'Invalid data format received.';
    }
    
    // Type errors (shouldn't happen in production)
    if (errorStr.contains('TypeError') || errorStr.contains('type')) {
      return 'Unexpected data type. Please report this issue.';
    }
    
    // Default error message
    if (context != null) {
      return 'Error in $context: ${error.toString()}';
    }
    
    return 'An unexpected error occurred. Please try again.';
  }
  
  /// Log error for debugging (in development mode)
  static void logError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    // Only log in debug mode
    assert(() {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('ERROR: ${context ?? 'Unknown context'}');
      print('Type: ${error.runtimeType}');
      print('Message: $error');
      if (stackTrace != null) {
        print('Stack trace:\n$stackTrace');
      }
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return true;
    }());
  }
  
  /// Handle error and return both message and whether to show retry
  static ErrorResult handleErrorWithRetry(
    Object error, {
    String? context,
  }) {
    final message = handleError(error, context: context);
    
    // Determine if error is retryable
    final isRetryable = _isRetryableError(error);
    
    return ErrorResult(
      message: message,
      isRetryable: isRetryable,
      originalError: error,
    );
  }
  
  /// Determine if error is retryable
  static bool _isRetryableError(Object error) {
    final errorStr = error.toString();
    
    // Network errors are retryable
    if (errorStr.contains('SocketException') ||
        errorStr.contains('NetworkException') ||
        errorStr.contains('Timeout') ||
        errorStr.contains('Failed host lookup')) {
      return true;
    }
    
    // Rate limit errors are retryable (after waiting)
    if (error is AuthException && error.statusCode == '429') {
      return true;
    }
    
    if (error is PostgrestException &&
        error.message.contains('Too many requests')) {
      return true;
    }
    
    // Server errors are retryable
    if (errorStr.contains('500') || errorStr.contains('503')) {
      return true;
    }
    
    // Database connection errors are retryable
    if (error is PostgrestException &&
        (error.message.contains('connection') ||
            error.message.contains('timeout'))) {
      return true;
    }
    
    return false;
  }
  
  /// Get error category for analytics/monitoring
  static ErrorCategory categorizeError(Object error) {
    if (error is PostgrestException) {
      if (error.message.contains('permission')) {
        return ErrorCategory.authorization;
      }
      if (error.message.contains('not found')) {
        return ErrorCategory.notFound;
      }
      return ErrorCategory.database;
    }
    
    if (error is AuthException) {
      return ErrorCategory.authentication;
    }
    
    if (error is StorageException) {
      return ErrorCategory.storage;
    }
    
    final errorStr = error.toString();
    if (errorStr.contains('Network') || errorStr.contains('Socket')) {
      return ErrorCategory.network;
    }
    
    if (errorStr.contains('Timeout')) {
      return ErrorCategory.timeout;
    }
    
    return ErrorCategory.unknown;
  }
}

/// Result of error handling with additional metadata
class ErrorResult {
  final String message;
  final bool isRetryable;
  final Object originalError;
  
  const ErrorResult({
    required this.message,
    required this.isRetryable,
    required this.originalError,
  });
  
  /// Create error result with custom message
  factory ErrorResult.custom({
    required String message,
    bool isRetryable = false,
  }) {
    return ErrorResult(
      message: message,
      isRetryable: isRetryable,
      originalError: Exception(message),
    );
  }
}

/// Error categories for analytics and monitoring
enum ErrorCategory {
  database,
  authentication,
  authorization,
  storage,
  network,
  timeout,
  notFound,
  validation,
  unknown,
}

/// Extension on Future for easy error handling
extension FutureErrorHandler<T> on Future<T> {
  /// Catch errors and return user-friendly message
  Future<T> handleErrors(String context) {
    return onError((error, stackTrace) {
      if (error != null) {
        ErrorHandler.logError(error, stackTrace: stackTrace, context: context);
        throw ErrorHandler.handleError(error, context: context);
      }
      throw error ?? Exception('Unknown error');
    });
  }
  
  /// Catch errors and return ErrorResult
  Future<T> handleErrorsWithRetry(String context) {
    return onError((error, stackTrace) {
      if (error != null) {
        ErrorHandler.logError(error, stackTrace: stackTrace, context: context);
        final result = ErrorHandler.handleErrorWithRetry(error, context: context);
        throw result;
      }
      throw error ?? Exception('Unknown error');
    });
  }
}