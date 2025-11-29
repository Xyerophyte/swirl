import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/models.dart';
import '../../../core/utils/accessibility_announcer.dart';
import '../../../core/services/image_precache_service.dart';

/// Product Card Widget
/// Displays a single product in the swipe feed
/// Aligned with UI.png design
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // Calculate card height - make it bigger while maintaining safe clearance
    // Bottom nav: 67px + 14px margin + SafeArea = ~95-100px from bottom
    final cardHeight = screenSize.height - 100; // Bigger cards with safe clearance

    // Build accessibility label
    final accessibilityLabel = A11yLabels.productCard(
      productName: product.name,
      brand: product.brand,
      price: product.formattedPrice,
      originalPrice: product.hasDiscount ? product.formattedOriginalPrice : null,
      rating: product.rating > 0 ? product.rating : null,
      reviewCount: product.reviewCount > 0 ? product.reviewCount : null,
      badge: product.badgeText,
    );

    return Semantics(
      label: accessibilityLabel,
      button: true,
      enabled: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Product Image
              _buildProductImage(),

              // Gradient Overlay
              _buildGradientOverlay(),

              // Product Info
              _buildProductInfo(context),

              // Badge (if any)
              if (product.badgeText != null) _buildBadge(),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return CachedNetworkImage(
      imageUrl: product.bestImageUrl,
      fit: BoxFit.cover,
      // Memory cache optimization - reduce memory footprint
      memCacheHeight: 800,
      memCacheWidth: 600,
      // Disk cache optimization - faster subsequent loads
      maxHeightDiskCache: 800,
      maxWidthDiskCache: 600,
      // INSTANT MODE: Beautiful color placeholder - NO LOADING SPINNER
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              product.placeholderColor,
              product.placeholderColor.withOpacity(0.7),
            ],
          ),
        ),
        // NO loading indicator - just a beautiful gradient
      ),
      // Minimal error widget - no text, just icon
      errorWidget: (context, url, error) => Container(
        color: product.placeholderColor,
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.black26,
          ),
        ),
      ),
      // INSTANT appearance - no fade animation
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Name - With overflow protection
              Text(
                product.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.1, // Reduced line height
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const SizedBox(height: 3), // Reduced spacing

              // Brand - With overflow protection
              Text(
                product.brand,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6), // Reduced spacing

            // Price Row - Fully protected against overflow
            Row(
              children: [
                // Current Price
                Flexible(
                  child: Text(
                    product.formattedPrice,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),

                // Original Price and Discount (flexible to prevent overflow)
                if (product.hasDiscount)
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            product.formattedOriginalPrice!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '-${product.discountPercentage}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9, // Reduced from 10
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // Rating - With overflow protection
            if (product.rating > 0) ...[
              const SizedBox(height: 4), // Reduced spacing
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFFFFA000),
                    size: 11, // Slightly smaller icon
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: _getBadgeColor(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          product.badgeText!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11, // Reduced from 14
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getBadgeColor() {
    if (product.isFlashSale) return const Color(0xFFFF6B6B);
    if (product.isTrending) return const Color(0xFF4CAF50);
    if (product.isNewArrival) return const Color(0xFF2196F3);
    return Colors.black87;
  }
}
