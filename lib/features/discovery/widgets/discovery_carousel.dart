import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../data/models/models.dart';
import '../../detail/screens/detail_view.dart';

/// Discovery Carousel Widget
/// Displays trending, new arrivals, and flash sales in horizontal scrollable sections
class DiscoveryCarousel extends StatelessWidget {
  final List<Product>? trending;
  final List<Product>? newArrivals;
  final List<Product>? flashSales;
  final VoidCallback? onRefresh;
  final bool isLoading;

  const DiscoveryCarousel({
    super.key,
    this.trending,
    this.newArrivals,
    this.flashSales,
    this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (trending == null && newArrivals == null && flashSales == null) {
      return const SizedBox.shrink();
    }

    return Container(
      color: SwirlColors.background,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with refresh button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: SwirlColors.textPrimary,
                        ),
                  ),
                  if (onRefresh != null)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: SwirlColors.primary),
                      onPressed: onRefresh,
                      tooltip: 'Refresh discoveries',
                    ),
                ],
              ),
            ),

            // Flash Sales Section (if available)
            if (flashSales != null && flashSales!.isNotEmpty) ...[
              _DiscoverySection(
                title: 'Flash Sales 🔥',
                subtitle: 'Limited time offers',
                products: flashSales!,
                badgeColor: SwirlColors.error,
                badgeText: 'SALE',
              ),
              const SizedBox(height: 16),
            ],

            // Trending Section (if available)
            if (trending != null && trending!.isNotEmpty) ...[
              _DiscoverySection(
                title: 'Trending Now 📈',
                subtitle: 'What everyone\'s loving',
                products: trending!,
                badgeColor: SwirlColors.success,
                badgeText: 'HOT',
              ),
              const SizedBox(height: 16),
            ],

            // New Arrivals Section (if available)
            if (newArrivals != null && newArrivals!.isNotEmpty) ...[
              _DiscoverySection(
                title: 'New Arrivals ✨',
                subtitle: 'Fresh drops',
                products: newArrivals!,
                badgeColor: SwirlColors.primary,
                badgeText: 'NEW',
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Discovery Section Widget
/// Horizontal scrollable list of products with section header
class _DiscoverySection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Product> products;
  final Color badgeColor;
  final String badgeText;

  const _DiscoverySection({
    required this.title,
    required this.subtitle,
    required this.products,
    required this.badgeColor,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SwirlColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: SwirlColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Product List
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _ProductCard(
                product: products[index],
                badgeColor: badgeColor,
                badgeText: badgeText,
                isFirst: index == 0,
                isLast: index == products.length - 1,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Product Card Widget
/// Individual product card in the carousel
class _ProductCard extends StatelessWidget {
  final Product product;
  final Color badgeColor;
  final String badgeText;
  final bool isFirst;
  final bool isLast;

  const _ProductCard({
    required this.product,
    required this.badgeColor,
    required this.badgeText,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProductDetail(context),
      child: Container(
        width: 160,
        margin: EdgeInsets.only(
          right: isLast ? 0 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Badge
            Stack(
              children: [
                // Image Container
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: SwirlColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: SwirlColors.surface,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: SwirlColors.surface,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 48,
                          color: SwirlColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Discount Badge (if applicable)
                if (product.hasDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${product.discountPercentage}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Brand Name
            Text(
              product.brand,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: SwirlColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            // Product Name
            Text(
              product.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SwirlColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Price
            Row(
              children: [
                Text(
                  product.formattedPrice,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: SwirlColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (product.hasDiscount) ...[
                  const SizedBox(width: 6),
                  Text(
                    product.formattedOriginalPrice ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: SwirlColors.textTertiary,
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                    child: DetailView(product: product),
                  ),
                ),
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ));

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}