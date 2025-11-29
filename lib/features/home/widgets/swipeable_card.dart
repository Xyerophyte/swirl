import 'dart:math';
import 'package:flutter/material.dart';
import '../../../data/models/models.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/utils/accessibility_announcer.dart';

/// Swipeable Card Widget
/// Handles 4-direction swipe gestures (right/left/up/down)
/// Aligned with PRD v1.0 swipe mechanics
class SwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeRight; // Like
  final VoidCallback? onSwipeLeft; // Nothing (disabled)
  final VoidCallback? onSwipeUp; // Skip
  final VoidCallback? onSwipeDown; // Details Drawer
  final bool isEnabled;

  const SwipeableCard({
    super.key,
    required this.child,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onSwipeUp,
    this.onSwipeDown,
    this.isEnabled = true,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _rotationAnimation;

  Offset _dragPosition = Offset.zero;
  bool _isDragging = false;
  String? _lockedAxis; // 'horizontal' or 'vertical' - locked once direction is determined

  static const double _swipeThreshold = 0.15; // 15% of screen (easier swiping)
  static const double _velocityThreshold = 200.0; // pixels/second (lower threshold)

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!widget.isEnabled) return;
    setState(() {
      _isDragging = true;
      _lockedAxis = null; // Reset axis lock
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isEnabled) return;

    setState(() {
      final dx = _dragPosition.dx + details.delta.dx;
      final dy = _dragPosition.dy + details.delta.dy;
      
      // Lock to dominant axis on first significant movement
      if (_lockedAxis == null && (dx.abs() > 10 || dy.abs() > 10)) {
        _lockedAxis = dx.abs() > dy.abs() ? 'horizontal' : 'vertical';
      }
      
      // Apply movement based on locked axis
      if (_lockedAxis == 'horizontal') {
        _dragPosition = Offset(dx, 0); // Only horizontal movement
      } else if (_lockedAxis == 'vertical') {
        _dragPosition = Offset(0, dy); // Only vertical movement
      } else {
        // Not locked yet, track both
        _dragPosition = Offset(dx, dy);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isEnabled) return;

    final screenSize = MediaQuery.of(context).size;
    final dx = _dragPosition.dx.abs();
    final dy = _dragPosition.dy.abs();

    // Calculate velocity
    final velocity = details.velocity.pixelsPerSecond;
    final velocityX = velocity.dx.abs();
    final velocityY = velocity.dy.abs();

    // Determine swipe direction
    bool hasSwipedRight = _dragPosition.dx > 0 &&
        (dx > screenSize.width * _swipeThreshold || velocityX > _velocityThreshold);
    bool hasSwipedLeft = _dragPosition.dx < 0 &&
        (dx > screenSize.width * _swipeThreshold || velocityX > _velocityThreshold);
    bool hasSwipedUp = _dragPosition.dy < 0 &&
        (dy > screenSize.height * _swipeThreshold || velocityY > _velocityThreshold);
    bool hasSwipedDown = _dragPosition.dy > 0 &&
        (dy > screenSize.height * _swipeThreshold || velocityY > _velocityThreshold);

    // Execute appropriate callback
    if (hasSwipedRight) {
      _executeSwipe(SwipeDirection.right);
    } else if (hasSwipedLeft) {
      _executeSwipe(SwipeDirection.left);
    } else if (hasSwipedUp) {
      _executeSwipe(SwipeDirection.up);
    } else if (hasSwipedDown) {
      _executeSwipe(SwipeDirection.down);
    } else {
      // Return to center
      _resetPosition();
    }
  }

  void _executeSwipe(SwipeDirection direction) {
    // Special handling for down swipe (details) - don't animate away
    if (direction == SwipeDirection.down) {
      HapticService.mediumImpact();
      // Announce for screen readers
      AccessibilityAnnouncer.announce(
        context,
        'Opening product details',
      );
      // Reset card position immediately
      _resetPosition();
      // Execute callback (show drawer)
      widget.onSwipeDown?.call();
      return;
    }

    // Haptic feedback and announcements for other swipes
    switch (direction) {
      case SwipeDirection.right:
        HapticService.mediumImpact(); // Like
        AccessibilityAnnouncer.announce(
          context,
          'Product added to wishlist',
        );
        break;
      case SwipeDirection.up:
        HapticService.lightImpact(); // Skip
        AccessibilityAnnouncer.announce(
          context,
          'Product skipped',
        );
        break;
      case SwipeDirection.left:
        // Disabled - do nothing
        AccessibilityAnnouncer.announce(
          context,
          'Swipe left is disabled',
        );
        _resetPosition();
        return;
      default:
        break;
    }

    // Animate off-screen (for right and up)
    _animateOffScreen(direction).then((_) {
      if (!mounted) return;
      
      // Reset state immediately after animation completes
      setState(() {
        _dragPosition = Offset.zero;
        _isDragging = false;
        _lockedAxis = null;
      });

      // Execute callback
      switch (direction) {
        case SwipeDirection.right:
          widget.onSwipeRight?.call();
          break;
        case SwipeDirection.up:
          widget.onSwipeUp?.call();
          break;
        default:
          break;
      }
    });
  }

  Future<void> _animateOffScreen(SwipeDirection direction) async {
    final screenSize = MediaQuery.of(context).size;
    Offset endPosition;
    double endRotation = 0;

    switch (direction) {
      case SwipeDirection.right:
        endPosition = Offset(screenSize.width * 1.5, 0); // Keep on horizontal axis
        endRotation = 0.3;
        break;
      case SwipeDirection.left:
        endPosition = Offset(-screenSize.width * 1.5, 0); // Keep on horizontal axis
        endRotation = -0.3;
        break;
      case SwipeDirection.up:
        endPosition = Offset(0, -screenSize.height * 1.5); // Keep on vertical axis
        endRotation = 0;
        break;
      case SwipeDirection.down:
        endPosition = Offset(0, screenSize.height * 1.5); // Keep on vertical axis
        endRotation = 0;
        break;
      default:
        endPosition = Offset.zero;
    }

    _offsetAnimation = Tween<Offset>(
      begin: _dragPosition,
      end: endPosition,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: _getRotation(),
      end: endRotation,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animation and wait for completion
    await _controller.forward(from: 0);
    
    // Reset controller for next card
    _controller.reset();
  }

  void _resetPosition() {
    _offsetAnimation = Tween<Offset>(
      begin: _dragPosition,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: _getRotation(),
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _dragPosition = Offset.zero;
          _isDragging = false;
          _lockedAxis = null;
        });
      }
    });
  }

  double _getRotation() {
    const double maxRotation = 0.1; // 0.1 radians ≈ 5.7 degrees
    final screenWidth = MediaQuery.of(context).size.width;
    return ((_dragPosition.dx / screenWidth) * maxRotation).clamp(-maxRotation, maxRotation);
  }

  Color _getOverlayColor() {
    final dx = _dragPosition.dx;
    final dy = _dragPosition.dy;

    if (dx.abs() > dy.abs()) {
      // Horizontal swipe
      if (dx > 50) {
        // Right = Like (green)
        return Colors.green.withOpacity((dx / 150).clamp(0.0, 0.5));
      }
      // Left swipe disabled
    } else {
      // Vertical swipe
      if (dy > 50) {
        // Down = Details (blue)
        return Colors.blue.withOpacity((dy / 150).clamp(0.0, 0.5));
      } else if (dy < -50) {
        // Up = Skip (red)
        return Colors.red.withOpacity((dy.abs() / 150).clamp(0.0, 0.5));
      }
    }

    return Colors.transparent;
  }

  Widget _buildSwipeIndicator() {
    final dx = _dragPosition.dx;
    final dy = _dragPosition.dy;

    IconData? icon;
    String? label;
    Color? color;

    if (dx.abs() > dy.abs() && dx.abs() > 50) {
      // Horizontal swipe
      if (dx > 0) {
        icon = Icons.favorite;
        label = 'LIKE';
        color = Colors.green;
      }
      // Left swipe disabled
    } else if (dy.abs() > 50) {
      // Vertical swipe
      if (dy > 0) {
        // Down = Details
        icon = Icons.info_outline;
        label = 'DETAILS';
        color = Colors.blue;
      } else {
        // Up = Skip
        icon = Icons.close;
        label = 'SKIP';
        color = Colors.red;
      }
    }

    if (icon == null || label == null || color == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Product card',
      hint: 'Swipe right to like, swipe up to skip, swipe down for details',
      enabled: widget.isEnabled,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final offset = _controller.isAnimating
                ? _offsetAnimation.value
                : _dragPosition;
            final rotation = _controller.isAnimating
                ? _rotationAnimation.value
                : _getRotation();

            return Transform.translate(
              offset: offset,
              child: Transform.rotate(
                angle: rotation,
                child: Stack(
                  children: [
                    // Card content
                    widget.child,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
