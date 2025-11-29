import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

/// Swirl Repository
/// Handles liked items (Swirls) - SWIRL's unique engagement metric
/// Aligned with PRD v1.0
class SwirlRepository {
  final SupabaseClient _client;

  SwirlRepository(this._client);

  /// Add a product to Swirls (like/save)
  /// Handles duplicate key errors gracefully - returns existing swirl if already exists
  Future<Swirl> addSwirl({
    required String userId,
    required String productId,
    required ItemSource source,
  }) async {
    try {
      // First check if swirl already exists
      final existing = await _client
          .from('swirls')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      // If it exists, return it instead of throwing error
      if (existing != null) {
        return Swirl.fromJson(existing as Map<String, dynamic>);
      }

      // Otherwise, insert new swirl
      final response = await _client
          .from('swirls')
          .insert({
            'user_id': userId,
            'product_id': productId,
            'source': source.value,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to insert swirl - no response');
      }

      return Swirl.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      // If it's a duplicate key error, try to fetch the existing swirl
      if (e.toString().contains('duplicate key') || e.toString().contains('23505')) {
        try {
          final existing = await _client
              .from('swirls')
              .select()
              .eq('user_id', userId)
              .eq('product_id', productId)
              .maybeSingle();
          
          if (existing != null) {
            return Swirl.fromJson(existing as Map<String, dynamic>);
          }
          // If we still can't get it, rethrow original error
          throw Exception('Failed to add swirl: $e');
        } catch (_) {
          throw Exception('Failed to add swirl: $e');
        }
      }
      throw Exception('Failed to add swirl: $e');
    }
  }

  /// Remove a product from Swirls
  Future<void> removeSwirl({
    required String userId,
    required String productId,
  }) async {
    try {
      await _client
          .from('swirls')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      throw Exception('Failed to remove swirl: $e');
    }
  }

  /// Get all Swirls for a user (with product data)
  Future<List<Swirl>> getUserSwirls({
    required String userId,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('swirls')
          .select('*, product:products(*)')
          .eq('user_id', userId)
          .range(offset, offset + limit - 1)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        // Parse with populated product data
        final swirlData = Map<String, dynamic>.from(json as Map);
        final productData = swirlData.remove('product');

        if (productData != null) {
          swirlData['product'] = productData;
        }

        return Swirl.fromJson(swirlData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch swirls: $e');
    }
  }

  /// Check if a product is in Swirls
  Future<bool> isSwirled({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _client
          .from('swirls')
          .select('id')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Get Swirl count for user
  Future<int> getSwirlCount(String userId) async {
    try {
      final response = await _client
          .from('swirls')
          .select('id')
          .eq('user_id', userId)
          .count();

      // Return the count
      return response.count;
    } catch (e) {
      return 0;
    }
  }

  /// Get recent Swirls
  Future<List<Swirl>> getRecentSwirls({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final response = await _client
          .from('swirls')
          .select('*, product:products(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List).map((json) {
        final swirlData = Map<String, dynamic>.from(json as Map);
        final productData = swirlData.remove('product');

        if (productData != null) {
          swirlData['product'] = productData;
        }

        return Swirl.fromJson(swirlData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent swirls: $e');
    }
  }

  /// Get Swirls by source
  Future<List<Swirl>> getSwirlsBySource({
    required String userId,
    required ItemSource source,
    int limit = 100,
  }) async {
    try {
      final response = await _client
          .from('swirls')
          .select('*, product:products(*)')
          .eq('user_id', userId)
          .eq('source', source.value)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List).map((json) {
        final swirlData = Map<String, dynamic>.from(json as Map);
        final productData = swirlData.remove('product');

        if (productData != null) {
          swirlData['product'] = productData;
        }

        return Swirl.fromJson(swirlData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch swirls by source: $e');
    }
  }

  /// Get Swirls by category (for analytics)
  Future<Map<String, int>> getSwirlsByCategory(String userId) async {
    try {
      final swirls = await getUserSwirls(userId: userId, limit: 1000);

      final categoryCount = <String, int>{};

      for (final swirl in swirls) {
        if (swirl.product != null) {
          final category = swirl.product!.category;
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;
        }
      }

      return categoryCount;
    } catch (e) {
      throw Exception('Failed to get swirls by category: $e');
    }
  }

  /// Get Swirls by brand (for analytics)
  Future<Map<String, int>> getSwirlsByBrand(String userId) async {
    try {
      final swirls = await getUserSwirls(userId: userId, limit: 1000);

      final brandCount = <String, int>{};

      for (final swirl in swirls) {
        if (swirl.product != null) {
          final brand = swirl.product!.brand;
          brandCount[brand] = (brandCount[brand] ?? 0) + 1;
        }
      }

      return brandCount;
    } catch (e) {
      throw Exception('Failed to get swirls by brand: $e');
    }
  }

  /// Toggle swirl (add if not exists, remove if exists)
  Future<bool> toggleSwirl({
    required String userId,
    required String productId,
    required ItemSource source,
  }) async {
    try {
      final isCurrentlySwirled = await isSwirled(
        userId: userId,
        productId: productId,
      );

      if (isCurrentlySwirled) {
        await removeSwirl(userId: userId, productId: productId);
        return false; // Removed
      } else {
        await addSwirl(
          userId: userId,
          productId: productId,
          source: source,
        );
        return true; // Added
      }
    } catch (e) {
      throw Exception('Failed to toggle swirl: $e');
    }
  }
}
