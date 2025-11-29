import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../services/logging_service.dart';

/// Accessibility Announcer
/// Provides screen reader announcements and accessibility utilities
/// Supports TalkBack (Android) and VoiceOver (iOS)
class AccessibilityAnnouncer {
  /// Announce a message to screen readers
  /// 
  /// [message] - The text to announce
  /// [assertiveness] - How urgently to announce (polite or assertive)
  static void announce(
    BuildContext context,
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) {
    try {
      SemanticsService.announce(
        message,
        assertiveness == Assertiveness.assertive
            ? TextDirection.ltr
            : TextDirection.ltr,
      );
      
      logger.debug(
        'Accessibility announcement: $message',
        context: 'AccessibilityAnnouncer',
      );
    } catch (e, stackTrace) {
      logger.error(
        'Failed to make accessibility announcement',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Announce a product interaction
  static void announceProductAction(
    BuildContext context,
    String productName,
    ProductAction action,
  ) {
    final message = _getProductActionMessage(productName, action);
    announce(
      context,
      message,
      assertiveness: action == ProductAction.like
          ? Assertiveness.polite
          : Assertiveness.polite,
    );
  }

  /// Announce navigation change
  static void announceNavigation(
    BuildContext context,
    String screenName,
  ) {
    announce(
      context,
      'Navigated to $screenName',
      assertiveness: Assertiveness.polite,
    );
  }

  /// Announce loading state
  static void announceLoading(
    BuildContext context,
    bool isLoading, {
    String? customMessage,
  }) {
    final message = customMessage ?? (isLoading ? 'Loading' : 'Loading complete');
    announce(
      context,
      message,
      assertiveness: Assertiveness.polite,
    );
  }

  /// Announce error
  static void announceError(
    BuildContext context,
    String errorMessage,
  ) {
    announce(
      context,
      'Error: $errorMessage',
      assertiveness: Assertiveness.assertive,
    );
  }

  /// Get product action message
  static String _getProductActionMessage(String productName, ProductAction action) {
    switch (action) {
      case ProductAction.like:
        return 'Added $productName to likes';
      case ProductAction.skip:
        return 'Skipped $productName';
      case ProductAction.wishlist:
        return 'Added $productName to wishlist';
      case ProductAction.details:
        return 'Viewing details for $productName';
    }
  }
}

/// Assertiveness level for announcements
enum Assertiveness {
  /// Polite announcements (queued)
  polite,
  
  /// Assertive announcements (interrupt current speech)
  assertive,
}

/// Product action types
enum ProductAction {
  like,
  skip,
  wishlist,
  details,
}

/// Accessibility label builder
class A11yLabels {
  /// Product card label
  static String productCard({
    required String productName,
    required String brand,
    required String price,
    String? originalPrice,
    double? rating,
    int? reviewCount,
    String? badge,
  }) {
    final buffer = StringBuffer();
    
    buffer.write('$productName by $brand. ');
    
    if (originalPrice != null) {
      buffer.write('Sale price $price, was $originalPrice. ');
    } else {
      buffer.write('Price $price. ');
    }
    
    if (rating != null && rating > 0) {
      buffer.write('Rating ${rating.toStringAsFixed(1)} stars');
      if (reviewCount != null) {
        buffer.write(' from $reviewCount reviews');
      }
      buffer.write('. ');
    }
    
    if (badge != null) {
      buffer.write('$badge. ');
    }
    
    buffer.write('Swipe right to like, swipe up to skip, swipe down for details');
    
    return buffer.toString().trim();
  }

  /// Navigation button label
  static String navButton({
    required String screenName,
    required bool isSelected,
  }) {
    return '$screenName${isSelected ? ', selected' : ''}';
  }

  /// Action button label
  static String actionButton({
    required String action,
    String? itemName,
  }) {
    if (itemName != null) {
      return '$action $itemName';
    }
    return action;
  }

  /// Search field label
  static String searchField({
    required String hint,
    String? currentValue,
  }) {
    if (currentValue != null && currentValue.isNotEmpty) {
      return 'Search for products, current value: $currentValue';
    }
    return 'Search for products, $hint';
  }

  /// Filter chip label
  static String filterChip({
    required String filterName,
    required bool isSelected,
  }) {
    return '$filterName${isSelected ? ', selected' : ''}, double tap to ${isSelected ? 'deselect' : 'select'}';
  }

  /// Loading indicator label
  static String loading({
    String? customMessage,
  }) {
    return customMessage ?? 'Loading, please wait';
  }

  /// Error message label
  static String error({
    required String message,
    bool hasRetry = false,
  }) {
    if (hasRetry) {
      return 'Error: $message. Double tap to retry.';
    }
    return 'Error: $message';
  }

  /// Empty state label
  static String emptyState({
    required String message,
    bool hasAction = false,
  }) {
    if (hasAction) {
      return '$message. Double tap for more options.';
    }
    return message;
  }
}