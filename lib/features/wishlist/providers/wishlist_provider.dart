import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/wishlist_repository.dart';

/// Wishlist State
class WishlistState {
  final List<WishlistItem> items;
  final bool isLoading;
  final String? error;
  final int totalItems;

  const WishlistState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.totalItems = 0,
  });

  WishlistState copyWith({
    List<WishlistItem>? items,
    bool? isLoading,
    String? error,
    int? totalItems,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

/// Wishlist Notifier
class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistRepository _wishlistRepo;
  final String _userId;

  WishlistNotifier({
    required WishlistRepository wishlistRepo,
    required String userId,
  })  : _wishlistRepo = wishlistRepo,
        _userId = userId,
        super(const WishlistState()) {
    loadWishlist();
  }

  /// Load user's wishlist
  Future<void> loadWishlist() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await _wishlistRepo.getUserWishlist(
        userId: _userId,
        limit: 100, // Load first 100 items
      );

      final count = await _wishlistRepo.getWishlistCount(_userId);

      state = state.copyWith(
        items: items,
        isLoading: false,
        totalItems: count,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Add item to wishlist
  Future<void> addToWishlist(String productId) async {
    try {
      await _wishlistRepo.addToWishlist(
        userId: _userId,
        productId: productId,
      );

      // Reload wishlist to get updated data
      await loadWishlist();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Remove item from wishlist
  Future<void> removeFromWishlist(String productId) async {
    try {
      await _wishlistRepo.removeFromWishlist(
        userId: _userId,
        productId: productId,
      );

      // Update state by removing the item
      final updatedItems = state.items
          .where((item) => item.product?.id != productId)
          .toList();

      state = state.copyWith(
        items: updatedItems,
        totalItems: state.totalItems - 1,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Toggle wishlist (add/remove)
  Future<void> toggleWishlist(String productId) async {
    try {
      final isAdded = await _wishlistRepo.toggleWishlist(
        userId: _userId,
        productId: productId,
      );

      if (isAdded) {
        // If added, reload to get the new item with product data
        await loadWishlist();
      } else {
        // If removed, update state directly
        final updatedItems = state.items
            .where((item) => item.product?.id != productId)
            .toList();

        state = state.copyWith(
          items: updatedItems,
          totalItems: state.totalItems - 1,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Check if product is in wishlist
  bool isInWishlist(String productId) {
    return state.items.any((item) => item.product?.id == productId);
  }
}

/// Providers
/// Using centralized providers from core/providers/app_providers.dart

// Wishlist provider
final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  final wishlistRepo = ref.watch(wishlistRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  return WishlistNotifier(
    wishlistRepo: wishlistRepo,
    userId: userId,
  );
});