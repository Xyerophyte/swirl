import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

/// Swipe Repository
/// Handles swipe tracking and analytics
class SwipeRepository {
  final SupabaseClient _client;

  SwipeRepository(this._client);

  /// Track a swipe interaction
  /// Silent failure - doesn't break app if tracking fails
  Future<void> trackSwipe({
    required String userId,
    required Product product,
    required SwipeDirection direction,
    required SwipeAction action,
    String? sessionId,
    int? dwellMs,
    int? cardPosition,
    bool? isRepeatView,
    List<String>? activeStyleFilters,
 }) async {
    try {
      await _client.from('swipes').insert({
        'user_id': userId,
        'product_id': product.id,
        'direction': _getDirectionString(direction),
        'swipe_action': _getActionString(action),
        'session_id': sessionId,
        'dwell_ms': dwellMs,
        'card_position': cardPosition,
        'is_repeat_view': isRepeatView,
        'price': product.price,
        'currency': product.currency,
        'brand': product.brand,
        'category': product.category,
        'subcategory': product.subcategory,
        'style_tags': product.styleTags,
        'active_style_filters': activeStyleFilters,
        'time_of_day': DateTime.now().hour,
        'day_of_week': DateTime.now().weekday,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Silent fail - analytics shouldn't break the app
      print('Failed to track swipe: $e');
    }
  }

 /// Get user's swipe history
  Future<List<Swipe>> getUserSwipes({
    required String userId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _client
          .from('swipes')
          .select()
          .eq('user_id', userId)
          .range(offset, offset + limit - 1)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Swipe.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user swipes: $e');
    }
  }

  /// Get swipe analytics for a user
  Future<Map<String, dynamic>> getUserSwipeAnalytics(String userId) async {
    try {
      // Get total swipes
      final totalSwipesResponse = await _client
          .from('swipes')
          .select('id')
          .eq('user_id', userId)
          .count();

      // Get like rate
      final likeSwipesResponse = await _client
          .from('swipes')
          .select('id')
          .eq('user_id', userId)
          .eq('swipe_action', 'like')
          .count();

      // Get top categories
      final topCategoriesResponse = await _client
          .from('swipes')
          .select('category, count(*)')
          .eq('user_id', userId)
          .order('count', ascending: false)
          .limit(5);

      // Get top brands
      final topBrandsResponse = await _client
          .from('swipes')
          .select('brand, count(*)')
          .eq('user_id', userId)
          .order('count', ascending: false)
          .limit(5);

      return {
        'total_swipes': totalSwipesResponse.count,
        'like_count': likeSwipesResponse.count,
        'like_rate': totalSwipesResponse.count > 0
            ? likeSwipesResponse.count / totalSwipesResponse.count
            : 0,
        'top_categories': topCategoriesResponse,
        'top_brands': topBrandsResponse,
      };
    } catch (e) {
      throw Exception('Failed to get swipe analytics: $e');
    }
  }

 /// Get swipes by direction
  Future<List<Swipe>> getSwipesByDirection({
    required String userId,
    required SwipeDirection direction,
    int limit = 50,
  }) async {
    try {
      final response = await _client
          .from('swipes')
          .select()
          .eq('user_id', userId)
          .eq('direction', _getDirectionString(direction))
          .limit(limit)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Swipe.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get swipes by direction: $e');
    }
  }

 /// Get swipes by action
  Future<List<Swipe>> getSwipesByAction({
    required String userId,
    required SwipeAction action,
    int limit = 50,
  }) async {
    try {
      final response = await _client
          .from('swipes')
          .select()
          .eq('user_id', userId)
          .eq('swipe_action', _getActionString(action))
          .limit(limit)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Swipe.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get swipes by action: $e');
    }
  }

 /// Helper methods to convert enums to strings
  String _getDirectionString(SwipeDirection direction) {
    switch (direction) {
      case SwipeDirection.right:
        return 'right';
      case SwipeDirection.left:
        return 'left';
      case SwipeDirection.up:
        return 'up';
      case SwipeDirection.down:
        return 'down';
      default:
        return 'none';
    }
  }

  String _getActionString(SwipeAction action) {
    switch (action) {
      case SwipeAction.like:
        return 'like';
      case SwipeAction.detailsView:
        return 'details_view';
      case SwipeAction.skip:
        return 'skip';
      case SwipeAction.wishlist:
        return 'wishlist';
      default:
        return 'none';
    }
  }
}
