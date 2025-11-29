import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/swipe_repository.dart';
import '../../data/repositories/swirl_repository.dart';
import '../../data/repositories/wishlist_repository.dart';
import 'user_session_provider.dart';

/// Centralized App Providers
/// Single source of truth for all shared providers across the app
/// This prevents provider duplication and ensures consistent state

// ============================================================================
// CORE PROVIDERS
// ============================================================================

/// Supabase Client Provider
/// Provides access to the Supabase client instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Current User ID Provider
/// Provides the current user's ID (anonymous or authenticated)
/// Uses persistent storage via user_session_provider
final currentUserIdProvider = Provider<String>((ref) {
  return ref.watch(persistentUserIdProvider);
});

// ============================================================================
// REPOSITORY PROVIDERS
// ============================================================================

/// Product Repository Provider
/// Provides access to product data operations
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProductRepository(client);
});

/// User Repository Provider
/// Provides access to user data operations
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return UserRepository(client);
});

/// Swipe Repository Provider
/// Provides access to swipe tracking operations
final swipeRepositoryProvider = Provider<SwipeRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SwipeRepository(client);
});

/// Swirl Repository Provider
/// Provides access to swirl (liked items) operations
final swirlRepositoryProvider = Provider<SwirlRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SwirlRepository(client);
});

/// Wishlist Repository Provider
/// Provides access to wishlist operations
final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return WishlistRepository(client);
});

// ============================================================================
// USER SESSION PROVIDER
// ============================================================================
// User session management is now implemented in user_session_provider.dart
// It provides:
// - userSessionProvider: Full session state with lifecycle management
// - persistentUserIdProvider: Direct access to persisted user ID
// - isSessionInitializedProvider: Check if session has loaded
//
// The currentUserIdProvider above uses persistentUserIdProvider