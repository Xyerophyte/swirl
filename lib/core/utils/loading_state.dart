/// Loading State Management
/// Provides standardized loading states for async operations
/// 
/// Features:
/// - Type-safe loading states
/// - Error handling with context
/// - Success/failure tracking
/// - Retry capability
/// - Progress tracking support

/// Generic loading state with data
class LoadingState<T> {
  final bool isLoading;
  final bool isRefreshing;
  final T? data;
  final String? error;
  final StackTrace? stackTrace;
  final DateTime? lastUpdated;
  final int retryCount;
  
  const LoadingState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.data,
    this.error,
    this.stackTrace,
    this.lastUpdated,
    this.retryCount = 0,
  });
  
  /// Initial state (no data, not loading)
  const LoadingState.initial()
      : isLoading = false,
        isRefreshing = false,
        data = null,
        error = null,
        stackTrace = null,
        lastUpdated = null,
        retryCount = 0;
  
  /// Loading state (initial load)
  const LoadingState.loading({T? previousData})
      : isLoading = true,
        isRefreshing = false,
        data = previousData,
        error = null,
        stackTrace = null,
        lastUpdated = null,
        retryCount = 0;
  
  /// Refreshing state (has data, reloading)
  LoadingState.refreshing(T existingData)
      : isLoading = false,
        isRefreshing = true,
        data = existingData,
        error = null,
        stackTrace = null,
        lastUpdated = DateTime.now(),
        retryCount = 0;
  
  /// Success state with data
  LoadingState.success(T data)
      : isLoading = false,
        isRefreshing = false,
        data = data,
        error = null,
        stackTrace = null,
        lastUpdated = DateTime.now(),
        retryCount = 0;
  
  /// Error state
  LoadingState.error(
    String error, {
    T? previousData,
    StackTrace? stackTrace,
    int retryCount = 0,
  })  : isLoading = false,
        isRefreshing = false,
        data = previousData,
        error = error,
        stackTrace = stackTrace,
        lastUpdated = DateTime.now(),
        retryCount = retryCount;
  
  /// Check if has data
  bool get hasData => data != null;
  
  /// Check if has error
  bool get hasError => error != null;
  
  /// Check if idle (not loading, no error)
  bool get isIdle => !isLoading && !isRefreshing && !hasError;
  
  /// Check if any loading state
  bool get isAnyLoading => isLoading || isRefreshing;
  
  /// Check if can retry
  bool get canRetry => hasError && retryCount < 3;
  
  /// Get status text for UI
  String get statusText {
    if (isLoading) return 'Loading...';
    if (isRefreshing) return 'Refreshing...';
    if (hasError) return error!;
    if (hasData) return 'Loaded';
    return 'Idle';
  }
  
  /// Copy with new values
  LoadingState<T> copyWith({
    bool? isLoading,
    bool? isRefreshing,
    T? data,
    String? error,
    StackTrace? stackTrace,
    DateTime? lastUpdated,
    int? retryCount,
  }) {
    return LoadingState<T>(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      data: data ?? this.data,
      error: error,
      stackTrace: stackTrace,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      retryCount: retryCount ?? this.retryCount,
    );
  }
  
  /// Map data to another type
  LoadingState<R> map<R>(R Function(T) mapper) {
    return LoadingState<R>(
      isLoading: isLoading,
      isRefreshing: isRefreshing,
      data: data != null ? mapper(data!) : null,
      error: error,
      stackTrace: stackTrace,
      lastUpdated: lastUpdated,
      retryCount: retryCount,
    );
  }
  
  @override
  String toString() => 'LoadingState(isLoading: $isLoading, isRefreshing: $isRefreshing, '
      'hasData: $hasData, error: $error, retryCount: $retryCount)';
}

/// Paginated loading state
class PaginatedLoadingState<T> extends LoadingState<List<T>> {
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final int totalItems;
  
  const PaginatedLoadingState({
    bool isLoading = false,
    bool isRefreshing = false,
    List<T>? data,
    String? error,
    StackTrace? stackTrace,
    DateTime? lastUpdated,
    int retryCount = 0,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.totalItems = 0,
  }) : super(
          isLoading: isLoading,
          isRefreshing: isRefreshing,
          data: data,
          error: error,
          stackTrace: stackTrace,
          lastUpdated: lastUpdated,
          retryCount: retryCount,
        );
  
  /// Initial state
  const PaginatedLoadingState.initial()
      : isLoadingMore = false,
        hasMore = true,
        currentPage = 0,
        totalItems = 0,
        super.initial();
  
  /// Loading first page
  const PaginatedLoadingState.loading()
      : isLoadingMore = false,
        hasMore = true,
        currentPage = 0,
        totalItems = 0,
        super.loading();
  
  /// Loading more items
  PaginatedLoadingState.loadingMore(List<T> existingData, {int currentPage = 0})
      : isLoadingMore = true,
        hasMore = true,
        currentPage = currentPage,
        totalItems = existingData.length,
        super(
          isLoading: false,
          isRefreshing: false,
          data: existingData,
          lastUpdated: DateTime.now(),
        );
  
  /// Success with pagination info
  PaginatedLoadingState.success(
    List<T> data, {
    required bool hasMore,
    int currentPage = 0,
    int? totalItems,
  })  : isLoadingMore = false,
        hasMore = hasMore,
        currentPage = currentPage,
        totalItems = totalItems ?? data.length,
        super.success(data);
  
  /// Error state
  PaginatedLoadingState.error(
    String error, {
    List<T>? previousData,
    StackTrace? stackTrace,
    int retryCount = 0,
    int currentPage = 0,
  })  : isLoadingMore = false,
        hasMore = true,
        currentPage = currentPage,
        totalItems = previousData?.length ?? 0,
        super.error(
          error,
          previousData: previousData,
          stackTrace: stackTrace,
          retryCount: retryCount,
        );
  
  /// Get items count
  int get itemCount => data?.length ?? 0;
  
  /// Check if any loading
  @override
  bool get isAnyLoading => isLoading || isRefreshing || isLoadingMore;
  
  /// Copy with new values
  PaginatedLoadingState<T> copyWithPaginated({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    List<T>? data,
    String? error,
    StackTrace? stackTrace,
    DateTime? lastUpdated,
    int? retryCount,
    bool? hasMore,
    int? currentPage,
    int? totalItems,
  }) {
    return PaginatedLoadingState<T>(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      data: data ?? this.data,
      error: error,
      stackTrace: stackTrace,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      retryCount: retryCount ?? this.retryCount,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }
  
  @override
  String toString() => 'PaginatedLoadingState(isLoading: $isLoading, '
      'isLoadingMore: $isLoadingMore, itemCount: $itemCount, '
      'hasMore: $hasMore, currentPage: $currentPage, error: $error)';
}

/// Progress loading state (for uploads, downloads, etc.)
class ProgressLoadingState<T> extends LoadingState<T> {
  final double progress; // 0.0 to 1.0
  final String? progressMessage;
  
  const ProgressLoadingState({
    bool isLoading = false,
    T? data,
    String? error,
    StackTrace? stackTrace,
    DateTime? lastUpdated,
    int retryCount = 0,
    this.progress = 0.0,
    this.progressMessage,
  }) : super(
          isLoading: isLoading,
          data: data,
          error: error,
          stackTrace: stackTrace,
          lastUpdated: lastUpdated,
          retryCount: retryCount,
        );
  
  /// Loading with progress
  const ProgressLoadingState.loading({
    double progress = 0.0,
    String? message,
  })  : progress = progress,
        progressMessage = message,
        super.loading();
  
  /// Success state
  ProgressLoadingState.success(T data)
      : progress = 1.0,
        progressMessage = 'Complete',
        super.success(data);
  
  /// Error state
  ProgressLoadingState.error(
    String error, {
    T? previousData,
    StackTrace? stackTrace,
    double progress = 0.0,
  })  : progress = progress,
        progressMessage = null,
        super.error(error, previousData: previousData, stackTrace: stackTrace);
  
  /// Get progress percentage (0-100)
  int get progressPercent => (progress * 100).round();
  
  /// Check if complete
  bool get isComplete => progress >= 1.0;
  
  /// Copy with new progress
  ProgressLoadingState<T> copyWithProgress({
    bool? isLoading,
    T? data,
    String? error,
    double? progress,
    String? progressMessage,
  }) {
    return ProgressLoadingState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
      progress: progress ?? this.progress,
      progressMessage: progressMessage ?? this.progressMessage,
    );
  }
  
  @override
  String toString() => 'ProgressLoadingState(isLoading: $isLoading, '
      'progress: ${progressPercent}%, message: $progressMessage, error: $error)';
}

/// Extension to work with LoadingState in widgets
extension LoadingStateExtension<T> on LoadingState<T> {
  /// Execute different callbacks based on state
  R when<R>({
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String error) error,
    R Function()? idle,
  }) {
    if (isLoading) return loading();
    if (hasError) return error(this.error!);
    if (hasData) return success(data!);
    if (idle != null) return idle();
    return loading(); // Default fallback
  }
  
  /// Execute callbacks only for specific states (optional)
  R? maybeWhen<R>({
    R Function()? loading,
    R Function(T data)? success,
    R Function(String error)? error,
    R Function()? idle,
    required R Function() orElse,
  }) {
    if (isLoading && loading != null) return loading();
    if (hasError && error != null) return error(this.error!);
    if (hasData && success != null) return success(data!);
    if (isIdle && idle != null) return idle();
    return orElse();
  }
}