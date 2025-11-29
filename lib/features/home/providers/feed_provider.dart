import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/app_lifecycle_service.dart';
import '../../../core/services/image_precache_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/utils/pagination_manager.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/swipe_repository.dart';
import '../../../data/repositories/swirl_repository.dart';
import '../../onboarding/services/onboarding_service.dart';

/// Feed State
class FeedState {
  final List<Product> products;
  final String? error;
  final int currentIndex;
  final String userId;
  final List<String> activeStyleFilters;
  final bool isInitialLoad;
  final List<int> swipeHistory; // Track swipe history for undo
  
  // User preferences from onboarding
  final String? categoryFilter; // Gender preference
  final double? minPrice;
  final double? maxPrice;
  
  // Discovery section for trending/new/flash sales
  final Map<String, List<Product>>? discoverySection;
  final bool isLoadingDiscovery;

  const FeedState({
    this.products = const [],
    this.error,
    this.currentIndex = 0,
    required this.userId,
    this.activeStyleFilters = const [],
    this.isInitialLoad = true,
    this.swipeHistory = const [],
    this.categoryFilter,
    this.minPrice,
    this.maxPrice,
    this.discoverySection,
    this.isLoadingDiscovery = false,
  });

  FeedState copyWith({
    List<Product>? products,
    String? error,
    int? currentIndex,
    String? userId,
    List<String>? activeStyleFilters,
    bool? isInitialLoad,
    List<int>? swipeHistory,
    String? categoryFilter,
    double? minPrice,
    double? maxPrice,
    Map<String, List<Product>>? discoverySection,
    bool? isLoadingDiscovery,
  }) {
    return FeedState(
      products: products ?? this.products,
      error: error,
      currentIndex: currentIndex ?? this.currentIndex,
      userId: userId ?? this.userId,
      activeStyleFilters: activeStyleFilters ?? this.activeStyleFilters,
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
      swipeHistory: swipeHistory ?? this.swipeHistory,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      discoverySection: discoverySection ?? this.discoverySection,
      isLoadingDiscovery: isLoadingDiscovery ?? this.isLoadingDiscovery,
    );
  }
  
  bool get canUndo => swipeHistory.isNotEmpty;
}

/// Feed Provider with proper error boundaries and lifecycle management
class FeedNotifier extends StateNotifier<FeedState> {
  final ProductRepository _productRepo;
  final UserRepository _userRepo;
  final SwipeRepository _swipeRepo;
  final SwirlRepository _swirlRepo;
  final ImagePrecacheService _imagePrecache = ImagePrecacheService();

  String? _sessionId;
  BuildContext? _context;
  
  // Store lifecycle callback for cleanup
  VoidCallback? _resumeCallback;
  
  // Pagination manager to prevent duplicate loads
  late final PaginationManager _paginationManager;

  FeedNotifier({
    required ProductRepository productRepo,
    required UserRepository userRepo,
    required SwipeRepository swipeRepo,
    required SwirlRepository swirlRepo,
    required String initialUserId,
  })  : _productRepo = productRepo,
        _userRepo = userRepo,
        _swipeRepo = swipeRepo,
        _swirlRepo = swirlRepo,
        super(FeedState(userId: initialUserId)) {
    _paginationManager = PaginationManager(
      itemsPerPage: 5, // Progressive loading: 5 items at a time
      throttleDuration: const Duration(milliseconds: 300),
    );
    _sessionId = const Uuid().v4();
    _loadUserPreferencesAndFeed();
    _setupLifecycleHandlers();
  }

  /// Setup lifecycle handlers for background refresh
  void _setupLifecycleHandlers() {
    final lifecycleService = AppLifecycleService.instance;
    
    // Create and store the callback
    _resumeCallback = () {
      if (mounted && lifecycleService.shouldRefreshDiscovery()) {
        print('🔄 Background refresh: Updating discovery section');
        refreshDiscovery(forceRefresh: true);
        
        // If user was away for a long time, refresh feed too
        if (lifecycleService.wasInBackgroundLongTime()) {
          print('🔄 Background refresh: Updating feed (long absence)');
          loadInitialFeed();
        }
      }
    };
    
    // Register the callback
    lifecycleService.onResume(_resumeCallback!);
  }

  @override
  void dispose() {
    // Clean up lifecycle listeners to prevent memory leaks
    if (_resumeCallback != null) {
      final lifecycleService = AppLifecycleService.instance;
      lifecycleService.removeOnResume(_resumeCallback!);
      _resumeCallback = null;
    }
    super.dispose();
  }

  /// Set context for image precaching
  void setContext(BuildContext context) {
    _context = context;
  }

  /// Load user preferences from onboarding and then load feed
  Future<void> _loadUserPreferencesAndFeed() async {
    try {
      // Get filter parameters from onboarding preferences
      // Price tiers now match luxury pricing: budget (0-2K), mid (2K-10K), premium (10K-25K), luxury (25K+)
      final filterParams = await OnboardingService.getFilterParameters();
      
      // Update state with user preferences
      if (mounted) {
        state = state.copyWith(
          categoryFilter: filterParams['category'],
          activeStyleFilters: filterParams['styleTags'] ?? [],
          minPrice: filterParams['minPrice'],
          maxPrice: filterParams['maxPrice'],
        );
      }
      
      print('🎯 Loading feed with luxury price tiers (AED 450-45,000)');
      
      // Now load the feed with these preferences
      await loadInitialFeed();
    } catch (e) {
      // Error boundary: Handle preference loading errors gracefully
      ErrorHandler.logError(e, context: '_loadUserPreferencesAndFeed');
      print('Failed to load user preferences: $e');
      
      if (mounted) {
        state = state.copyWith(
          error: 'Failed to load preferences. Using default filters.',
        );
      }
      
      // Still try to load feed without filters
      await loadInitialFeed();
    }
  }

  /// Load initial feed with discovery section (silent, no loading state)
  /// Progressive loading: Load 10 cards initially
  Future<void> loadInitialFeed() async {
    try {
      // Load both main feed and discovery section in parallel
      final results = await Future.wait([
        _productRepo.getFeed(
          userId: state.userId,
          styleFilters: state.activeStyleFilters.isNotEmpty ? state.activeStyleFilters : null,
          category: state.categoryFilter,
          minPrice: state.minPrice,
          maxPrice: state.maxPrice,
          limit: 10, // Load only 10 cards initially (progressive loading)
          offset: 0,
          forceRefresh: false, // Use cache if available
        ),
        _productRepo.getDiscoverySection(forceRefresh: false),
      ]);

      final products = results[0] as List<Product>;
      final discovery = results[1] as Map<String, List<Product>>;

      // Check if still mounted before updating state
      if (mounted) {
        state = state.copyWith(
          products: products,
          discoverySection: discovery,
          currentIndex: 0,
          error: null,
          isInitialLoad: false,
        );
        print('✅ Loaded ${products.length} products + discovery section');
      }
    } catch (e) {
      // Error boundary: Log and handle feed loading errors
      ErrorHandler.logError(e, context: 'loadInitialFeed');
      print('❌ Feed load error: $e');
      
      // Check if still mounted before updating state
      if (mounted) {
        final errorMessage = ErrorHandler.handleError(e, context: 'loading feed');
        state = state.copyWith(
          error: errorMessage,
          isInitialLoad: false,
        );
      }
    }
  }

  /// Refresh discovery section
  Future<void> refreshDiscovery({bool forceRefresh = true}) async {
    if (!mounted) return;
    
    state = state.copyWith(isLoadingDiscovery: true);

    try {
      final discovery = await _productRepo.getDiscoverySection(
        forceRefresh: forceRefresh,
      );

      if (mounted) {
        state = state.copyWith(
          discoverySection: discovery,
          isLoadingDiscovery: false,
          error: null,
        );
        print('✅ Discovery section refreshed');
      }
    } catch (e) {
      // Error boundary: Handle discovery refresh errors
      ErrorHandler.logError(e, context: 'refreshDiscovery');
      print('❌ Discovery refresh error: $e');
      
      if (mounted) {
        final errorMessage = ErrorHandler.handleError(e, context: 'refreshing discovery');
        state = state.copyWith(
          isLoadingDiscovery: false,
          error: errorMessage,
        );
      }
    }
  }

  /// Load more products (progressive loading: 5 products at a time)
  /// Uses PaginationManager to prevent duplicate loads
  Future<void> loadMore() async {
    if (!mounted) return;
    
    // Check if can load more (prevents duplicate requests)
    if (!_paginationManager.startLoading()) {
      return;
    }

    print('📥 Loading more products (pagination manager active)...');

    try {
      final newProducts = await _productRepo.getFeed(
        userId: state.userId,
        styleFilters: state.activeStyleFilters.isNotEmpty ? state.activeStyleFilters : null,
        category: state.categoryFilter,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        limit: _paginationManager.itemsPerPage,
        offset: _paginationManager.currentOffset,
        forceRefresh: false, // Use cache if available
      );

      // Update pagination state
      _paginationManager.completeLoading(
        itemsLoaded: newProducts.length,
        expectedItems: _paginationManager.itemsPerPage,
      );

      // Only update if we got new products and still mounted
      if (newProducts.isNotEmpty && mounted) {
        // Use extension to prevent duplicates
        final updatedProducts = state.products.appendUnique(
          newProducts,
          (product) => product.id,
        );
        
        state = state.copyWith(
          products: updatedProducts,
          error: null,
        );
        print('✅ Loaded ${newProducts.length} more products. Total: ${updatedProducts.length}');
        print('📊 Pagination state: ${_paginationManager.getDebugInfo()}');
      } else if (newProducts.isEmpty) {
        print('🏁 No more products available');
      }
    } catch (e) {
      // Error boundary: Handle load more errors gracefully
      ErrorHandler.logError(e, context: 'loadMore');
      _paginationManager.errorLoading();
      print('❌ Failed to load more products: $e');
      
      if (mounted) {
        final errorMessage = ErrorHandler.handleError(e, context: 'loading more products');
        state = state.copyWith(error: errorMessage);
      }
    }
  }

  /// Handle swipe
  Future<void> handleSwipe({
    required SwipeDirection direction,
    required Product product,
    required int dwellMs,
  }) async {
    // Save current index to history for undo
    final history = List<int>.from(state.swipeHistory);
    history.add(state.currentIndex);
    
    // Move to next card IMMEDIATELY (no waiting for async operations)
    final newIndex = state.currentIndex + 1;
    state = state.copyWith(
      currentIndex: newIndex,
      swipeHistory: history,
    );

    // Check if should trigger pagination load
    if (_paginationManager.shouldLoadMore(
      currentIndex: newIndex,
      threshold: 5, // Load when 5 or fewer items remain
    )) {
      print('🔄 Triggering pagination load at position $newIndex');
      loadMore(); // Fire and forget - loads next batch
    }

    // Determine swipe action based on direction
    SwipeAction action;
    switch (direction) {
      case SwipeDirection.right:
        action = SwipeAction.like;
        _handleLike(product); // Fire and forget
        break;
      case SwipeDirection.left:
        action = SwipeAction.detailsView;
        break;
      case SwipeDirection.up:
        action = SwipeAction.skip;
        break;
      case SwipeDirection.down:
        action = SwipeAction.wishlist;
        _handleWishlist(product); // Fire and forget
        break;
      default:
        return;
    }

    // Track swipe in database (fire and forget)
    _swipeRepo.trackSwipe(
      userId: state.userId,
      product: product,
      direction: direction,
      action: action,
      sessionId: _sessionId,
      dwellMs: dwellMs,
      cardPosition: state.currentIndex,
      isRepeatView: false,
      activeStyleFilters: state.activeStyleFilters,
    ).catchError((e) => print('Failed to track swipe: $e'));

    // Increment user's swipe count (fire and forget)
    _userRepo.incrementSwipes(state.userId).catchError((e) => print('Failed to increment swipes: $e'));
  }

  /// Handle like (add to Swirls)
  Future<void> _handleLike(Product product) async {
    try {
      await _swirlRepo.addSwirl(
        userId: state.userId,
        productId: product.id,
        source: ItemSource.swipeRight,
      );
    } catch (e) {
      print('Failed to add swirl: $e');
    }
  }

  /// Handle wishlist (add to Wishlist + Swirls)
  Future<void> _handleWishlist(Product product) async {
    try {
      // Add to Swirls
      await _swirlRepo.addSwirl(
        userId: state.userId,
        productId: product.id,
        source: ItemSource.swipeDown,
      );
      // TODO: Add to wishlist when wishlist repository is integrated
      // This would call: await _wishlistRepo.addWishlistItem(userId: state.userId, productId: product.id);
    } catch (e) {
      print('Failed to add to wishlist: $e');
    }
  }

  /// Toggle style filter
  void toggleStyleFilter(String styleTag) {
    final filters = List<String>.from(state.activeStyleFilters);

    if (filters.contains(styleTag)) {
      filters.remove(styleTag);
    } else {
      filters.add(styleTag);
    }

    state = state.copyWith(activeStyleFilters: filters);

    // Reload feed with new filters
    loadInitialFeed();
  }

  /// Undo last swipe
  void undoSwipe() {
    if (!state.canUndo) return;
    
    final history = List<int>.from(state.swipeHistory);
    final previousIndex = history.removeLast();
    
    state = state.copyWith(
      currentIndex: previousIndex,
      swipeHistory: history,
    );
  }

  /// Reset feed
  void reset() {
    _sessionId = const Uuid().v4();
    _paginationManager.reset(); // Reset pagination state
    state = FeedState(userId: state.userId, isInitialLoad: true);
    loadInitialFeed();
  }
}

/// Providers
// Using centralized providers from core/providers/app_providers.dart

// Feed provider
final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  final productRepo = ref.watch(productRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  final swipeRepo = ref.watch(swipeRepositoryProvider);
  final swirlRepo = ref.watch(swirlRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  return FeedNotifier(
    productRepo: productRepo,
    userRepo: userRepo,
    swipeRepo: swipeRepo,
    swirlRepo: swirlRepo,
    initialUserId: userId,
  );
});
