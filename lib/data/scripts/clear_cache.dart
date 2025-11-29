import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clear Cache Script
/// Run this to clear all cached products and force fresh data load
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧹 Clearing all cached data...');
  
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  
  print('📊 Found ${keys.length} cached entries');
  
  // Clear all cache entries
  for (final key in keys) {
    if (key.startsWith('cache_')) {
      await prefs.remove(key);
    }
  }
  
  final remainingKeys = prefs.getKeys();
  print('✅ Cache cleared! Remaining entries: ${remainingKeys.length}');
  print('🔄 Restart the app to see fresh products from the database');
}