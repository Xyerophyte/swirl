-- SWIRL Mock Data Insert Script
-- Run this in Supabase SQL Editor AFTER running supabase_schema.sql
-- This will insert 5 sample products for testing

-- Insert mock brands first
INSERT INTO brands (id, name, slug, logo_url, style_tags, primary_category, total_products, created_at, updated_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'Amazon Essentials', 'amazon-essentials', NULL, ARRAY['minimalist', 'urban_vibe'], 'men', 1, NOW(), NOW()),
  ('22222222-2222-2222-2222-222222222222', 'Supreme Basics', 'supreme-basics', NULL, ARRAY['streetwear_edge', 'urban_vibe'], 'men', 1, NOW(), NOW()),
  ('33333333-3333-3333-3333-333333333333', 'ZARA Couture', 'zara-couture', NULL, ARRAY['avant_garde'], 'women', 1, NOW(), NOW()),
  ('44444444-4444-4444-4444-444444444444', 'Uniqlo', 'uniqlo', NULL, ARRAY['minimalist'], 'unisex', 1, NOW(), NOW()),
  ('55555555-5555-5555-5555-555555555555', 'Nike', 'nike', NULL, ARRAY['streetwear_edge', 'urban_vibe'], 'shoes', 1, NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Insert 5 mock products
INSERT INTO products (
  id, external_id, source_store, source_url, name, brand, description,
  price, original_price, currency, discount_percentage,
  category, subcategory, style_tags, sizes, colors,
  materials, care_instructions,
  primary_image_url, additional_images,
  rating, review_count,
  is_trending, is_new_arrival, is_flash_sale, is_in_stock, stock_count,
  created_at, updated_at
)
VALUES
  -- Product 1: Men's Slim Fit Oxford Shirt
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'B07XYZ1001',
    'amazon',
    'https://www.amazon.ae/dp/B07XYZ1001',
    'Men''s Slim Fit Oxford Shirt - Long Sleeve',
    'Amazon Essentials',
    'Classic oxford button-down shirt with modern slim fit. Perfect for business casual or everyday wear.',
    89.00,
    129.00,
    'AED',
    31,
    'men',
    'shirts',
    ARRAY['minimalist', 'urban_vibe'],
    ARRAY['S', 'M', 'L', 'XL', 'XXL'],
    ARRAY['White', 'Light Blue', 'Navy', 'Black'],
    '100% Cotton',
    'Machine wash cold. Tumble dry low.',
    'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800',
    ARRAY[]::TEXT[],
    4.5,
    234,
    false,
    true,
    false,
    true,
    150,
    NOW(),
    NOW()
  ),

  -- Product 2: Oversized Graphic Hoodie
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'B07XYZ1002',
    'amazon',
    'https://www.amazon.ae/dp/B07XYZ1002',
    'Oversized Graphic Hoodie - Streetwear',
    'Supreme Basics',
    'Bold oversized hoodie with graphic print. Premium heavyweight cotton blend for ultimate comfort.',
    245.00,
    NULL,
    'AED',
    0,
    'men',
    'hoodies',
    ARRAY['streetwear_edge', 'urban_vibe'],
    ARRAY['M', 'L', 'XL', 'XXL'],
    ARRAY['Black', 'Gray', 'Olive Green'],
    '80% Cotton, 20% Polyester',
    'Machine wash cold inside out. Do not bleach.',
    'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800',
    ARRAY[]::TEXT[],
    4.7,
    567,
    true,
    false,
    false,
    true,
    85,
    NOW(),
    NOW()
  ),

  -- Product 3: Avant-Garde Asymmetric Blazer
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    'B07XYZ1003',
    'amazon',
    'https://www.amazon.ae/dp/B07XYZ1003',
    'Avant-Garde Asymmetric Blazer',
    'ZARA Couture',
    'Experimental design with asymmetric cut and unique draping. Statement piece for the fashion-forward.',
    899.00,
    1299.00,
    'AED',
    31,
    'women',
    'blazers',
    ARRAY['avant_garde'],
    ARRAY['XS', 'S', 'M', 'L'],
    ARRAY['Black', 'Cream'],
    '65% Wool, 35% Polyester',
    'Dry clean only.',
    'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800',
    ARRAY[]::TEXT[],
    4.3,
    89,
    false,
    true,
    false,
    true,
    25,
    NOW(),
    NOW()
  ),

  -- Product 4: Minimalist Crew Neck T-Shirt Pack
  (
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    'B07XYZ1004',
    'amazon',
    'https://www.amazon.ae/dp/B07XYZ1004',
    'Minimalist Crew Neck T-Shirt - Pack of 3',
    'Uniqlo',
    'Essential basics in premium cotton. Clean lines and perfect fit for everyday layering.',
    119.00,
    NULL,
    'AED',
    0,
    'unisex',
    't-shirts',
    ARRAY['minimalist'],
    ARRAY['S', 'M', 'L', 'XL'],
    ARRAY['White', 'Black', 'Gray'],
    '100% Supima Cotton',
    'Machine wash. Tumble dry low.',
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
    ARRAY[]::TEXT[],
    4.8,
    1234,
    true,
    false,
    false,
    true,
    500,
    NOW(),
    NOW()
  ),

  -- Product 5: Retro High-Top Sneakers
  (
    'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
    'B07XYZ1005',
    'amazon',
    'https://www.amazon.ae/dp/B07XYZ1005',
    'Retro High-Top Sneakers',
    'Nike',
    'Classic basketball-inspired sneakers with modern comfort technology. Iconic design that never goes out of style.',
    349.00,
    449.00,
    'AED',
    22,
    'shoes',
    'sneakers',
    ARRAY['streetwear_edge', 'urban_vibe'],
    ARRAY['7', '8', '9', '10', '11', '12'],
    ARRAY['White/Red', 'Black/White', 'Navy/Gold'],
    'Leather and Synthetic upper',
    'Wipe clean with damp cloth.',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    ARRAY[]::TEXT[],
    4.6,
    892,
    true,
    false,
    true,
    true,
    120,
    NOW(),
    NOW()
  )
ON CONFLICT (external_id) DO NOTHING;

-- Verify the data was inserted
SELECT
  id,
  name,
  brand,
  price,
  category,
  is_trending,
  is_new_arrival
FROM products
ORDER BY created_at DESC;

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'Mock data inserted successfully!';
    RAISE NOTICE '5 products added to database';
    RAISE NOTICE 'Ready to test the app!';
END $$;
