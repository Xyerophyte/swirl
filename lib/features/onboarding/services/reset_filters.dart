import 'package:shared_preferences/shared_preferences.dart';

/// Temporary utility to reset onboarding filters for luxury products
/// This ensures all 219 luxury products are visible
Future<void> resetOnboardingFilters() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Keep onboarding complete but remove all filters
  await prefs.setBool('onboarding_complete', true);
  await prefs.remove('gender_preference');
  await prefs.remove('style_preferences');
  await prefs.remove('price_tier'); // Remove price filter - THIS WAS BLOCKING PRODUCTS
  
  print('✅ Reset onboarding filters - all 219 luxury products will now be visible');
}