import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/models.dart';

/// Comprehensive Cache Service
/// Handles multi-layer caching for products, feeds, and discovery content
/// Uses SharedPreferences for persistence with TTL management
/// Thread-safe with mutex for concurrent write protection
class CacheService {
  static CacheService? _instance;
  static SharedPreferences? _prefs;
  
  // Mutex to prevent concurrent writes (race condition protection)
  final Map<String, Completer<void>> _writeLocks = {};

  CacheService._();

  static Future<CacheService> getInstance() async {
    if (_instance == null) {
      _instance = CacheService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// Acquire write lock for a given key
  Future<void> _acquireWriteLock(String key) async {
    while (_writeLocks.containsKey(key)) {
      await _writeLocks[key]!.future;
    }
    _writeLocks[key] = Completer<void>();
  }

  /// Release write lock for a given key
  void _releaseWriteLock(String key) {
    final completer = _writeLocks.remove(key);
    completer?.complete();
  }

  // Cache key prefixes
  static const String _productPrefix = 'cache_product_';
  static const String _feedPrefix = 'cache_feed_';
  static const String _discoveryPrefix = 'cache_discovery_';
  static const String _metaPrefix = 'cache_meta_';

  // Default TTL values - Optimized for better performance
  static const Duration _productTTL = Duration(hours: 6); // Reduced from 24h
  static const Duration _feedTTL = Duration(hours: 2); // Increased from 1h for fewer refreshes
  static const Duration _discoveryTTL = Duration(hours: 4); // Reduced from 6h

  /// Cache a single product (thread-safe)
  Future<void> cacheProduct(
    Product product, {
    Duration ttl = _productTTL,
  }) async {
    final key = '$_productPrefix${product.id}';
    final metaKey = '$_metaPrefix$key';

    // Acquire write lock to prevent race conditions
    await _acquireWriteLock(key);
    
    try {
      final data = {
        'data': product.toJson(),
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'expiresAt': DateTime.now().add(ttl).millisecondsSinceEpoch,
      };

      await _prefs?.setString(key, jsonEncode(data));
      await _prefs?.setInt(metaKey, data['expiresAt'] as int);
    } finally {
      // Always release lock, even if operation fails
      _releaseWriteLock(key);
    }
  }

  /// Get cached product
  Future<Product?> getProduct(String productId) async {
    final key = '$_productPrefix$productId';
    final cached = _prefs?.getString(key);

    if (cached == null) return null;

    try {
      final data = jsonDecode(cached) as Map<String, dynamic>;
      final expiresAt = data['expiresAt'] as int;

      // Check if expired
      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        await _prefs?.remove(key);
        await _prefs?.remove('$_metaPrefix$key');
        return null;
      }

      return Product.fromJson(data['data'] as Map<String, dynamic>);
    } catch (e) {
      // Invalid cache, remove it
      await _prefs?.remove(key);
      return null;
    }
  }

  /// Cache a feed (list of products) - Optimized and thread-safe
  Future<void> cacheFeed(
    String cacheKey,
    List<Product> products, {
    Duration ttl = _feedTTL,
  }) async {
    final key = '$_feedPrefix$cacheKey';
    final metaKey = '$_metaPrefix$key';

    // Acquire write lock to prevent race conditions
    await _acquireWriteLock(key);
    
    try {
      // Cache feed with full product data (avoid double serialization)
      final data = {
        'products': products.map((p) => p.toJson()).toList(),
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'expiresAt': DateTime.now().add(ttl).millisecondsSinceEpoch,
      };

      await _prefs?.setString(key, jsonEncode(data));
      await _prefs?.setInt(metaKey, data['expiresAt'] as int);
    } finally {
      // Always release lock, even if operation fails
      _releaseWriteLock(key);
    }
  }

  /// Get cached feed - Optimized
  Future<List<Product>?> getFeed(String cacheKey) async {
    final key = '$_feedPrefix$cacheKey';
    final cached = _prefs?.getString(key);

    if (cached == null) return null;

    try {
      final data = jsonDecode(cached) as Map<String, dynamic>;
      final expiresAt = data['expiresAt'] as int;

      // Check if expired
      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        await _prefs?.remove(key);
        await _prefs?.remove('$_metaPrefix$key');
        return null;
      }

      // Load products directly from feed cache
      final productsJson = (data['products'] as List);
      final products = productsJson
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      return products;
    } catch (e) {
      await _prefs?.remove(key);
      return null;
    }
  }

  /// Cache discovery section (thread-safe)
  Future<void> cacheDiscovery(
    List<Product> trendingProducts,
    List<Product> newArrivals,
    List<Product> flashSales, {
    Duration ttl = _discoveryTTL,
  }) async {
    final metaKey = '${_discoveryPrefix}meta';
    
    // Acquire write lock for discovery metadata
    await _acquireWriteLock(metaKey);
    
    try {
      // Cache each section (these have their own locks)
      await cacheFeed('discovery_trending', trendingProducts, ttl: ttl);
      await cacheFeed('discovery_new', newArrivals, ttl: ttl);
      await cacheFeed('discovery_flash', flashSales, ttl: ttl);

      // Cache discovery metadata
      final data = {
        'cachedAt': DateTime.now().millisecondsSinceEpoch,
        'expiresAt': DateTime.now().add(ttl).millisecondsSinceEpoch,
      };
      await _prefs?.setString(metaKey, jsonEncode(data));
    } finally {
      _releaseWriteLock(metaKey);
    }
  }

  /// Get cached discovery section
  Future<Map<String, List<Product>>?> getDiscovery() async {
    final metaKey = '${_discoveryPrefix}meta';
    final meta = _prefs?.getString(metaKey);

    if (meta == null) return null;

    try {
      final data = jsonDecode(meta) as Map<String, dynamic>;
      final expiresAt = data['expiresAt'] as int;

      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        await clearDiscovery();
        return null;
      }

      final trending = await getFeed('discovery_trending');
      final newArrivals = await getFeed('discovery_new');
      final flashSales = await getFeed('discovery_flash');

      if (trending == null && newArrivals == null && flashSales == null) {
        return null;
      }

      return {
        'trending': trending ?? [],
        'newArrivals': newArrivals ?? [],
        'flashSales': flashSales ?? [],
      };
    } catch (e) {
      await clearDiscovery();
      return null;
    }
  }

  /// Clear discovery cache
  Future<void> clearDiscovery() async {
    await _prefs?.remove('${_discoveryPrefix}meta');
    await _prefs?.remove('${_feedPrefix}discovery_trending');
    await _prefs?.remove('${_feedPrefix}discovery_new');
    await _prefs?.remove('${_feedPrefix}discovery_flash');
  }

  /// Get stale cache (ignore TTL) for offline fallback - Optimized
  Future<List<Product>?> getStaleFeed(String cacheKey) async {
    final key = '$_feedPrefix$cacheKey';
    final cached = _prefs?.getString(key);

    if (cached == null) return null;

    try {
      final data = jsonDecode(cached) as Map<String, dynamic>;
      final productsJson = (data['products'] as List);
      final products = productsJson
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      return products.isEmpty ? null : products;
    } catch (e) {
      return null;
    }
  }

  /// Cleanup expired entries
  Future<void> cleanupExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final keys = _prefs?.getKeys() ?? {};

    for (final key in keys) {
      if (key.startsWith(_metaPrefix)) {
        final expiresAt = _prefs?.getInt(key);
        if (expiresAt != null && expiresAt < now) {
          final originalKey = key.replaceFirst(_metaPrefix, '');
          await _prefs?.remove(originalKey);
          await _prefs?.remove(key);
        }
      }
    }
  }

  /// Clear all caches - Optimized with batch removal
  Future<void> clearAll() async {
    final keys = _prefs?.getKeys() ?? {};
    final keysToRemove = keys.where((key) =>
        key.startsWith(_productPrefix) ||
        key.startsWith(_feedPrefix) ||
        key.startsWith(_discoveryPrefix) ||
        key.startsWith(_metaPrefix)).toList();
    
    // Batch remove for better performance
    for (final key in keysToRemove) {
      _prefs?.remove(key); // Remove synchronously without await
    }
    
    // Single commit at the end
    await _prefs?.commit();
    print('🗑️ Cleared ${keysToRemove.length} cache entries');
  }

  /// Get cache statistics
  Future<Map<String, int>> getCacheStats() async {
    final keys = _prefs?.getKeys() ?? {};
    int productCount = 0;
    int feedCount = 0;
    int expiredCount = 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    for (final key in keys) {
      if (key.startsWith(_productPrefix)) productCount++;
      if (key.startsWith(_feedPrefix)) feedCount++;
      
      if (key.startsWith(_metaPrefix)) {
        final expiresAt = _prefs?.getInt(key);
        if (expiresAt != null && expiresAt < now) expiredCount++;
      }
    }

    return {
      'products': productCount,
      'feeds': feedCount,
      'expired': expiredCount,
      'total': keys.length,
    };
  }
}