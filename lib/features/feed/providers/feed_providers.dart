import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/product.dart';
import '../../../data/services/supabase_service.dart';

/// Provider for Supabase service
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(Supabase.instance.client);
});

/// State class for feed
class FeedState {
  final List<Product> items;
  final bool isLoading;
  final String? error;
  final int currentIndex;

  const FeedState({
    required this.items,
    required this.isLoading,
    this.error,
    required this.currentIndex,
  });

  FeedState copyWith({
    List<Product>? items,
    bool? isLoading,
    String? error,
    int? currentIndex,
  }) {
    return FeedState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

/// Feed provider - manages the infinite product feed
final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  return FeedNotifier(ref.read(supabaseServiceProvider));
});

class FeedNotifier extends StateNotifier<FeedState> {
  final SupabaseService _supabaseService;
  
  FeedNotifier(this._supabaseService)
      : super(const FeedState(
          items: [],
          isLoading: false,
          currentIndex: 0,
        ));

  /// Load initial feed
  Future<void> loadInitialFeed() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final products = await _supabaseService.fetchProducts(limit: 20);
      state = state.copyWith(
        items: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load more products when getting close to the end
  Future<void> loadMore() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true);
    
    try {
      final newProducts = await _supabaseService.fetchProducts(
        limit: 20,
        offset: state.items.length,
      );
      
      state = state.copyWith(
        items: [...state.items, ...newProducts],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Move to next item
  void moveToNext() {
    if (state.currentIndex < state.items.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      
      // Load more when reaching 75% of loaded items
      if (state.currentIndex >= state.items.length * 0.75) {
        loadMore();
      }
    }
  }

  /// Inject a surprise item at current position
  void injectSurprise(Product surpriseProduct) {
    final newItems = List<Product>.from(state.items);
    newItems.insert(state.currentIndex + 1, surpriseProduct);
    state = state.copyWith(items: newItems);
  }

  /// Get current product
  Product? get currentProduct {
    if (state.currentIndex < state.items.length) {
      return state.items[state.currentIndex];
    }
    return null;
  }

  /// Get next products for preloading
  List<Product> getNextProducts(int count) {
    final endIndex = (state.currentIndex + 1 + count).clamp(0, state.items.length);
    return state.items.sublist(state.currentIndex + 1, endIndex);
  }
}

/// Provider for wishlist items
final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<String>>((ref) {
  return WishlistNotifier(ref.read(supabaseServiceProvider));
});

class WishlistNotifier extends StateNotifier<List<String>> {
  final SupabaseService _supabaseService;
  
  WishlistNotifier(this._supabaseService) : super([]);

  /// Load wishlist for current user
  Future<void> loadWishlist(String userId) async {
    try {
      final products = await _supabaseService.fetchWishlist(userId);
      state = products.map((p) => p.id).toList();
    } catch (e) {
      print('Failed to load wishlist: $e');
    }
  }

  /// Add product to wishlist
  Future<void> addToWishlist(String userId, String productId) async {
    try {
      await _supabaseService.addToWishlist(
        userId: userId,
        productId: productId,
      );
      state = [...state, productId];
    } catch (e) {
      print('Failed to add to wishlist: $e');
    }
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String userId, String productId) async {
    try {
      await _supabaseService.removeFromWishlist(
        userId: userId,
        productId: productId,
      );
      state = state.where((id) => id != productId).toList();
    } catch (e) {
      print('Failed to remove from wishlist: $e');
    }
  }

  /// Toggle wishlist status
  Future<void> toggleWishlist(String userId, String productId) async {
    if (state.contains(productId)) {
      await removeFromWishlist(userId, productId);
    } else {
      await addToWishlist(userId, productId);
    }
  }

  /// Check if product is in wishlist
  bool isInWishlist(String productId) {
    return state.contains(productId);
  }
}

/// Provider for analytics tracking
final analyticsProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref.read(supabaseServiceProvider));
});

class AnalyticsService {
  final SupabaseService _supabaseService;
  
  AnalyticsService(this._supabaseService);

  /// Log swipe interaction
  Future<void> logSwipe({
    required String userId,
    required String productId,
    required String direction, // 'right' (like), 'left' (detail), 'up' (skip)
  }) async {
    final interactionType = direction == 'right' ? 'like' : 'skip';
    
    await _supabaseService.logInteraction(
      userId: userId,
      productId: productId,
      interactionType: interactionType,
      metadata: {'swipe_direction': direction},
    );
  }

  /// Log detail view
  Future<void> logDetailView({
    required String userId,
    required String productId,
  }) async {
    await _supabaseService.logInteraction(
      userId: userId,
      productId: productId,
      interactionType: 'detail_view',
    );
  }

  /// Log session duration
  Future<void> logSession({
    required String userId,
    required Duration duration,
    required int swipeCount,
    required int likeCount,
  }) async {
    await _supabaseService.logInteraction(
      userId: userId,
      productId: 'session',
      interactionType: 'session_end',
      metadata: {
        'duration_seconds': duration.inSeconds,
        'swipe_count': swipeCount,
        'like_count': likeCount,
      },
    );
  }
}

/// Provider for current user ID (placeholder - will be implemented with auth)
final currentUserIdProvider = Provider<String>((ref) {
  // TODO: Replace with actual user authentication
  return 'demo-user-${DateTime.now().millisecondsSinceEpoch}';
});