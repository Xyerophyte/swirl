import 'product.dart';

/// Swirl Model
/// Represents a liked/saved item (SWIRL's unique metric)
/// Aligned with PRD v1.0 schema
class Swirl {
  final String id;
  final String userId;
  final String productId;

  // Swirl metadata
  final String? source; // 'swipe_right', 'swipe_down', 'double_tap', 'detail_view'
  final DateTime createdAt;

  // Optional: Populated product data (when fetched with join)
  final Product? product;

  const Swirl({
    required this.id,
    required this.userId,
    required this.productId,
    this.source,
    required this.createdAt,
    this.product,
  });

  factory Swirl.fromJson(Map<String, dynamic> json) {
    return Swirl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      source: json['source'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'source': source,
      'created_at': createdAt.toIso8601String(),
      if (product != null) 'product': product!.toJson(),
    };
  }

  /// Helper getters

  /// Check if swirl was from right swipe (primary action)
  bool get wasFromRightSwipe => source == 'swipe_right';

  /// Check if swirl was from quick wishlist (down swipe)
  bool get wasFromQuickWishlist => source == 'swipe_down';

  /// Check if swirl was from double tap
  bool get wasFromDoubleTap => source == 'double_tap';

  /// Check if swirl was from detail view
  bool get wasFromDetailView => source == 'detail_view';

  /// Get time since swirl (for display)
  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Copy with method for immutability
  Swirl copyWith({
    String? id,
    String? userId,
    String? productId,
    String? source,
    DateTime? createdAt,
    Product? product,
  }) {
    return Swirl(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      product: product ?? this.product,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Swirl && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Swirl(id: $id, productId: $productId, source: $source, createdAt: $createdAt)';
}
