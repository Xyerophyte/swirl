import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/theme/swirl_typography.dart';
import '../../../data/models/models.dart';
import '../providers/wishlist_provider.dart';

/// Wishlist Screen - Grid of saved items
/// Shows all items the user has saved to wishlist
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: SwirlColors.background,
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: SwirlTypography.detailTitle.copyWith(
            color: SwirlColors.textPrimary,
          ),
        ),
        backgroundColor: SwirlColors.surface,
        foregroundColor: SwirlColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (wishlistState.items.isNotEmpty)
            IconButton(
              onPressed: () {
                // TODO: Add sorting/filtering options
              },
              icon: const Icon(Icons.filter_list),
            ),
        ],
      ),
      body: SafeArea(
        child: wishlistState.isLoading
            ? const _LoadingState()
            : wishlistState.error != null
                ? _ErrorState(error: wishlistState.error!)
                : wishlistState.items.isEmpty
                    ? const _EmptyState()
                    : _WishlistGrid(wishlistItems: wishlistState.items),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(SwirlColors.primary),
      ),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: SwirlColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SwirlColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Retry loading wishlist
              ref.read(wishlistProvider.notifier).loadWishlist();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SwirlColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: SwirlColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: SwirlColors.border,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.bookmark_border,
              size: 64,
              color: SwirlColors.textTertiary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Your Wishlist is Empty',
            style: SwirlTypography.detailTitle.copyWith(
              color: SwirlColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Save items to your wishlist by swiping down on any product card or using the bookmark icon in detail view.',
              style: SwirlTypography.bodyMedium.copyWith(
                color: SwirlColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to home screen (index 0 in bottom nav)
              DefaultTabController.of(context).animateTo(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SwirlColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Start Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistGrid extends StatelessWidget {
  final List<WishlistItem> wishlistItems;

  const _WishlistGrid({required this.wishlistItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Slightly taller than square
        ),
        itemCount: wishlistItems.length,
        itemBuilder: (context, index) {
          final item = wishlistItems[index];
          return _WishlistCard(wishlistItem: item);
        },
      ),
    );
  }
}

class _WishlistCard extends ConsumerWidget {
  final WishlistItem wishlistItem;

  const _WishlistCard({required this.wishlistItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = wishlistItem;
    final product = item.product!;
    
    return Container(
      decoration: BoxDecoration(
        color: SwirlColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  child: Image.network(
                    product.bestImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Product Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand
                      Text(
                        product.brand,
                        style: SwirlTypography.bodySmall.copyWith(
                          color: SwirlColors.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Product Name
                      Text(
                        product.name,
                        style: SwirlTypography.bodyMedium.copyWith(
                          color: SwirlColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Price
                      Row(
                        children: [
                          Text(
                            product.formattedPrice,
                            style: SwirlTypography.price.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.hasDiscount) ...[
                            const SizedBox(width: 8),
                            Text(
                              product.formattedOriginalPrice!,
                              style: SwirlTypography.priceOriginal.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Wishlist indicator
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark,
                  color: SwirlColors.accent,
                  size: 16,
                ),
              ),
            ),
            // Remove button
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: () {
                  // Remove from wishlist
                  ref.read(wishlistProvider.notifier).removeFromWishlist(item.productId);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: SwirlColors.textPrimary,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}