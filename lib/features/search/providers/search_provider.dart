import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/product_repository.dart';

/// Search State
class SearchState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  final String? category;
  final int totalResults;

  const SearchState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery,
    this.category,
    this.totalResults = 0,
  });

  SearchState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? category,
    int? totalResults,
  }) {
    return SearchState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      totalResults: totalResults ?? this.totalResults,
    );
  }
}

/// Search Notifier with debouncing
class SearchNotifier extends StateNotifier<SearchState> {
  final ProductRepository _productRepo;
  Timer? _debounceTimer;
  
  // Debounce duration (500ms is optimal for search)
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  SearchNotifier({
    required ProductRepository productRepo,
  })  : _productRepo = productRepo,
        super(const SearchState());

  @override
  void dispose() {
    // Clean up timer to prevent memory leaks
    _debounceTimer?.cancel();
    _debounceTimer = null;
    super.dispose();
  }

  /// Search products with debouncing to prevent API spam
  Future<void> searchProducts(String query) async {
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();
    
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    // Update state immediately to show user is typing
    state = state.copyWith(isLoading: true, error: null, searchQuery: query);

    // Debounce the actual search
    _debounceTimer = Timer(_debounceDuration, () async {
      await _performSearch(query);
    });
  }

  /// Internal method to perform the actual search
  Future<void> _performSearch(String query) async {
    if (!mounted) return;

    try {
      final products = await _productRepo.searchProducts(
        query: query,
        category: state.category,
        limit: 50,
      );

      if (mounted) {
        state = state.copyWith(
          products: products,
          isLoading: false,
          totalResults: products.length,
          error: null,
        );
      }
    } catch (e) {
      // Error boundary: Handle search errors gracefully
      ErrorHandler.logError(e, context: '_performSearch');
      
      if (mounted) {
        final errorMessage = ErrorHandler.handleError(e, context: 'searching products');
        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
        );
      }
    }
  }

  /// Update category filter
  Future<void> updateCategory(String? category) async {
    state = state.copyWith(category: category);

    if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
      await searchProducts(state.searchQuery!);
    }
  }

  /// Get products by category (for initial load)
  Future<void> getProductsByCategory(String category) async {
    if (!mounted) return;
    
    state = state.copyWith(isLoading: true, error: null, category: category);

    try {
      final products = await _productRepo.getProducts(
        category: category,
        limit: 50,
      );

      if (mounted) {
        state = state.copyWith(
          products: products,
          isLoading: false,
          totalResults: products.length,
          error: null,
        );
      }
    } catch (e) {
      // Error boundary: Handle category fetch errors
      ErrorHandler.logError(e, context: 'getProductsByCategory');
      
      if (mounted) {
        final errorMessage = ErrorHandler.handleError(e, context: 'fetching category products');
        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
        );
      }
    }
  }

  /// Clear search and cancel any pending debounced searches
  void clearSearch() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    state = const SearchState();
  }
}

/// Providers
/// Using centralized providers from core/providers/app_providers.dart

// Search provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final productRepo = ref.watch(productRepositoryProvider);

  return SearchNotifier(
    productRepo: productRepo,
  );
});