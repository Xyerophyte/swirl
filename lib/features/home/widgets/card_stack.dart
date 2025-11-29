import 'package:flutter/material.dart';
import '../../../data/models/models.dart';
import '../../../core/services/logging_service.dart';
import 'product_card.dart';
import 'swipeable_card.dart';

/// Card Stack Widget
/// Manages the stack of swipeable cards with preloading
/// Shows current + 2 behind (3 total visible)
/// Aligned with PRD v1.0 preloading strategy
class CardStack extends StatefulWidget {
  final List<Product> products;
  final int currentIndex;
  final Function(SwipeDirection direction, Product product, int dwellMs)? onSwipe;
  final VoidCallback? onNeedMore; // Trigger when approaching end

  const CardStack({
    super.key,
    required this.products,
    this.currentIndex = 0,
    this.onSwipe,
    this.onNeedMore,
  });

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack>
    with TickerProviderStateMixin {
  late int _currentIndex;
  late DateTime _cardViewStartTime;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _cardViewStartTime = DateTime.now();
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _currentIndex = widget.currentIndex;
      _cardViewStartTime = DateTime.now();
    }
  }

  void _handleSwipe(SwipeDirection direction) {
    if (_currentIndex >= widget.products.length) return;

    // Calculate dwell time (time spent viewing card)
    final dwellMs = DateTime.now().difference(_cardViewStartTime).inMilliseconds;

    // Get current product
    final product = widget.products[_currentIndex];

    // Notify parent
    widget.onSwipe?.call(direction, product, dwellMs);

    // Move to next card
    setState(() {
      _currentIndex++;
      _cardViewStartTime = DateTime.now();
    });

    // Preload more silently in background when approaching end
    final remaining = widget.products.length - _currentIndex;
    if (remaining <= 10) {
      widget.onNeedMore?.call();
    }
  }

  List<Widget> _buildCardStack() {
    final List<Widget> cards = [];

    // Show 2 cards for instant transitions: current + next
    final visibleCount = 2;

    try {
      for (int i = 0; i < visibleCount; i++) {
        final index = _currentIndex + i;

        if (index >= widget.products.length) {
          // No more cards
          break;
        }

        final product = widget.products[index];
        
        // Use RepaintBoundary to isolate repaints and improve performance
        // This prevents unnecessary repaints of cards below
        cards.insert(
          0, // Insert at beginning so they stack correctly
          RepaintBoundary(
            key: ValueKey('card_$index'),
            child: i == 0
                ? SwipeableCard(
                    key: ValueKey('swipeable_$index'),
                    onSwipeRight: () => _handleSwipe(SwipeDirection.right), // Like
                    onSwipeUp: () => _handleSwipe(SwipeDirection.up), // Skip
                    onSwipeDown: () => _handleSwipe(SwipeDirection.down), // Wishlist
                    // onSwipeLeft disabled
                    child: ProductCard(
                      key: ValueKey('product_$index'),
                      product: product,
                    ),
                  )
                : IgnorePointer(
                    child: Opacity(
                      opacity: 0.5, // Dim background card for better visual hierarchy
                      child: ProductCard(
                        key: ValueKey('product_bg_$index'),
                        product: product,
                      ),
                    ),
                  ),
          ),
        );
      }
    } catch (e, stackTrace) {
      logger.error('Error building card stack', error: e, stackTrace: stackTrace);
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're out of cards
    if (_currentIndex >= widget.products.length) {
      // Use RepaintBoundary for empty state to prevent unnecessary repaints
      return RepaintBoundary(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              'No more items!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              'Check back later for new arrivals',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        ),
      );
    }

    // Clean, seamless card stack - no loading indicators
    // Use RepaintBoundary to isolate the entire stack
    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: _buildCardStack(),
      ),
    );
  }
}
