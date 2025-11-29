import 'product.dart';

/// Cart Item Model
/// Represents an item in user's shopping cart
class CartItem {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optional: Populated product data (when fetched with join)
  final Product? product;

  const CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      quantity: json['quantity'] as int? ?? 1,
      selectedSize: json['selected_size'] as String?,
      selectedColor: json['selected_color'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
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
      'quantity': quantity,
      'selected_size': selectedSize,
      'selected_color': selectedColor,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (product != null) 'product': product!.toJson(),
    };
  }

  /// Calculate total price for this cart item
  double get totalPrice {
    if (product == null) return 0.0;
    return product!.price * quantity;
  }

  /// Check if item has all required selections
  bool get hasCompleteSelection {
    if (product == null) return false;
    
    final needsSize = product!.sizes.isNotEmpty;
    final needsColor = product!.colors.isNotEmpty;
    
    if (needsSize && selectedSize == null) return false;
    if (needsColor && selectedColor == null) return false;
    
    return true;
  }

  CartItem copyWith({
    String? id,
    String? userId,
    String? productId,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
    DateTime? createdAt,
    DateTime? updatedAt,
    Product? product,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      product: product ?? this.product,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CartItem(id: $id, productId: $productId, quantity: $quantity)';
}