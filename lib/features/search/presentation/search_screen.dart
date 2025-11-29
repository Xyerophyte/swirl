import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/swirl_colors.dart';
import '../../../core/theme/swirl_typography.dart';
import '../../../data/models/models.dart';
import '../providers/search_provider.dart';
import '../../detail/screens/detail_view.dart';

/// Discover Screen - Curated collections of trending products with functional search
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  bool _isSearching = false;

  // Mock data for discover page
  static final List<Product> _mockProducts = [
    Product(
      id: 'mock-1',
      externalId: 'MOCK1',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Classic White Sneakers',
      brand: 'Nike',
      description: 'Clean and versatile white sneakers perfect for any outfit',
      price: 120.00,
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      category: 'shoes',
    ),
    Product(
      id: 'mock-2',
      externalId: 'MOCK2',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Denim Jacket',
      brand: 'Levi\'s',
      description: 'Classic denim jacket with timeless style',
      price: 89.99,
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
      category: 'outerwear',
    ),
    Product(
      id: 'mock-3',
      externalId: 'MOCK3',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Black Hoodie',
      brand: 'Adidas',
      description: 'Comfortable black hoodie for everyday wear',
      price: 65.00,
      originalPrice: 85.00,
      imageUrl: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400',
      category: 'tops',
    ),
    Product(
      id: 'mock-4',
      externalId: 'MOCK4',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Slim Fit Jeans',
      brand: 'H&M',
      description: 'Modern slim fit jeans in classic blue',
      price: 49.99,
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400',
      category: 'men',
    ),
    Product(
      id: 'mock-5',
      externalId: 'MOCK5',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Summer Dress',
      brand: 'Zara',
      description: 'Light and breezy summer dress',
      price: 79.99,
      imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
      category: 'women',
    ),
    Product(
      id: 'mock-6',
      externalId: 'MOCK6',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Leather Boots',
      brand: 'Dr. Martens',
      description: 'Durable leather boots built to last',
      price: 160.00,
      imageUrl: 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=400',
      category: 'shoes',
    ),
    Product(
      id: 'mock-7',
      externalId: 'MOCK7',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Graphic T-Shirt',
      brand: 'Supreme',
      description: 'Bold graphic tee with street style',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
      category: 'tops',
    ),
    Product(
      id: 'mock-8',
      externalId: 'MOCK8',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Wool Coat',
      brand: 'Burberry',
      description: 'Elegant wool coat for formal occasions',
      price: 350.00,
      originalPrice: 450.00,
      imageUrl: 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=400',
      category: 'outerwear',
    ),
    Product(
      id: 'mock-9',
      externalId: 'MOCK9',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Running Shoes',
      brand: 'Adidas',
      description: 'Performance running shoes for athletes',
      price: 95.00,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      category: 'shoes',
    ),
    Product(
      id: 'mock-10',
      externalId: 'MOCK10',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Crossbody Bag',
      brand: 'Coach',
      description: 'Stylish crossbody bag for everyday use',
      price: 195.00,
      imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=400',
      category: 'accessories',
    ),
    Product(
      id: 'mock-11',
      externalId: 'MOCK11',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Casual Blazer',
      brand: 'Hugo Boss',
      description: 'Smart casual blazer for any occasion',
      price: 245.00,
      imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400',
      category: 'outerwear',
    ),
    Product(
      id: 'mock-12',
      externalId: 'MOCK12',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Sports Watch',
      brand: 'Casio',
      description: 'Reliable sports watch with multiple features',
      price: 75.00,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      category: 'accessories',
    ),
    Product(
      id: 'mock-13',
      externalId: 'MOCK13',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Yoga Pants',
      brand: 'Lululemon',
      description: 'Comfortable yoga pants for active lifestyle',
      price: 88.00,
      imageUrl: 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=400',
      category: 'bottoms',
    ),
    Product(
      id: 'mock-14',
      externalId: 'MOCK14',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Polo Shirt',
      brand: 'Ralph Lauren',
      description: 'Classic polo shirt in premium cotton',
      price: 89.50,
      imageUrl: 'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=400',
      category: 'tops',
    ),
    Product(
      id: 'mock-15',
      externalId: 'MOCK15',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Sunglasses',
      brand: 'Ray-Ban',
      description: 'Iconic sunglasses with UV protection',
      price: 150.00,
      originalPrice: 180.00,
      imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400',
      category: 'accessories',
    ),
    Product(
      id: 'mock-16',
      externalId: 'MOCK16',
      sourceStore: 'unsplash',
      sourceUrl: 'https://unsplash.com',
      name: 'Maxi Skirt',
      brand: 'Free People',
      description: 'Flowing maxi skirt for summer',
      price: 68.00,
      imageUrl: 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=400',
      category: 'bottoms',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _mockProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredProducts = _mockProducts;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredProducts = _mockProducts.where((product) {
          return product.name.toLowerCase().contains(lowerQuery) ||
              product.brand.toLowerCase().contains(lowerQuery) ||
              product.category.toLowerCase().contains(lowerQuery) ||
              (product.description?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwirlColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: SwirlColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore curated collections',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: SwirlColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Search Bar
                    _SearchBar(
                      controller: _searchController,
                      onChanged: _performSearch,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Show search results or curated collections
            if (_isSearching) ...[
              if (_filteredProducts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        child: Text(
                          'Search Results (${_filteredProducts.length})',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _ProductCard(product: _filteredProducts[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
            ] else ...[
              // Trending Products
              _CategorySection(
                title: 'Trending Products',
                products: _mockProducts.take(4).toList(),
              ),

              // New Arrivals
              _CategorySection(
                title: 'New Arrivals',
                products: _mockProducts.skip(4).take(4).toList(),
              ),

              // Bestsellers
              _CategorySection(
                title: 'Bestsellers',
                products: _mockProducts.skip(8).take(4).toList(),
              ),

              // On Sale
              _CategorySection(
                title: 'On Sale',
                products: _mockProducts.where((p) => p.hasDiscount).take(4).toList(),
              ),

              // Premium Collection
              _CategorySection(
                title: 'Premium Collection',
                products: [_mockProducts[10], _mockProducts[7], _mockProducts[9], _mockProducts[5]],
              ),

              // Street Style
              _CategorySection(
                title: 'Street Style',
                products: [_mockProducts[6], _mockProducts[2], _mockProducts[0], _mockProducts[1]],
              ),

              // Sustainable Fashion
              _CategorySection(
                title: 'Sustainable Fashion',
                products: [_mockProducts[4], _mockProducts[12], _mockProducts[15], _mockProducts[13]],
              ),

              // Minimal Wardrobe
              _CategorySection(
                title: 'Minimal Wardrobe',
                products: [_mockProducts[0], _mockProducts[3], _mockProducts[13], _mockProducts[6]],
              ),

              // Summer Essentials
              _CategorySection(
                title: 'Summer Essentials',
                products: [_mockProducts[4], _mockProducts[14], _mockProducts[12], _mockProducts[0]],
              ),

              // Office Wear
              _CategorySection(
                title: 'Office Wear',
                products: [_mockProducts[10], _mockProducts[13], _mockProducts[3], _mockProducts[7]],
              ),

              // Casual Comfort
              _CategorySection(
                title: 'Casual Comfort',
                products: [_mockProducts[2], _mockProducts[6], _mockProducts[12], _mockProducts[3]],
              ),

              // Evening Elegance
              _CategorySection(
                title: 'Evening Elegance',
                products: [_mockProducts[7], _mockProducts[4], _mockProducts[10], _mockProducts[9]],
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ],
        ),
      ),
    );
  }
}

void _showDetailDrawer(BuildContext context, Product product) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, -10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: DetailView(product: product),
                ),
              ),
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}

/// Search Bar Widget with functional search
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search for products, brands...',
        hintStyle: SwirlTypography.bodyMedium.copyWith(
          color: SwirlColors.textTertiary,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: SwirlColors.textTertiary,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: SwirlColors.textTertiary),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: SwirlColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: SwirlColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: SwirlColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: SwirlColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

/// Category Section with title and product grid
class _CategorySection extends StatelessWidget {
  final String title;
  final List<Product> products;

  const _CategorySection({
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SwirlColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Product Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _ProductCard(product: products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product Card Widget
class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDetailDrawer(context, product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: SwirlColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                child: Stack(
                  children: [
                    Image.network(
                      product.bestImageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    if (product.hasDiscount)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: SwirlColors.error,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'SALE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Product Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    Text(
                      product.brand,
                      style: SwirlTypography.bodySmall.copyWith(
                        color: SwirlColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Product Name
                    Text(
                      product.name,
                      style: SwirlTypography.bodyMedium.copyWith(
                        color: SwirlColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Price
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            product.formattedPrice,
                            style: SwirlTypography.price.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              product.formattedOriginalPrice!,
                              style: SwirlTypography.priceOriginal.copyWith(
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}