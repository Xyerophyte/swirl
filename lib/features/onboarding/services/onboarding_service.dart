import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Onboarding Service
/// Manages onboarding state and user preferences
class OnboardingService {
  static final _supabase = Supabase.instance.client;
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyGenderPreference = 'gender_preference';
  static const String _keyStylePreferences = 'style_preferences';
  static const String _keyPriceTier = 'price_tier';

  /// Check if user has completed onboarding
  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  /// Mark onboarding as complete
  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingComplete, true);
  }

  /// Mark onboarding as complete (alias for compatibility)
  static Future<void> setOnboardingComplete() async {
    await completeOnboarding();
  }

  /// Save user preferences
  static Future<void> savePreferences({
    String? gender,
    List<String>? styles,
    String? priceTier,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (gender != null) {
      await prefs.setString(_keyGenderPreference, gender);
    }
    
    if (styles != null && styles.isNotEmpty) {
      await prefs.setStringList(_keyStylePreferences, styles);
    }
    
    if (priceTier != null) {
      await prefs.setString(_keyPriceTier, priceTier);
    }
  }

  /// Get user preferences
  static Future<Map<String, dynamic>> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'gender': prefs.getString(_keyGenderPreference),
      'styles': prefs.getStringList(_keyStylePreferences) ?? [],
      'priceTier': prefs.getString(_keyPriceTier),
    };
  }

  /// Get product filter parameters based on user preferences
  static Future<Map<String, dynamic>> getFilterParameters() async {
    final preferences = await getPreferences();
    
    final String? gender = preferences['gender'];
    final List<String> styles = preferences['styles'] ?? [];
    final String? priceTier = preferences['priceTier'];
    
    // Convert style preferences to style tags
    final List<String> styleTags = _convertStylesToTags(styles);
    
    // Convert price tier to min/max price
    final priceRange = _getPriceRange(priceTier);
    
    // Convert gender to category filter
    final String? category = _getCategory(gender);
    
    return {
      'category': category,
      'styleTags': styleTags,
      'minPrice': priceRange['min'],
      'maxPrice': priceRange['max'],
    };
  }

  /// Convert onboarding style selections to product style tags
  static List<String> _convertStylesToTags(List<String> styles) {
    final Map<String, String> styleMap = {
      'minimalist': 'minimalist',
      'urban': 'urban_vibe',
      'streetwear': 'streetwear_edge',
      'elegant': 'avant_garde',
      'casual': 'casual',
      'sporty': 'sporty',
    };
    
    return styles
        .map((style) => styleMap[style])
        .where((tag) => tag != null)
        .cast<String>()
        .toList();
  }

  /// Get price range based on price tier
  /// Updated for luxury fashion pricing (AED 450 - AED 45,000)
  static Map<String, double?> _getPriceRange(String? priceTier) {
    switch (priceTier) {
      case 'budget':
        // Entry luxury: Accessories, small leather goods
        return {'min': null, 'max': 2000.0};
      case 'mid':
        // Mid luxury: Designer bags, shoes, ready-to-wear
        return {'min': 2000.0, 'max': 10000.0};
      case 'premium':
        // Premium luxury: Iconic pieces, limited editions
        return {'min': 10000.0, 'max': 25000.0};
      case 'luxury':
        // Ultra luxury: Exotic leathers, haute couture, rare items
        return {'min': 25000.0, 'max': null};
      default:
        return {'min': null, 'max': null}; // No filter - show all products
    }
  }

  /// Get category filter based on gender preference
  static String? _getCategory(String? gender) {
    switch (gender) {
      case 'women':
        return 'women';
      case 'men':
        return 'men';
      case 'both':
        return null; // No category filter for both
      default:
        return null;
    }
  }

  /// Reset onboarding (for testing/debugging)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOnboardingComplete);
    await prefs.remove(_keyGenderPreference);
    await prefs.remove(_keyStylePreferences);
    await prefs.remove(_keyPriceTier);
  }

  /// Create a temporary anonymous user in Supabase with preferences
  /// Uses the existing user_id from SharedPreferences (set by UserSessionProvider)
  static Future<String> createTemporaryUser({
    required String gender,
    required List<String> styles,
    required String priceTier,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing user ID from UserSessionProvider
      final userId = prefs.getString('user_id');
      
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found. UserSession not initialized.');
      }
      
      // Convert style preferences to database format
      final styleTags = _convertStylesToTags(styles);
      
      // Generate anonymous ID for tracking
      final anonymousId = const Uuid().v4();
      
      // Create user in Supabase with the existing user ID
      final response = await _supabase.from('users').insert({
        'id': userId, // Use the ID from UserSessionProvider
        'anonymous_id': anonymousId,
        'is_anonymous': true,
        'gender_preference': gender,
        'style_preferences': styleTags,
        'price_tier': priceTier,
        'display_name': 'Guest User',
        'device_locale': 'en-AE',
        'timezone': 'Asia/Dubai',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'last_seen_at': DateTime.now().toIso8601String(),
      }).select().single();
      
      print('✅ Created user in Supabase: ${response['id']}');
      
      // Save preferences locally as well
      await savePreferences(
        gender: gender,
        styles: styles,
        priceTier: priceTier,
      );
      
      return response['id'] as String;
    } catch (e) {
      print('❌ Failed to create temporary user: $e');
      
      // Try to get the user ID anyway for continuation
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '00000000-0000-0000-0000-000000000000';
      
      // Save preferences locally even if Supabase fails
      await savePreferences(
        gender: gender,
        styles: styles,
        priceTier: priceTier,
      );
      
      return userId;
    }
  }

  /// Get the current user ID (from SharedPreferences)
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? '00000000-0000-0000-0000-000000000000';
  }
}