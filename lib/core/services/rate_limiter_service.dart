import 'dart:async';

/// Rate Limiter Service
/// Provides client-side rate limiting to prevent API abuse and respect server limits
/// Uses token bucket algorithm for flexible rate limiting
class RateLimiterService {
  static RateLimiterService? _instance;
  RateLimiterService._();

  static RateLimiterService get instance {
    _instance ??= RateLimiterService._();
    return _instance!;
  }

  // Rate limiters for different operations
  final Map<String, RateLimiter> _limiters = {};

  /// Get or create rate limiter for a specific operation
  RateLimiter getLimiter(
    String operation, {
    int maxTokens = 10,
    Duration refillDuration = const Duration(seconds: 1),
  }) {
    if (!_limiters.containsKey(operation)) {
      _limiters[operation] = RateLimiter(
        maxTokens: maxTokens,
        refillDuration: refillDuration,
      );
    }
    return _limiters[operation]!;
  }

  /// Pre-configured limiter for search operations (10 requests per second)
  RateLimiter get searchLimiter => getLimiter(
        'search',
        maxTokens: 10,
        refillDuration: const Duration(seconds: 1),
      );

  /// Pre-configured limiter for product fetching (20 requests per second)
  RateLimiter get productLimiter => getLimiter(
        'product',
        maxTokens: 20,
        refillDuration: const Duration(seconds: 1),
      );

  /// Pre-configured limiter for user actions (5 requests per second)
  RateLimiter get userActionLimiter => getLimiter(
        'user_action',
        maxTokens: 5,
        refillDuration: const Duration(seconds: 1),
      );

  /// Pre-configured limiter for analytics (50 requests per minute)
  RateLimiter get analyticsLimiter => getLimiter(
        'analytics',
        maxTokens: 50,
        refillDuration: const Duration(minutes: 1),
      );

  /// Clear all rate limiters
  void clearAll() {
    _limiters.clear();
  }
}

/// Token Bucket Rate Limiter
/// Implements token bucket algorithm for smooth rate limiting
class RateLimiter {
  final int maxTokens;
  final Duration refillDuration;
  
  int _availableTokens;
  DateTime _lastRefillTime;
  Timer? _refillTimer;

  RateLimiter({
    required this.maxTokens,
    required this.refillDuration,
  })  : _availableTokens = maxTokens,
        _lastRefillTime = DateTime.now() {
    _startRefillTimer();
  }

  /// Start periodic token refill
  void _startRefillTimer() {
    _refillTimer?.cancel();
    _refillTimer = Timer.periodic(refillDuration, (_) {
      _refillTokens();
    });
  }

  /// Refill tokens based on elapsed time
  void _refillTokens() {
    final now = DateTime.now();
    final elapsed = now.difference(_lastRefillTime);
    
    if (elapsed >= refillDuration) {
      _availableTokens = maxTokens;
      _lastRefillTime = now;
    }
  }

  /// Check if action is allowed (non-blocking)
  bool isAllowed() {
    _refillTokens();
    return _availableTokens > 0;
  }

  /// Consume a token if available
  bool tryConsume({int tokens = 1}) {
    _refillTokens();
    
    if (_availableTokens >= tokens) {
      _availableTokens -= tokens;
      return true;
    }
    return false;
  }

  /// Wait until tokens are available (blocking)
  Future<void> consume({int tokens = 1}) async {
    while (!tryConsume(tokens: tokens)) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Execute function with rate limiting
  Future<T> execute<T>(Future<T> Function() action) async {
    await consume();
    return await action();
  }

  /// Execute function if allowed, otherwise return null
  Future<T?> tryExecute<T>(Future<T> Function() action) async {
    if (tryConsume()) {
      return await action();
    }
    return null;
  }

  /// Get remaining tokens
  int get remainingTokens {
    _refillTokens();
    return _availableTokens;
  }

  /// Check if rate limit is exhausted
  bool get isExhausted => remainingTokens == 0;

  /// Get time until next refill
  Duration get timeUntilRefill {
    final elapsed = DateTime.now().difference(_lastRefillTime);
    final remaining = refillDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Dispose the rate limiter
  void dispose() {
    _refillTimer?.cancel();
    _refillTimer = null;
  }
}

/// Rate limit exception
class RateLimitException implements Exception {
  final String message;
  final Duration retryAfter;

  RateLimitException(this.message, this.retryAfter);

  @override
  String toString() => 'RateLimitException: $message (retry after ${retryAfter.inSeconds}s)';
}

/// Extension for easy rate limiting on futures
extension RateLimitedFuture<T> on Future<T> Function() {
  /// Execute with rate limiting
  Future<T> withRateLimit(RateLimiter limiter) async {
    return await limiter.execute(this);
  }

  /// Try to execute with rate limiting, return null if not allowed
  Future<T?> tryWithRateLimit(RateLimiter limiter) async {
    return await limiter.tryExecute(this);
  }
}