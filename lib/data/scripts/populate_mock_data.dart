/// Script to populate Supabase with mock product data
/// Run this once after setting up the database schema
///
/// Usage:
/// 1. Make sure .env has valid Supabase credentials
/// 2. Run: dart run lib/data/scripts/populate_mock_data.dart

import 'dart:convert';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  print('🚀 Starting SWIRL mock data population...\n');

  try {
    // Load environment variables
    await dotenv.load(fileName: '.env');
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Missing Supabase credentials in .env file');
    }

    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    final supabase = Supabase.instance.client;
    print('✅ Connected to Supabase\n');

    // Insert brands first
    print('📦 Inserting brands...');
    await insertBrands(supabase);
    print('✅ Brands inserted\n');

    // Insert products
    print('👕 Inserting products...');
    await insertProducts(supabase);
    print('✅ Products inserted\n');

    // Verify data
    print('🔍 Verifying data...');
    final count = await supabase.from('products').select('id').count();
    print('✅ Found ${count.count} products in database\n');

    print('🎉 Mock data population complete!');
    print('You can now run the app and see the products.\n');

    exit(0);
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}

Future<void> insertBrands(SupabaseClient supabase) async {
  final brands = [
    {
      'id': '11111111-1111-1111-1111-111111111111',
      'name': 'Amazon Essentials',
      'slug': 'amazon-essentials',
      'style_tags': ['minimalist', 'urban_vibe'],
      'primary_category': 'men',
      'total_products': 1,
    },
    {
      'id': '22222222-2222-2222-2222-222222222222',
      'name': 'Supreme Basics',
      'slug': 'supreme-basics',
      'style_tags': ['streetwear_edge', 'urban_vibe'],
      'primary_category': 'men',
      'total_products': 1,
    },
    {
      'id': '33333333-3333-3333-3333-333333333333',
      'name': 'ZARA Couture',
      'slug': 'zara-couture',
      'style_tags': ['avant_garde'],
      'primary_category': 'women',
      'total_products': 1,
    },
    {
      'id': '44444444-4444-4444-4444-444444444444',
      'name': 'Uniqlo',
      'slug': 'uniqlo',
      'style_tags': ['minimalist'],
      'primary_category': 'unisex',
      'total_products': 1,
    },
    {
      'id': '55555555-5555-5555-5555-555555555555',
      'name': 'Nike',
      'slug': 'nike',
      'style_tags': ['streetwear_edge', 'urban_vibe'],
      'primary_category': 'shoes',
      'total_products': 1,
    },
  ];

  for (final brand in brands) {
    try {
      await supabase.from('brands').upsert(brand);
      print('  ✓ ${brand['name']}');
    } catch (e) {
      print('  ⚠️  ${brand['name']} (may already exist)');
    }
  }
}

/// Helper function to generate Unsplash image URL based on product type
String getUnsplashImageUrl(String subcategory, {int width = 800, int height = 800}) {
  // Map subcategories to better search terms
  final searchTerms = {
    'shirts': 'dress+shirt+fashion',
    'hoodies': 'hoodie+streetwear',
    'blazers': 'blazer+fashion',
    't-shirts': 'tshirt+minimal',
    'sneakers': 'sneakers+shoes',
    'shorts': 'shorts+men+fashion',
    'pants': 'pants+trousers+fashion',
    'jeans': 'jeans+denim',
    'dresses': 'dress+fashion',
    'jackets': 'jacket+fashion',
    'coats': 'coat+fashion',
    'sweaters': 'sweater+fashion',
    'skirts': 'skirt+fashion',
    'suits': 'suit+formal',
  };

  final searchTerm = searchTerms[subcategory] ?? subcategory;
  return 'https://source.unsplash.com/${width}x$height/?$searchTerm';
}

Future<void> insertProducts(SupabaseClient supabase) async {
  final products = [
    // Product 1: Men's Slim Fit Oxford Shirt
    {
      'id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
      'external_id': 'B07XYZ1001',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1001',
      'name': 'Men\'s Slim Fit Oxford Shirt - Long Sleeve',
      'brand': 'Amazon Essentials',
      'description': 'Classic oxford button-down shirt with modern slim fit. Perfect for business casual or everyday wear.',
      'price': 89.00,
      'original_price': 129.00,
      'currency': 'AED',
      'discount_percentage': 31,
      'category': 'men',
      'subcategory': 'shirts',
      'style_tags': ['minimalist', 'urban_vibe'],
      'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
      'colors': ['White', 'Light Blue', 'Navy', 'Black'],
      'materials': '100% Cotton',
      'care_instructions': 'Machine wash cold. Tumble dry low.',
      'primary_image_url': getUnsplashImageUrl('shirts'),
      'additional_images': [],
      'rating': 4.5,
      'review_count': 234,
      'is_trending': false,
      'is_new_arrival': true,
      'is_flash_sale': false,
      'is_in_stock': true,
      'stock_count': 150,
    },

    // Product 2: Oversized Graphic Hoodie
    {
      'id': 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
      'external_id': 'B07XYZ1002',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1002',
      'name': 'Oversized Graphic Hoodie - Streetwear',
      'brand': 'Supreme Basics',
      'description': 'Bold oversized hoodie with graphic print. Premium heavyweight cotton blend for ultimate comfort.',
      'price': 245.00,
      'currency': 'AED',
      'discount_percentage': 0,
      'category': 'men',
      'subcategory': 'hoodies',
      'style_tags': ['streetwear_edge', 'urban_vibe'],
      'sizes': ['M', 'L', 'XL', 'XXL'],
      'colors': ['Black', 'Gray', 'Olive Green'],
      'materials': '80% Cotton, 20% Polyester',
      'care_instructions': 'Machine wash cold inside out. Do not bleach.',
      'primary_image_url': getUnsplashImageUrl('hoodies'),
      'additional_images': [],
      'rating': 4.7,
      'review_count': 567,
      'is_trending': true,
      'is_new_arrival': false,
      'is_flash_sale': false,
      'is_in_stock': true,
      'stock_count': 85,
    },

    // Product 3: Avant-Garde Asymmetric Blazer
    {
      'id': 'cccccccc-cccc-cccc-cccc-cccccccccccc',
      'external_id': 'B07XYZ1003',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1003',
      'name': 'Avant-Garde Asymmetric Blazer',
      'brand': 'ZARA Couture',
      'description': 'Experimental design with asymmetric cut and unique draping. Statement piece for the fashion-forward.',
      'price': 899.00,
      'original_price': 1299.00,
      'currency': 'AED',
      'discount_percentage': 31,
      'category': 'women',
      'subcategory': 'blazers',
      'style_tags': ['avant_garde'],
      'sizes': ['XS', 'S', 'M', 'L'],
      'colors': ['Black', 'Cream'],
      'materials': '65% Wool, 35% Polyester',
      'care_instructions': 'Dry clean only.',
      'primary_image_url': getUnsplashImageUrl('blazers'),
      'additional_images': [],
      'rating': 4.3,
      'review_count': 89,
      'is_trending': false,
      'is_new_arrival': true,
      'is_flash_sale': false,
      'is_in_stock': true,
      'stock_count': 25,
    },

    // Product 4: Minimalist Crew Neck T-Shirt Pack
    {
      'id': 'dddddddd-dddd-dddd-dddd-dddddddddddd',
      'external_id': 'B07XYZ1004',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1004',
      'name': 'Minimalist Crew Neck T-Shirt - Pack of 3',
      'brand': 'Uniqlo',
      'description': 'Essential basics in premium cotton. Clean lines and perfect fit for everyday layering.',
      'price': 119.00,
      'currency': 'AED',
      'discount_percentage': 0,
      'category': 'unisex',
      'subcategory': 't-shirts',
      'style_tags': ['minimalist'],
      'sizes': ['S', 'M', 'L', 'XL'],
      'colors': ['White', 'Black', 'Gray'],
      'materials': '100% Supima Cotton',
      'care_instructions': 'Machine wash. Tumble dry low.',
      'primary_image_url': getUnsplashImageUrl('t-shirts'),
      'additional_images': [],
      'rating': 4.8,
      'review_count': 1234,
      'is_trending': true,
      'is_new_arrival': false,
      'is_flash_sale': false,
      'is_in_stock': true,
      'stock_count': 500,
    },

    // Product 5: Retro High-Top Sneakers
    {
      'id': 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
      'external_id': 'B07XYZ1005',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1005',
      'name': 'Retro High-Top Sneakers',
      'brand': 'Nike',
      'description': 'Classic basketball-inspired sneakers with modern comfort technology. Iconic design that never goes out of style.',
      'price': 349.00,
      'original_price': 449.00,
      'currency': 'AED',
      'discount_percentage': 22,
      'category': 'shoes',
      'subcategory': 'sneakers',
      'style_tags': ['streetwear_edge', 'urban_vibe'],
      'sizes': ['7', '8', '9', '10', '11', '12'],
      'colors': ['White/Red', 'Black/White', 'Navy/Gold'],
      'materials': 'Leather and Synthetic upper',
      'care_instructions': 'Wipe clean with damp cloth.',
      'primary_image_url': getUnsplashImageUrl('sneakers'),
      'additional_images': [],
      'rating': 4.6,
      'review_count': 892,
      'is_trending': true,
      'is_new_arrival': false,
      'is_flash_sale': true,
      'is_in_stock': true,
      'stock_count': 120,
    },

    // Product 6: Classic Chino Shorts
    {
      'id': 'ffffffff-ffff-ffff-ffff-ffffffffffff',
      'external_id': 'B07XYZ1006',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1006',
      'name': 'Classic Chino Shorts - Summer Essential',
      'brand': 'Amazon Essentials',
      'description': 'Comfortable cotton chino shorts perfect for casual summer days. Classic fit with modern styling.',
      'price': 79.00,
      'original_price': 99.00,
      'currency': 'AED',
      'discount_percentage': 20,
      'category': 'men',
      'subcategory': 'shorts',
      'style_tags': ['minimalist', 'urban_vibe'],
      'sizes': ['28', '30', '32', '34', '36'],
      'colors': ['Khaki', 'Navy', 'Black', 'Olive'],
      'materials': '98% Cotton, 2% Elastane',
      'care_instructions': 'Machine wash cold. Tumble dry low.',
      'primary_image_url': getUnsplashImageUrl('shorts'),
      'additional_images': [],
      'rating': 4.4,
      'review_count': 456,
      'is_trending': false,
      'is_new_arrival': true,
      'is_flash_sale': false,
      'is_in_stock': true,
      'stock_count': 200,
    },

    // Product 7: Slim Fit Denim Jeans
    {
      'id': '10101010-1010-1010-1010-101010101010',
      'external_id': 'B07XYZ1007',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1007',
      'name': 'Slim Fit Dark Wash Denim Jeans',
      'brand': 'Uniqlo',
      'description': 'Premium denim with stretch comfort. Versatile dark wash for any occasion.',
      'price': 159.00,
      'currency': 'AED',
      'discount_percentage': 0,
      'category': 'men',
      'subcategory': 'jeans',
      'style_tags': ['minimalist', 'urban_vibe'],
      'sizes': ['28', '30', '32', '34', '36', '38'],
      'colors': ['Dark Wash', 'Medium Wash', 'Black'],
      'materials': '92% Cotton, 6% Polyester, 2% Elastane',
      'care_instructions': 'Machine wash cold. Hang dry.',
      'primary_image_url': getUnsplashImageUrl('jeans'),
      'additional_images': [],
      'rating': 4.6,
      'review_count': 789,
      'is_trending': true,
      'is_new_arrival': false,
      'is_flash_sale': false,
      'is_in_stock': true,
      'stock_count': 180,
    },

    // Product 8: Leather Bomber Jacket
    {
      'id': '20202020-2020-2020-2020-202020202020',
      'external_id': 'B07XYZ1008',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1008',
      'name': 'Classic Leather Bomber Jacket',
      'brand': 'Supreme Basics',
      'description': 'Timeless leather bomber with modern fit. Premium genuine leather construction.',
      'price': 799.00,
      'original_price': 999.00,
      'currency': 'AED',
      'discount_percentage': 20,
      'category': 'men',
      'subcategory': 'jackets',
      'style_tags': ['streetwear_edge', 'urban_vibe'],
      'sizes': ['S', 'M', 'L', 'XL'],
      'colors': ['Black', 'Brown'],
      'materials': '100% Genuine Leather',
      'care_instructions': 'Professional leather cleaning only.',
      'primary_image_url': getUnsplashImageUrl('jackets'),
      'additional_images': [],
      'rating': 4.8,
      'review_count': 234,
      'is_trending': true,
      'is_new_arrival': true,
      'is_flash_sale': false,
      'is_in_stock': true,
      'stock_count': 45,
    },

    // Product 9: Floral Summer Dress
    {
      'id': '30303030-3030-3030-3030-303030303030',
      'external_id': 'B07XYZ1009',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1009',
      'name': 'Floral Print Summer Dress',
      'brand': 'ZARA Couture',
      'description': 'Lightweight floral dress perfect for summer occasions. Flattering silhouette with elegant draping.',
      'price': 259.00,
      'original_price': 349.00,
      'currency': 'AED',
      'discount_percentage': 26,
      'category': 'women',
      'subcategory': 'dresses',
      'style_tags': ['avant_garde'],
      'sizes': ['XS', 'S', 'M', 'L', 'XL'],
      'colors': ['Floral Blue', 'Floral Pink', 'Floral Yellow'],
      'materials': '100% Rayon',
      'care_instructions': 'Hand wash cold. Line dry.',
      'primary_image_url': getUnsplashImageUrl('dresses'),
      'additional_images': [],
      'rating': 4.7,
      'review_count': 567,
      'is_trending': true,
      'is_new_arrival': true,
      'is_flash_sale': true,
      'is_in_stock': true,
      'stock_count': 95,
    },

    // Product 10: Wool Blend Sweater
    {
      'id': '40404040-4040-4040-4040-404040404040',
      'external_id': 'B07XYZ1010',
      'source_store': 'amazon',
      'source_url': 'https://www.amazon.ae/dp/B07XYZ1010',
      'name': 'Merino Wool Crew Neck Sweater',
      'brand': 'Uniqlo',
      'description': 'Premium merino wool sweater. Soft, breathable, and perfect for layering.',
      'price': 199.00,
      'currency': 'AED',
      'discount_percentage': 0,
      'category': 'unisex',
      'subcategory': 'sweaters',
      'style_tags': ['minimalist'],
      'sizes': ['S', 'M', 'L', 'XL'],
      'colors': ['Navy', 'Gray', 'Burgundy', 'Forest Green'],
      'materials': '100% Merino Wool',
      'care_instructions': 'Hand wash cold. Lay flat to dry.',
      'primary_image_url': getUnsplashImageUrl('sweaters'),
      'additional_images': [],
      'rating': 4.9,
      'review_count': 1123,
      'is_trending': false,
      'is_new_arrival': false,
      'is_flash_sale': false,
      'is_in_stock': true,
      'stock_count': 250,
    },
  ];

  for (final product in products) {
    try {
      await supabase.from('products').upsert(product);
      print('  ✓ ${product['name']}');
    } catch (e) {
      print('  ⚠️  ${product['name']} (may already exist)');
    }
  }
}
