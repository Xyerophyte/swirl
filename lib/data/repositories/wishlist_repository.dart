import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

/// Wishlist Repository
/// Handles wishlist operations
class WishlistRepository {
  final SupabaseClient _client;

  WishlistRepository(this._client);

  /// Add a product to wishlist
  Future<WishlistItem> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _client
          .from('wishlist')
          .insert({
            'user_id': userId,
            'product_id': productId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to add to wishlist - no response');
      }

      return WishlistItem.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
 }

  /// Remove a product from wishlist
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

  /// Get all wishlist items for a user (with product data)
  Future<List<WishlistItem>> getUserWishlist({
    required String userId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('wishlist')
          .select('*, product:products(*)')
          .eq('user_id', userId)
          .range(offset, offset + limit - 1)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        // Parse with populated product data
        final wishlistData = Map<String, dynamic>.from(json as Map);
        final productData = wishlistData.remove('product');

        if (productData != null) {
          wishlistData['product'] = productData;
        }

        return WishlistItem.fromJson(wishlistData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch wishlist: $e');
    }
  }

  /// Check if a product is in wishlist
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

  /// Get wishlist count for user
  Future<int> getWishlistCount(String userId) async {
    try {
      final response = await _client
          .from('wishlist')
          .select('id')
          .eq('user_id', userId)
          .count();

      // Return the count
      return response.count;
    } catch (e) {
      return 0;
    }
  }

  /// Get recent wishlist items
  Future<List<WishlistItem>> getRecentWishlistItems({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final response = await _client
          .from('wishlist')
          .select('*, product:products(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List).map((json) {
        final wishlistData = Map<String, dynamic>.from(json as Map);
        final productData = wishlistData.remove('product');

        if (productData != null) {
          wishlistData['product'] = productData;
        }

        return WishlistItem.fromJson(wishlistData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent wishlist items: $e');
    }
  }

  /// Toggle wishlist (add if not exists, remove if exists)
  Future<bool> toggleWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final isCurrentlyInWishlist = await isInWishlist(
        userId: userId,
        productId: productId,
      );

      if (isCurrentlyInWishlist) {
        await removeFromWishlist(userId: userId, productId: productId);
        return false; // Removed
      } else {
        await addToWishlist(
          userId: userId,
          productId: productId,
        );
        return true; // Added
      }
    } catch (e) {
      throw Exception('Failed to toggle wishlist: $e');
    }
  }
}