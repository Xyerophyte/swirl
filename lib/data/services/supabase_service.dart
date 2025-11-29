import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

/// Supabase Service
/// Handles all Supabase backend interactions
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Fetch all products with optional filters
  Future<List<Product>> fetchProducts({
    String? category,
    bool? isTrending,
    bool? isNewArrival,
    bool? isFlashSale,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      var query = _client.from('products').select();

      // Apply filters
      if (category != null) {
        query = query.eq('category', category);
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
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Fetch a single product by ID
  Future<Product?> fetchProductById(String id) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('id', id)
          .single();

      return Product.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  /// Search products by name or brand
  Future<List<Product>> searchProducts(String query, {int limit = 20}) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .or('name.ilike.%$query%,brand.ilike.%$query%')
          .limit(limit);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  /// Log user interaction (like, skip, view)
  Future<void> logInteraction({
    required String userId,
    required String productId,
    required String interactionType, // 'like', 'skip', 'view', 'detail_view'
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _client.from('user_interactions').insert({
        'user_id': userId,
        'product_id': productId,
        'interaction_type': interactionType,
        'metadata': metadata,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Log but don't throw - analytics shouldn't break the app
      print('Failed to log interaction: $e');
    }
  }

  /// Add product to wishlist
  Future<void> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      await _client.from('wishlist').upsert({
        'user_id': userId,
        'product_id': productId,
        'added_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      await _client
          .from('wishlist')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  /// Fetch wishlist for user
  Future<List<Product>> fetchWishlist(String userId) async {
    try {
      final response = await _client
          .from('wishlist')
          .select('product_id, products(*)')
          .eq('user_id', userId);

      return (response as List)
          .map((item) =>
              Product.fromJson(item['products'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch wishlist: $e');
    }
  }

  /// Check if product is in wishlist
  Future<bool> isInWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _client
          .from('wishlist')
          .select('id')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Add product to cart
  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
    String? selectedSize,
    String? selectedColor,
  }) async {
    try {
      await _client.from('cart').upsert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
        'selected_size': selectedSize,
        'selected_color': selectedColor,
        'added_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  /// Update cart item quantity
  Future<void> updateCartQuantity({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    try {
      await _client
          .from('cart')
          .update({'quantity': quantity})
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      throw Exception('Failed to update cart: $e');
    }
  }

  /// Remove product from cart
  Future<void> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    try {
      await _client
          .from('cart')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  /// Fetch cart for user
  Future<List<Map<String, dynamic>>> fetchCart(String userId) async {
    try {
      final response = await _client
          .from('cart')
          .select('*, products(*)')
          .eq('user_id', userId);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  /// Clear entire cart
  Future<void> clearCart(String userId) async {
    try {
      await _client.from('cart').delete().eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  /// Get recommended products based on user interactions
  /// This is a simple rule-based recommendation for now
  Future<List<Product>> getRecommendations({
    required String userId,
    int limit = 20,
  }) async {
    try {
      // Fetch user's liked categories and brands
      final interactions = await _client
          .from('user_interactions')
          .select('product_id, products(category, brand)')
          .eq('user_id', userId)
          .eq('interaction_type', 'like')
          .limit(50);

      // Extract categories and brands
      final categories = <String>{};
      final brands = <String>{};

      for (final item in interactions as List) {
        final product = item['products'];
        if (product != null) {
          categories.add(product['category'] as String);
          brands.add(product['brand'] as String);
        }
      }

      // Fetch products from liked categories and brands
      if (categories.isEmpty && brands.isEmpty) {
        // No interactions yet, return trending products
        return fetchProducts(isTrending: true, limit: limit);
      }

      var query = _client.from('products').select();

      // Build OR condition for categories and brands
      final orConditions = <String>[];
      for (final category in categories) {
        orConditions.add('category.eq.$category');
      }
      for (final brand in brands) {
        orConditions.add('brand.eq.$brand');
      }

      if (orConditions.isNotEmpty) {
        query = query.or(orConditions.join(','));
      }

      final response = await query.limit(limit);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to trending products
      return fetchProducts(isTrending: true, limit: limit);
    }
  }
}