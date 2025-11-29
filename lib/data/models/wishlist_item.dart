import 'product.dart';

/// Wishlist Item Model
/// Represents an item saved to user's wishlist
class WishlistItem {
  final String id;
  final String userId;
  final String productId;
  final DateTime createdAt;

  // Optional: Populated product data (when fetched with join)
  final Product? product;

  const WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
    this.product,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
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
      'created_at': createdAt.toIso8601String(),
      if (product != null) 'product': product!.toJson(),
    };
  }

  /// Get time since added (for display)
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

  WishlistItem copyWith({
    String? id,
    String? userId,
    String? productId,
    DateTime? createdAt,
    Product? product,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      createdAt: createdAt ?? this.createdAt,
      product: product ?? this.product,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WishlistItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WishlistItem(id: $id, productId: $productId)';
}
