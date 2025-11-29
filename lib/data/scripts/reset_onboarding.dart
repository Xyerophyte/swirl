import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reset Onboarding Script
/// Run this to reset onboarding state and see the onboarding screen again
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔄 Resetting onboarding state...');
  
  final prefs = await SharedPreferences.getInstance();
  
  // Remove onboarding completion flag
  await prefs.remove('onboarding_complete');
  await prefs.remove('gender_preference');
  await prefs.remove('style_preferences');
  await prefs.remove('price_tier');
  
  print('✅ Onboarding state reset!');
  print('🔄 Restart the app to see the new onboarding flow');
}