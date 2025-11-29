import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/models.dart';

/// Detail View Screen
/// Full-screen product details modal (opened on left swipe)
/// Aligned with PRD v1.0
class DetailView extends StatefulWidget {
  final Product product;
  final ScrollController? scrollController;

  const DetailView({
    super.key,
    required this.product,
    this.scrollController,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  int _currentImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty
        ? widget.product.sizes.first
        : null;
    _selectedColor = widget.product.colors.isNotEmpty
        ? widget.product.colors.first
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Content
        CustomScrollView(
          slivers: [
            // Drag Handle at top
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Image Carousel
            SliverToBoxAdapter(
              child: _buildImageCarousel(screenHeight * 0.4),
            ),

            // Product Info
            SliverToBoxAdapter(
              child: _buildProductInfo(),
            ),
          ],
        ),

        // Close Button (top-right)
        Positioned(
          top: 16,
          right: 16,
          child: _buildCloseButton(),
        ),

        // Action Buttons (Bottom)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildActionButtons(context),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(double height) {
    final images = [
      widget.product.bestImageUrl,
      ...widget.product.additionalImages,
    ];

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 64),
                ),
              );
            },
          ),

          // Page Indicator
          if (images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentImageIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand - Protected
          Text(
            widget.product.brand,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Product Name - Protected
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Price Row - Protected against overflow
          Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                widget.product.formattedPrice,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.product.hasDiscount) ...[
                Text(
                  widget.product.formattedOriginalPrice!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '-${widget.product.discountPercentage}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Rating
          if (widget.product.rating > 0) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < widget.product.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: const Color(0xFFFFA000),
                    size: 20,
                  );
                }),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviewCount} reviews)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Size Selector
          if (widget.product.sizes.isNotEmpty) ...[
            const Text(
              'Select Size',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.product.sizes.map((size) {
                final isSelected = size == _selectedSize;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSize = size),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Color Selector
          if (widget.product.colors.isNotEmpty) ...[
            const Text(
              'Select Color',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.product.colors.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      color,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Description
          if (widget.product.description.isNotEmpty) ...[
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.product.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
              softWrap: true,
            ),
          ],

          // Materials
          if (widget.product.materials != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Materials',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.product.materials!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],

          // Care Instructions
          if (widget.product.careInstructions != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Care Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.product.careInstructions!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],

          // Bottom padding for action buttons
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.close, size: 24),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Add to Cart Button (Phase 2)
          // Expanded(
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       // Add to cart logic
          //     },
          //     icon: const Icon(Icons.shopping_bag_outlined),
          //     label: const Text('Add to Cart'),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.grey[200],
          //       foregroundColor: Colors.black,
          //       padding: const EdgeInsets.symmetric(vertical: 16),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16),
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 12),

          // Buy Now Button
          Expanded(
            child: ElevatedButton(
              onPressed: () => _launchStore(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchStore() async {
    final url = Uri.parse(widget.product.sourceUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open product page')),
        );
      }
    }
  }
}
