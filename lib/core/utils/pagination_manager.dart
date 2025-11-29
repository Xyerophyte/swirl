/// Pagination Manager
/// Prevents duplicate loads and manages pagination state across providers
/// 
/// Features:
/// - Prevents concurrent pagination requests
/// - Tracks loading states per page
/// - Handles end-of-list detection
/// - Supports cursor-based and offset-based pagination
/// - Thread-safe with lock mechanism

class PaginationManager {
  // Current offset/page
  int _currentOffset = 0;
  
  // Total items loaded so far
  int _totalLoaded = 0;
  
  // Flag to prevent concurrent loads
  bool _isLoading = false;
  
  // Has reached end of list
  bool _hasReachedEnd = false;
  
  // Items per page
  final int itemsPerPage;
  
  // Minimum time between requests (throttle)
  final Duration throttleDuration;
  DateTime? _lastLoadTime;
  
  // For cursor-based pagination (optional)
  String? _nextCursor;
  
  PaginationManager({
    this.itemsPerPage = 20,
    this.throttleDuration = const Duration(milliseconds: 300),
  });
  
  /// Get current offset for next load
  int get currentOffset => _currentOffset;
  
  /// Get total items loaded
  int get totalLoaded => _totalLoaded;
  
  /// Check if currently loading
  bool get isLoading => _isLoading;
  
  /// Check if reached end of list
  bool get hasReachedEnd => _hasReachedEnd;
  
  /// Check if can load more
  bool get canLoadMore => !_isLoading && !_hasReachedEnd;
  
  /// Get next cursor (for cursor-based pagination)
  String? get nextCursor => _nextCursor;
  
  /// Check if should throttle (too soon after last load)
  bool get shouldThrottle {
    if (_lastLoadTime == null) return false;
    final timeSinceLastLoad = DateTime.now().difference(_lastLoadTime!);
    return timeSinceLastLoad < throttleDuration;
  }
  
  /// Start loading (acquire lock)
  /// Returns true if lock acquired, false if already loading
  bool startLoading() {
    if (_isLoading) {
      print('⚠️ Pagination: Already loading, skipping duplicate request');
      return false;
    }
    
    if (shouldThrottle) {
      print('⚠️ Pagination: Throttling request (too soon)');
      return false;
    }
    
    if (_hasReachedEnd) {
      print('⚠️ Pagination: End of list reached');
      return false;
    }
    
    _isLoading = true;
    _lastLoadTime = DateTime.now();
    print('🔓 Pagination: Lock acquired for offset $_currentOffset');
    return true;
  }
  
  /// Complete loading (release lock)
  /// 
  /// Parameters:
  /// - [itemsLoaded]: Number of items loaded in this batch
  /// - [expectedItems]: Expected number of items (to detect end)
  /// - [nextCursor]: Next cursor for cursor-based pagination (optional)
  void completeLoading({
    required int itemsLoaded,
    int? expectedItems,
    String? nextCursor,
  }) {
    _isLoading = false;
    _totalLoaded += itemsLoaded;
    _currentOffset += itemsLoaded;
    _nextCursor = nextCursor;
    
    // Detect end of list
    if (expectedItems != null && itemsLoaded < expectedItems) {
      _hasReachedEnd = true;
      print('🏁 Pagination: End reached (got $itemsLoaded, expected $expectedItems)');
    } else if (itemsLoaded == 0) {
      _hasReachedEnd = true;
      print('🏁 Pagination: End reached (no items)');
    } else if (nextCursor == null && expectedItems != null) {
      // For cursor-based: no next cursor means end
      _hasReachedEnd = true;
      print('🏁 Pagination: End reached (no next cursor)');
    }
    
    print('🔒 Pagination: Lock released. Total loaded: $_totalLoaded');
  }
  
  /// Handle loading error (release lock)
  void errorLoading() {
    _isLoading = false;
    print('❌ Pagination: Error occurred, lock released');
  }
  
  /// Reset pagination state (for filter changes, refresh, etc.)
  void reset() {
    _currentOffset = 0;
    _totalLoaded = 0;
    _isLoading = false;
    _hasReachedEnd = false;
    _nextCursor = null;
    _lastLoadTime = null;
    print('🔄 Pagination: State reset');
  }
  
  /// Check if should trigger load based on current position
  /// 
  /// Parameters:
  /// - [currentIndex]: Current viewing position
  /// - [threshold]: How many items before end to trigger load (default: 5)
  /// 
  /// Returns true if should load more
  bool shouldLoadMore({
    required int currentIndex,
    int threshold = 5,
  }) {
    if (!canLoadMore) return false;
    
    final remainingItems = _totalLoaded - currentIndex;
    final shouldLoad = remainingItems <= threshold;
    
    if (shouldLoad) {
      print('📊 Pagination: Should load more (remaining: $remainingItems, threshold: $threshold)');
    }
    
    return shouldLoad;
  }
  
  /// Get debug info
  Map<String, dynamic> getDebugInfo() {
    return {
      'currentOffset': _currentOffset,
      'totalLoaded': _totalLoaded,
      'isLoading': _isLoading,
      'hasReachedEnd': _hasReachedEnd,
      'nextCursor': _nextCursor,
      'canLoadMore': canLoadMore,
      'itemsPerPage': itemsPerPage,
    };
  }
}

/// Pagination Result
/// Wrapper for pagination response with metadata
class PaginationResult<T> {
  final List<T> items;
  final int totalCount;
  final bool hasMore;
  final String? nextCursor;
  final int currentPage;
  
  const PaginationResult({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    this.nextCursor,
    this.currentPage = 0,
  });
  
  /// Check if empty result
  bool get isEmpty => items.isEmpty;
  
  /// Check if has items
  bool get isNotEmpty => items.isNotEmpty;
  
  /// Get items count in this batch
  int get count => items.length;
}

/// Pagination Error
class PaginationError implements Exception {
  final String message;
  final dynamic originalError;
  
  PaginationError(this.message, [this.originalError]);
  
  @override
  String toString() => 'PaginationError: $message';
}

/// Extension for List to help with pagination
extension PaginationListExtension<T> on List<T> {
  /// Safely append items preventing duplicates
  /// 
  /// Parameters:
  /// - [newItems]: Items to append
  /// - [idGetter]: Function to get unique ID from item
  /// 
  /// Returns new list with deduplicated items
  List<T> appendUnique(
    List<T> newItems, 
    String Function(T) idGetter,
  ) {
    final existingIds = map(idGetter).toSet();
    final uniqueNewItems = newItems.where((item) {
      final id = idGetter(item);
      return !existingIds.contains(id);
    }).toList();
    
    if (uniqueNewItems.length < newItems.length) {
      final duplicates = newItems.length - uniqueNewItems.length;
      print('⚠️ Removed $duplicates duplicate items');
    }
    
    return [...this, ...uniqueNewItems];
  }
}