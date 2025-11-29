import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import '../../core/services/cache_service.dart';
import '../../core/utils/error_handler.dart';

/// Product Repository
/// Handles product-related operations with comprehensive caching
class ProductRepository {
  final SupabaseClient _client;
  late final Future<CacheService> _cacheService;

  ProductRepository(this._client) {
    _cacheService = CacheService.getInstance();
  }

  /// Get products with optional filters
  Future<List<Product>> getProducts({
    String? category,
    String? brand,
    List<String>? styleTags,
    double? minPrice,
    double? maxPrice,
    bool? isTrending,
    bool? isNewArrival,
    bool? isFlashSale,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = _client.from('products').select();

      // Apply filters
      if (category != null) {
        query = query.eq('category', category);
      }
      if (brand != null) {
        query = query.eq('brand', brand);
      }
      if (styleTags != null && styleTags.isNotEmpty) {
        query = query.overlaps('style_tags', styleTags);
      }
      if (minPrice != null) {
        query = query.gte('price', minPrice);
      }
      if (maxPrice != null) {
        query = query.lte('price', maxPrice);
      }
      if (isTrending != null && isTrending) {
        query = query.eq('is_trending', true);
      }
      if (isNewArrival != null && isNewArrival) {
        query = query.eq('is_new_arrival', true);
      }
      if (isFlashSale != null && isFlashSale) {
        query = query.eq('is_flash_sale', true);
      }

      // Apply pagination and execute
      final response = await query.range(offset, offset + limit - 1);
      
      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ErrorHandler.logError(e, context: 'getProducts');
      throw Exception(ErrorHandler.handleError(e, context: 'fetching products'));
    }
  }

  /// Search products by name or brand
  Future<List<Product>> searchProducts({
    required String query,
    String? category,
    int limit = 20,
  }) async {
    try {
      var supabaseQuery = _client
          .from('products')
          .select()
          .or('name.ilike.%$query%,brand.ilike.%$query%');

      if (category != null) {
        supabaseQuery = supabaseQuery.eq('category', category);
      }

      final response = await supabaseQuery.limit(limit);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ErrorHandler.logError(e, context: 'searchProducts');
      throw Exception(ErrorHandler.handleError(e, context: 'searching products'));
    }
  }

 /// Get a single product by ID
 Future<Product?> getProductById(String id) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return Product.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      ErrorHandler.logError(e, context: 'getProductById');
      throw Exception(ErrorHandler.handleError(e, context: 'getting product'));
    } catch (e) {
      ErrorHandler.logError(e, context: 'getProductById');
      throw Exception(ErrorHandler.handleError(e, context: 'getting product'));
    }
  }

  /// Get products for feed (with user preferences) - OPTIMIZED with progressive caching
  Future<List<Product>> getFeed({
    required String userId,
    List<String>? styleFilters,
    String? category,
    double? minPrice,
    double? maxPrice,
    int limit = 10, // Reduced to 10 for initial load
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    // Null safety checks
    if (userId.isEmpty) {
      throw ArgumentError('userId cannot be empty');
    }
    if (limit <= 0) {
      throw ArgumentError('limit must be positive');
    }
    if (offset < 0) {
      throw ArgumentError('offset cannot be negative');
    }

    final cache = await _cacheService;
    final cacheKey = 'feed_${userId}_${category ?? "all"}_${styleFilters?.join(",") ?? "any"}_$offset';

    // 1. Try cache first (unless forced refresh)
    if (!forceRefresh) {
      final cached = await cache.getFeed(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        print('📦 Cache HIT: Returning ${cached.length} products from cache');
        return cached;
      }
    }

    // 2. Fetch from network
    try {
      print('🌐 Cache MISS: Fetching from Supabase');
      
      // Build base query
      var query = _client.from('products').select();

      // Apply category filter (gender preference)
      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      // Apply style filters if provided
      if (styleFilters != null && styleFilters.isNotEmpty) {
        query = query.overlaps('style_tags', styleFilters);
      }

      // Apply price range filters with validation
      if (minPrice != null && minPrice >= 0) {
        query = query.gte('price', minPrice);
      }
      if (maxPrice != null && maxPrice >= 0) {
        query = query.lte('price', maxPrice);
      }

      // Fetch products without ordering (we'll shuffle in Dart)
      final response = await query
          .range(offset, offset + limit - 1);
      
      // Null safety: Ensure response is not null
      if (response == null) {
        print('⚠️ Received null response from Supabase');
        return [];
      }

      final products = (response as List)
          .map((json) {
            try {
              return Product.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              ErrorHandler.logError(e, context: 'Product.fromJson in getFeed');
              return null;
            }
          })
          .whereType<Product>() // Filter out nulls
          .toList();
      
      // Shuffle products for diverse brand mix (only for initial load)
      if (offset == 0 && products.isNotEmpty) {
        products.shuffle();
        print('🎲 Shuffled ${products.length} products for brand diversity');
      }

      // 3. Cache only initial batch (first 10 products)
      if (offset == 0 && products.isNotEmpty) {
        await cache.cacheFeed(cacheKey, products);
        print('💾 Cached initial ${products.length} products');
      } else {
        print('⏭️ Skipping cache for offset $offset (progressive loading)');
      }

      return products;
    } catch (e) {
      // 4. Fallback to stale cache on network error
      ErrorHandler.logError(e, context: 'getFeed');
      print('❌ Network error: $e - Trying stale cache');
      final staleCache = await cache.getStaleFeed(cacheKey);
      if (staleCache != null && staleCache.isNotEmpty) {
        print('⚠️ Returning stale cache: ${staleCache.length} products');
        return staleCache;
      }
      throw Exception(ErrorHandler.handleError(e, context: 'loading feed'));
    }
  }

  /// Prefetch next batch of products (background operation) - Progressive loading
  Future<void> prefetchNextBatch({
    required String userId,
    List<String>? styleFilters,
    String? category,
    int offset = 10,
  }) async {
    try {
      // Silent prefetch - fetch next 5 products
      await getFeed(
        userId: userId,
        styleFilters: styleFilters,
        category: category,
        offset: offset,
        limit: 5, // Fetch 5 products at a time
        forceRefresh: false,
      );
      print('🔮 Prefetched next 5 products (offset: $offset)');
    } catch (e) {
      print('⚠️ Prefetch failed (non-critical): $e');
    }
  }

  /// Get discovery section (trending, new arrivals, flash sales) - CACHED
  Future<Map<String, List<Product>>> getDiscoverySection({
    bool forceRefresh = false,
  }) async {
    final cache = await _cacheService;

    // 1. Try cache first
    if (!forceRefresh) {
      final cached = await cache.getDiscovery();
      if (cached != null) {
        print('📦 Discovery cache HIT');
        return cached;
      }
    }

    // 2. Fetch from network
    try {
      print('🌐 Discovery cache MISS: Fetching from Supabase');

      // Fetch trending products (parallel)
      final trendingFuture = _client
          .from('products')
          .select()
          .eq('is_trending', true)
          .limit(10);

      // Fetch new arrivals (parallel)
      final newArrivalsFuture = _client
          .from('products')
          .select()
          .eq('is_new_arrival', true)
          .order('created_at', ascending: false)
          .limit(10);

      // Fetch flash sales (parallel)
      final flashSalesFuture = _client
          .from('products')
          .select()
          .eq('is_flash_sale', true)
          .eq('is_in_stock', true)
          .limit(10);

      // Execute in parallel
      final results = await Future.wait([
        trendingFuture,
        newArrivalsFuture,
        flashSalesFuture,
      ]);

      final trending = (results[0] as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final newArrivals = (results[1] as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final flashSales = (results[2] as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      // 3. Cache the results
      await cache.cacheDiscovery(trending, newArrivals, flashSales);
      print('💾 Cached discovery section');

      return {
        'trending': trending,
        'newArrivals': newArrivals,
        'flashSales': flashSales,
      };
    } catch (e) {
      // 4. Fallback to stale cache
      ErrorHandler.logError(e, context: 'getDiscoverySection');
      print('❌ Discovery fetch error: $e - Trying cache');
      final staleCache = await cache.getDiscovery();
      if (staleCache != null) {
        print('⚠️ Returning stale discovery cache');
        return staleCache;
      }
      throw Exception(ErrorHandler.handleError(e, context: 'loading discovery'));
    }
  }

  /// Get products by brand
  Future<List<Product>> getProductsByBrand({
    required String brand,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('brand', brand)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ErrorHandler.logError(e, context: 'getProductsByBrand');
      throw Exception(ErrorHandler.handleError(e, context: 'loading brand products'));
    }
  }

  /// Get products by style tags
 Future<List<Product>> getProductsByStyle({
    required List<String> styleTags,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .overlaps('style_tags', styleTags)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ErrorHandler.logError(e, context: 'getProductsByStyle');
      throw Exception(ErrorHandler.handleError(e, context: 'loading style products'));
    }
  }

  /// Get trending products
  Future<List<Product>> getTrendingProducts({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('is_trending', true)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ErrorHandler.logError(e, context: 'getTrendingProducts');
      throw Exception(ErrorHandler.handleError(e, context: 'loading trending products'));
    }
  }

  /// Get new arrival products
  Future<List<Product>> getNewArrivalProducts({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('is_new_arrival', true)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ErrorHandler.logError(e, context: 'getNewArrivalProducts');
      throw Exception(ErrorHandler.handleError(e, context: 'loading new arrivals'));
    }
  }

  /// Get flash sale products
  Future<List<Product>> getFlashSaleProducts({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('is_flash_sale', true)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      ErrorHandler.logError(e, context: 'getFlashSaleProducts');
      throw Exception(ErrorHandler.handleError(e, context: 'loading flash sales'));
    }
  }
}
