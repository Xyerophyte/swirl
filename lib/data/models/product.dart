/// Product Model
/// Represents a fashion item in the SWIRL catalog
/// Updated to match PRD v1.0 schema
class Product {
  final String id;

  // Source data (Amazon API or other stores)
  final String externalId; // Amazon ASIN, Noon SKU, etc.
  final String sourceStore; // 'amazon', 'noon', 'namshi'
  final String sourceUrl; // Link to product on store

  // Basic info
  final String name;
  final String brand;
  final String description;

  // Pricing
  final double price;
  final double? originalPrice;
  final String currency; // 'AED' default
  final int discountPercentage;

  // Classification
  final String category; // 'men', 'women', 'unisex', 'accessories', 'shoes'
  final String? subcategory; // 'shirts', 'pants', 'dresses', etc.
  final List<String> styleTags; // ['minimalist', 'urban_vibe', 'streetwear_edge', 'avant_garde']

  // Product details
  final List<String> sizes;
  final List<String> colors;
  final String? materials;
  final String? careInstructions;

  // Images
  final String imageUrl; // Primary image (original or CDN)
  final List<String> additionalImages;
  final String? cdnPrimaryImage; // Our CDN mirror
  final String? cdnThumbnail; // 150x150
  final String? cdnMedium; // 400x400

  // Quality metrics
  final double rating;
  final int reviewCount;

  // Flags
  final bool isTrending;
  final bool isNewArrival;
  final bool isFlashSale;
  final bool isInStock;
  final int stockCount;

  // Metadata
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSyncedAt;

  const Product({
    required this.id,
    required this.externalId,
    required this.sourceStore,
    required this.sourceUrl,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    this.originalPrice,
    this.currency = 'AED',
    this.discountPercentage = 0,
    required this.category,
    this.subcategory,
    this.styleTags = const [],
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.colors = const ['Black', 'White'],
    this.materials,
    this.careInstructions,
    required this.imageUrl,
    this.additionalImages = const [],
    this.cdnPrimaryImage,
    this.cdnThumbnail,
    this.cdnMedium,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isTrending = false,
    this.isNewArrival = false,
    this.isFlashSale = false,
    this.isInStock = true,
    this.stockCount = 100,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.lastSyncedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      externalId: json['external_id'] as String,
      sourceStore: json['source_store'] as String? ?? 'amazon',
      sourceUrl: json['source_url'] as String? ?? '',
      name: json['name'] as String,
      brand: json['brand'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      currency: json['currency'] as String? ?? 'AED',
      discountPercentage: json['discount_percentage'] as int? ?? 0,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      styleTags: json['style_tags'] != null
          ? List<String>.from(json['style_tags'] as List)
          : const [],
      sizes: json['sizes'] != null
          ? List<String>.from(json['sizes'] as List)
          : const ['S', 'M', 'L', 'XL'],
      colors: json['colors'] != null
          ? List<String>.from(json['colors'] as List)
          : const ['Black', 'White'],
      materials: json['materials'] as String?,
      careInstructions: json['care_instructions'] as String?,
      imageUrl: json['primary_image_url'] as String? ?? json['image_url'] as String,
      additionalImages: json['additional_images'] != null
          ? List<String>.from(json['additional_images'] as List)
          : const [],
      cdnPrimaryImage: json['cdn_primary_image'] as String?,
      cdnThumbnail: json['cdn_thumbnail'] as String?,
      cdnMedium: json['cdn_medium'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isTrending: json['is_trending'] as bool? ?? false,
      isNewArrival: json['is_new_arrival'] as bool? ?? false,
      isFlashSale: json['is_flash_sale'] as bool? ?? false,
      isInStock: json['is_in_stock'] as bool? ?? true,
      stockCount: json['stock_count'] as int? ?? 100,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'external_id': externalId,
      'source_store': sourceStore,
      'source_url': sourceUrl,
      'name': name,
      'brand': brand,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'currency': currency,
      'discount_percentage': discountPercentage,
      'category': category,
      'subcategory': subcategory,
      'style_tags': styleTags,
      'sizes': sizes,
      'colors': colors,
      'materials': materials,
      'care_instructions': careInstructions,
      'primary_image_url': imageUrl,
      'additional_images': additionalImages,
      'cdn_primary_image': cdnPrimaryImage,
      'cdn_thumbnail': cdnThumbnail,
      'cdn_medium': cdnMedium,
      'rating': rating,
      'review_count': reviewCount,
      'is_trending': isTrending,
      'is_new_arrival': isNewArrival,
      'is_flash_sale': isFlashSale,
      'is_in_stock': isInStock,
      'stock_count': stockCount,
      'metadata': metadata,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
    };
  }

  /// Helper getters

  /// Check if product has discount
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Get discount amount
  double get discountAmount => hasDiscount ? originalPrice! - price : 0;

  /// Check if product is in stock
  bool get inStock => isInStock && stockCount > 0;

  /// Get badge text if any
  String? get badgeText {
    if (isFlashSale) return 'Flash Sale 🔥';
    if (isTrending) return 'Trending 📈';
    if (isNewArrival) return 'New Arrival ✨';
    if (metadata?['badge'] != null) return metadata!['badge'] as String;
    return null;
  }

  /// Get formatted price with currency
  String get formattedPrice => '$currency $price';

  /// Get formatted original price with currency
  String? get formattedOriginalPrice =>
      originalPrice != null ? '$currency $originalPrice' : null;

  /// Get best available image URL (prefer CDN, fallback to original)
  String get bestImageUrl => cdnPrimaryImage ?? cdnMedium ?? imageUrl;

  /// Get thumbnail URL (prefer CDN, fallback to original)
  String get thumbnailUrl => cdnThumbnail ?? cdnMedium ?? imageUrl;

  /// Check if product has style tag
  bool hasStyleTag(String tag) => styleTags.contains(tag);

  /// Check if product matches any of the given style tags
  bool matchesAnyStyleTag(List<String> tags) =>
      tags.any((tag) => styleTags.contains(tag));

  /// Copy with method for immutability
  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? description,
    double? price,
    double? originalPrice,
    String? category,
    String? subcategory,
    List<String>? sizes,
    List<String>? colors,
    String? materials,
    String? imageUrl,
    List<String>? additionalImages,
    double? rating,
    int? reviewCount,
    bool? isTrending,
    bool? isNewArrival,
    bool? isFlashSale,
    int? discountPercentage,
    int? stockCount,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      externalId: this.externalId,
      sourceStore: this.sourceStore,
      sourceUrl: this.sourceUrl,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      materials: materials ?? this.materials,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isTrending: isTrending ?? this.isTrending,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isFlashSale: isFlashSale ?? this.isFlashSale,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      stockCount: stockCount ?? this.stockCount,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Product(id: $id, name: $name, brand: $brand, price: $price)';
}