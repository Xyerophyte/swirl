/// Brand Model
/// Represents a fashion brand in the SWIRL catalog
class Brand {
  final String id;
  final String name;
  final String? logoUrl;
  final String? description;
  final String? websiteUrl;
  final List<String> categories; // ['men', 'women', 'accessories', etc.]
  final List<String> styleTags; // Associated style tags
  final bool isVerified;
  final int productCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Brand({
    required this.id,
    required this.name,
    this.logoUrl,
    this.description,
    this.websiteUrl,
    this.categories = const [],
    this.styleTags = const [],
    this.isVerified = false,
    this.productCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      websiteUrl: json['website_url'] as String?,
      categories: json['categories'] != null
          ? List<String>.from(json['categories'] as List)
          : const [],
      styleTags: json['style_tags'] != null
          ? List<String>.from(json['style_tags'] as List)
          : const [],
      isVerified: json['is_verified'] as bool? ?? false,
      productCount: json['product_count'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'description': description,
      'website_url': websiteUrl,
      'categories': categories,
      'style_tags': styleTags,
      'is_verified': isVerified,
      'product_count': productCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Check if brand has products in specific category
  bool hasCategory(String category) => categories.contains(category);

  /// Check if brand matches style tag
  bool hasStyleTag(String tag) => styleTags.contains(tag);

  Brand copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? description,
    String? websiteUrl,
    List<String>? categories,
    List<String>? styleTags,
    bool? isVerified,
    int? productCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      categories: categories ?? this.categories,
      styleTags: styleTags ?? this.styleTags,
      isVerified: isVerified ?? this.isVerified,
      productCount: productCount ?? this.productCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Brand && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Brand(id: $id, name: $name, products: $productCount)';
}
