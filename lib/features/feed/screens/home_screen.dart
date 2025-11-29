import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/constants/app_constants.dart' hide SwipeDirection;
import '../../../core/services/image_precache_service.dart';
import '../../../data/models/models.dart';
import '../../home/providers/feed_provider.dart';
import '../../home/widgets/card_stack.dart';
import '../../home/widgets/style_filter_chips.dart';
import '../../detail/screens/detail_view.dart';
import '../../weekly_outfits/presentation/widgets/weekly_outfit_banner.dart';
import '../../weekly_outfits/presentation/weekly_outfits_screen.dart';

/// Home Screen - Main feed interface
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ImagePrecacheService _imagePrecache = ImagePrecacheService();
  int _lastPrecachedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);

    // INSTANT MODE: Set context in provider for aggressive precaching
    ref.read(feedProvider.notifier).setContext(context);

    // Precache images for next 10 cards whenever products change
    if (feedState.products.isNotEmpty && _lastPrecachedIndex != feedState.currentIndex) {
      _precacheUpcomingImages(feedState.products, feedState.currentIndex);
      _lastPrecachedIndex = feedState.currentIndex;
    }

    return Scaffold(
      backgroundColor: SwirlColors.background,
      body: SafeArea(
        child: feedState.error != null
            ? _buildErrorState(feedState.error!)
            : feedState.products.isEmpty && !feedState.isInitialLoad
                ? _buildEmptyState()
                : Stack(
                    children: [
                      // Card Stack (always show, even during initial load)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 80,
                          bottom: 16,
                        ),
                        child: feedState.products.isEmpty
                            ? Container() // Empty during initial load (no spinner)
                            : CardStack(
                                products: feedState.products,
                                currentIndex: feedState.currentIndex,
                                onSwipe: (direction, product, dwellMs) {
                                  // Handle down swipe specially (show detail drawer without removing card)
                                  if (direction == SwipeDirection.down) {
                                    _showDetailDrawer(product);
                                    // Don't call handleSwipe - card stays in feed
                                  } else {
                                    // Track other swipes (right = like, up = skip)
                                    ref.read(feedProvider.notifier).handleSwipe(
                                          direction: direction,
                                          product: product,
                                          dwellMs: dwellMs,
                                        );
                                  }
                                },
                                onNeedMore: () {
                                  // Background loading handled automatically
                                },
                              ),
                      ),

                      // Top Bar with Logo and Action Buttons
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Undo Button (Left)
                            _ActionButton(
                              icon: Icons.undo,
                              onTap: feedState.canUndo
                                  ? () {
                                      ref.read(feedProvider.notifier).undoSwipe();
                                    }
                                  : null,
                              isEnabled: feedState.canUndo,
                            ),
                            
                            // SWIRL Logo (Center)
                            Image.asset(
                              'assets/images/inverted_LOGO.png',
                              height: AppConstants.iconSizeXxl,  // 40px - larger and dynamic
                              fit: BoxFit.contain,
                            ),
                            
                            // Filter Button (Right)
                            _ActionButton(
                              icon: Icons.tune,
                              onTap: () {
                                _showComprehensiveFilters(context);
                              },
                              isEnabled: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppConstants.iconSizeXxxl,
            color: SwirlColors.error,
          ),
          VSpace.md,
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          VSpace.sm,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXl),
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SwirlColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          VSpace.lg,
          ElevatedButton(
            onPressed: () {
              ref.read(feedProvider.notifier).loadInitialFeed();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: AppConstants.iconSizeXxxl,
            color: SwirlColors.textTertiary,
          ),
          VSpace.md,
          Text(
            'No products available',
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          VSpace.sm,
          Text(
            'Check back soon for new arrivals!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: SwirlColors.textSecondary,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showComprehensiveFilters(BuildContext context) {
    final currentFilters = ref.read(feedProvider).activeStyleFilters;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(AppConstants.spacingLg),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: SwirlColors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Clear all filters
                            for (final style in currentFilters) {
                              ref.read(feedProvider.notifier).toggleStyleFilter(style);
                            }
                          },
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              color: SwirlColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(AppConstants.spacingLg),
                  children: [
                    // Gender Section
                    _FilterSection(
                      title: 'Gender',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterChip(label: 'All', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Men', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Women', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Unisex', isSelected: false, onTap: () {}),
                        ],
                      ),
                    ),
                    
                    VSpace.lg,

                    // Style Section
                    _FilterSection(
                      title: 'Style',
                      child: StyleFilterChips(
                        selectedStyles: currentFilters,
                        onSelectionChanged: (selectedStyles) {
                          // Update filters
                          for (final style in selectedStyles) {
                            if (!currentFilters.contains(style)) {
                              ref.read(feedProvider.notifier).toggleStyleFilter(style);
                            }
                          }
                          for (final style in currentFilters) {
                            if (!selectedStyles.contains(style)) {
                              ref.read(feedProvider.notifier).toggleStyleFilter(style);
                            }
                          }
                        },
                        showLabel: false,
                      ),
                    ),
                    
                    VSpace.lg,

                    // Category Section
                    _FilterSection(
                      title: 'Category',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterChip(label: 'Tops', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Bottoms', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Dresses', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Outerwear', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Shoes', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Accessories', isSelected: false, onTap: () {}),
                        ],
                      ),
                    ),
                    
                    VSpace.lg,

                    // Price Range Section
                    _FilterSection(
                      title: 'Price Range',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FilterChip(label: 'Under \$50', isSelected: false, onTap: () {}),
                              _FilterChip(label: '\$50 - \$100', isSelected: false, onTap: () {}),
                              _FilterChip(label: '\$100 - \$200', isSelected: false, onTap: () {}),
                              _FilterChip(label: 'Over \$200', isSelected: false, onTap: () {}),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    VSpace.lg,

                    // Special Filters Section
                    _FilterSection(
                      title: 'Special',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterChip(label: 'On Sale', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'New Arrivals', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Trending', isSelected: false, onTap: () {}),
                          _FilterChip(label: 'Sustainable', isSelected: false, onTap: () {}),
                        ],
                      ),
                    ),
                    
                    VSpace.xxl,
                  ],
                ),
              ),

              // Apply Button
              Container(
                padding: EdgeInsets.all(AppConstants.spacingLg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SwirlColors.primary,
                      padding: EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Precache images for next 10 cards
  void _precacheUpcomingImages(List<Product> products, int currentIndex) {
    // Precache images in background (fire and forget)
    _imagePrecache.precacheInBackground(
      context: context,
      products: products,
      startIndex: currentIndex,
      count: 10,
    );
  }

  void _showDetailDrawer(Product product) {
    // Use custom page route for top-to-bottom slide animation
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Transparent background
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
          // Smooth slide from top animation
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.0, -1.0), // Start from top (off-screen)
            end: Offset.zero, // End at normal position
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic, // Smooth deceleration
            reverseCurve: Curves.easeInCubic, // Smooth acceleration when closing
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

/// Action Button Widget (for Undo button)
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: AppConstants.buttonSquareSize,
        height: AppConstants.buttonSquareSize,
        decoration: BoxDecoration(
          color: isEnabled ? SwirlColors.surface : SwirlColors.surface.withOpacity(0.5),
          shape: BoxShape.circle,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isEnabled ? SwirlColors.textPrimary : SwirlColors.textTertiary,
          size: AppConstants.iconSizeLg,
        ),
      ),
    );
  }
}

/// Filter Section Widget
class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SwirlColors.textPrimary,
              ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

/// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? SwirlColors.primary : SwirlColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? SwirlColors.primary : SwirlColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : SwirlColors.textPrimary,
          ),
        ),
      ),
    );
  }
}