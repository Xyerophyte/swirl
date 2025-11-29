-- SWIRL Enhanced Mock Data for UI Testing
-- Run this in Supabase SQL Editor AFTER running supabase_schema.sql
-- This includes 20+ products, brands, and weekly outfits for testing

-- ==============================================
-- 1. INSERT BRANDS
-- ==============================================

INSERT INTO brands (id, name, slug, logo_url, description, style_tags, primary_category, total_products, avg_price, follower_count, created_at, updated_at)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'Amazon Essentials', 'amazon-essentials', NULL, 'Quality basics for everyday wear', ARRAY['minimalist', 'urban_vibe'], 'men', 5, 120.00, 1250, NOW(), NOW()),
  ('22222222-2222-2222-2222-222222222222', 'Supreme Basics', 'supreme-basics', NULL, 'Streetwear essentials', ARRAY['streetwear_edge', 'urban_vibe'], 'men', 4, 280.00, 3420, NOW(), NOW()),
  ('33333333-3333-3333-3333-333333333333', 'ZARA', 'zara', NULL, 'Fashion-forward clothing', ARRAY['avant_garde', 'minimalist'], 'women', 6, 450.00, 5680, NOW(), NOW()),
  ('44444444-4444-4444-4444-444444444444', 'Uniqlo', 'uniqlo', NULL, 'Simple, quality basics', ARRAY['minimalist'], 'unisex', 4, 95.00, 2890, NOW(), NOW()),
  ('55555555-5555-5555-5555-555555555555', 'Nike', 'nike', NULL, 'Athletic excellence', ARRAY['streetwear_edge', 'urban_vibe'], 'shoes', 5, 380.00, 8920, NOW(), NOW()),
  ('66666666-6666-6666-6666-666666666666', 'Adidas', 'adidas', NULL, 'Performance and style', ARRAY['streetwear_edge'], 'shoes', 4, 340.00, 7450, NOW(), NOW()),
  ('77777777-7777-7777-7777-777777777777', 'Mango', 'mango', NULL, 'Contemporary fashion', ARRAY['minimalist', 'urban_vibe'], 'women', 5, 320.00, 4120, NOW(), NOW()),
  ('88888888-8888-8888-8888-888888888888', 'H&M', 'hm', NULL, 'Affordable fashion', ARRAY['urban_vibe'], 'unisex', 6, 180.00, 6340, NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- ==============================================
-- 2. INSERT PRODUCTS (25 items for rich testing)
-- ==============================================

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
  -- Men's Tops (5 items)
  ('a1111111-1111-1111-1111-111111111111', 'AE-SH-001', 'amazon', 'https://www.amazon.ae/dp/AE-SH-001', 'Slim Fit Oxford Shirt', 'Amazon Essentials', 'Classic oxford button-down shirt with modern slim fit', 89.00, 129.00, 'AED', 31, 'men', 'shirts', ARRAY['minimalist', 'urban_vibe'], ARRAY['S', 'M', 'L', 'XL', 'XXL'], ARRAY['White', 'Light Blue', 'Navy', 'Black'], '100% Cotton', 'Machine wash cold', 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800', ARRAY[]::TEXT[], 4.5, 234, false, true, false, true, 150, NOW(), NOW()),
  
  ('a2222222-2222-2222-2222-222222222222', 'SB-HD-001', 'amazon', 'https://www.amazon.ae/dp/SB-HD-001', 'Oversized Graphic Hoodie', 'Supreme Basics', 'Bold oversized hoodie with graphic print', 245.00, NULL, 'AED', 0, 'men', 'hoodies', ARRAY['streetwear_edge', 'urban_vibe'], ARRAY['M', 'L', 'XL', 'XXL'], ARRAY['Black', 'Gray', 'Olive'], '80% Cotton, 20% Polyester', 'Machine wash cold inside out', 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800', ARRAY[]::TEXT[], 4.7, 567, true, false, false, true, 85, NOW(), NOW()),
  
  ('a3333333-3333-3333-3333-333333333333', 'UQ-TS-001', 'amazon', 'https://www.amazon.ae/dp/UQ-TS-001', 'Crew Neck T-Shirt Pack', 'Uniqlo', 'Essential basics in premium cotton', 119.00, NULL, 'AED', 0, 'men', 't-shirts', ARRAY['minimalist'], ARRAY['S', 'M', 'L', 'XL'], ARRAY['White', 'Black', 'Gray'], '100% Supima Cotton', 'Machine wash', 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800', ARRAY[]::TEXT[], 4.8, 1234, true, false, false, true, 500, NOW(), NOW()),
  
  ('a4444444-4444-4444-4444-444444444444', 'SB-JK-001', 'amazon', 'https://www.amazon.ae/dp/SB-JK-001', 'Denim Jacket - Vintage Wash', 'Supreme Basics', 'Classic denim jacket with vintage finish', 320.00, 420.00, 'AED', 24, 'men', 'jackets', ARRAY['urban_vibe'], ARRAY['S', 'M', 'L', 'XL'], ARRAY['Light Blue', 'Dark Blue', 'Black'], '100% Cotton Denim', 'Machine wash cold', 'https://images.unsplash.com/photo-1551537482-f2075a1d41f2?w=800', ARRAY[]::TEXT[], 4.4, 312, false, true, false, true, 67, NOW(), NOW()),
  
  ('a5555555-5555-5555-5555-555555555555', 'AE-PL-001', 'amazon', 'https://www.amazon.ae/dp/AE-PL-001', 'Premium Polo Shirt', 'Amazon Essentials', 'Breathable polo with modern fit', 129.00, NULL, 'AED', 0, 'men', 'shirts', ARRAY['minimalist'], ARRAY['M', 'L', 'XL', 'XXL'], ARRAY['Navy', 'White', 'Forest Green'], '60% Cotton, 40% Polyester', 'Machine wash warm', 'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=800', ARRAY[]::TEXT[], 4.6, 445, false, false, false, true, 220, NOW(), NOW()),
  
  -- Men's Bottoms (4 items)
  ('b1111111-1111-1111-1111-111111111111', 'UQ-CH-001', 'amazon', 'https://www.amazon.ae/dp/UQ-CH-001', 'Slim Fit Chinos', 'Uniqlo', 'Versatile chinos with comfortable stretch', 159.00, 199.00, 'AED', 20, 'men', 'pants', ARRAY['minimalist', 'urban_vibe'], ARRAY['28', '30', '32', '34', '36'], ARRAY['Khaki', 'Navy', 'Black', 'Olive'], '98% Cotton, 2% Spandex', 'Machine wash', 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', ARRAY[]::TEXT[], 4.5, 678, false, false, false, true, 180, NOW(), NOW()),
  
  ('b2222222-2222-2222-2222-222222222222', 'SB-JN-001', 'amazon', 'https://www.amazon.ae/dp/SB-JN-001', 'Relaxed Fit Jeans', 'Supreme Basics', 'Comfortable relaxed fit with tapered leg', 189.00, NULL, 'AED', 0, 'men', 'jeans', ARRAY['urban_vibe'], ARRAY['28', '30', '32', '34', '36'], ARRAY['Dark Wash', 'Light Wash', 'Black'], '99% Cotton, 1% Elastane', 'Machine wash cold', 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800', ARRAY[]::TEXT[], 4.3, 523, true, false, false, true, 145, NOW(), NOW()),
  
  ('b3333333-3333-3333-3333-333333333333', 'HM-SH-001', 'amazon', 'https://www.amazon.ae/dp/HM-SH-001', 'Athletic Shorts', 'H&M', 'Lightweight shorts for active days', 89.00, 129.00, 'AED', 31, 'men', 'shorts', ARRAY['urban_vibe'], ARRAY['S', 'M', 'L', 'XL'], ARRAY['Black', 'Gray', 'Navy'], '100% Polyester', 'Machine wash', 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800', ARRAY[]::TEXT[], 4.2, 289, false, true, false, true, 320, NOW(), NOW()),
  
  ('b4444444-4444-4444-4444-444444444444', 'AE-CR-001', 'amazon', 'https://www.amazon.ae/dp/AE-CR-001', 'Cargo Pants - Utility', 'Amazon Essentials', 'Functional cargo pants with multiple pockets', 179.00, NULL, 'AED', 0, 'men', 'pants', ARRAY['streetwear_edge'], ARRAY['28', '30', '32', '34', '36'], ARRAY['Olive', 'Black', 'Khaki'], '100% Cotton', 'Machine wash', 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800', ARRAY[]::TEXT[], 4.4, 412, false, false, false, true, 98, NOW(), NOW()),
  
  -- Women's Items (6 items)
  ('c1111111-1111-1111-1111-111111111111', 'ZR-BL-001', 'amazon', 'https://www.amazon.ae/dp/ZR-BL-001', 'Asymmetric Blazer', 'ZARA', 'Avant-garde blazer with unique cut', 899.00, 1299.00, 'AED', 31, 'women', 'blazers', ARRAY['avant_garde'], ARRAY['XS', 'S', 'M', 'L'], ARRAY['Black', 'Cream'], '65% Wool, 35% Polyester', 'Dry clean only', 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800', ARRAY[]::TEXT[], 4.3, 89, false, true, false, true, 25, NOW(), NOW()),
  
  ('c2222222-2222-2222-2222-222222222222', 'MG-DR-001', 'amazon', 'https://www.amazon.ae/dp/MG-DR-001', 'Midi Wrap Dress', 'Mango', 'Elegant wrap dress with flowing silhouette', 349.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['minimalist', 'urban_vibe'], ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Black', 'Navy', 'Burgundy'], '100% Viscose', 'Hand wash cold', 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', ARRAY[]::TEXT[], 4.7, 567, true, false, false, true, 88, NOW(), NOW()),
  
  ('c3333333-3333-3333-3333-333333333333', 'ZR-TP-001', 'amazon', 'https://www.amazon.ae/dp/ZR-TP-001', 'High-Waisted Trousers', 'ZARA', 'Tailored trousers with modern fit', 259.00, 329.00, 'AED', 21, 'women', 'pants', ARRAY['minimalist'], ARRAY['XS', 'S', 'M', 'L'], ARRAY['Black', 'Beige', 'Navy'], '70% Polyester, 30% Viscose', 'Dry clean', 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=800', ARRAY[]::TEXT[], 4.5, 234, false, true, false, true, 120, NOW(), NOW()),
  
  ('c4444444-4444-4444-4444-444444444444', 'MG-BL-001', 'amazon', 'https://www.amazon.ae/dp/MG-BL-001', 'Silk Blend Blouse', 'Mango', 'Luxurious blouse in silk blend fabric', 289.00, NULL, 'AED', 0, 'women', 'tops', ARRAY['minimalist'], ARRAY['XS', 'S', 'M', 'L'], ARRAY['Ivory', 'Black', 'Dusty Pink'], '70% Viscose, 30% Silk', 'Hand wash', 'https://images.unsplash.com/photo-1564859228273-274232fdb516?w=800', ARRAY[]::TEXT[], 4.6, 445, false, false, false, true, 95, NOW(), NOW()),
  
  ('c5555555-5555-5555-5555-555555555555', 'HM-SK-001', 'amazon', 'https://www.amazon.ae/dp/HM-SK-001', 'Pleated Midi Skirt', 'H&M', 'Flowing pleated skirt for any occasion', 149.00, 199.00, 'AED', 25, 'women', 'skirts', ARRAY['minimalist'], ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Black', 'Camel', 'Burgundy'], '100% Polyester', 'Machine wash', 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800', ARRAY[]::TEXT[], 4.4, 678, false, true, false, true, 156, NOW(), NOW()),
  
  ('c6666666-6666-6666-6666-666666666666', 'ZR-KN-001', 'amazon', 'https://www.amazon.ae/dp/ZR-KN-001', 'Oversized Knit Sweater', 'ZARA', 'Cozy oversized sweater in soft knit', 279.00, NULL, 'AED', 0, 'women', 'sweaters', ARRAY['minimalist', 'urban_vibe'], ARRAY['S', 'M', 'L'], ARRAY['Cream', 'Gray', 'Camel'], '60% Wool, 40% Acrylic', 'Hand wash cold', 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800', ARRAY[]::TEXT[], 4.8, 823, true, false, false, true, 72, NOW(), NOW()),
  
  -- Shoes (6 items)
  ('d1111111-1111-1111-1111-111111111111', 'NK-SN-001', 'amazon', 'https://www.amazon.ae/dp/NK-SN-001', 'Retro High-Top Sneakers', 'Nike', 'Classic basketball-inspired sneakers', 349.00, 449.00, 'AED', 22, 'shoes', 'sneakers', ARRAY['streetwear_edge', 'urban_vibe'], ARRAY['7', '8', '9', '10', '11', '12'], ARRAY['White/Red', 'Black/White', 'Navy/Gold'], 'Leather and Synthetic', 'Wipe clean', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', ARRAY[]::TEXT[], 4.6, 892, true, false, true, true, 120, NOW(), NOW()),
  
  ('d2222222-2222-2222-2222-222222222222', 'AD-RN-001', 'amazon', 'https://www.amazon.ae/dp/AD-RN-001', 'Running Shoes - Ultraboost', 'Adidas', 'Premium running shoes with boost technology', 599.00, NULL, 'AED', 0, 'shoes', 'running', ARRAY['urban_vibe'], ARRAY['7', '8', '9', '10', '11', '12'], ARRAY['Black', 'White', 'Gray'], 'Textile and Synthetic', 'Wipe clean', 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800', ARRAY[]::TEXT[], 4.8, 1456, true, false, false, true, 89, NOW(), NOW()),
  
  ('d3333333-3333-3333-3333-333333333333', 'NK-SL-001', 'amazon', 'https://www.amazon.ae/dp/NK-SL-001', 'Slides - Comfort Fit', 'Nike', 'Casual slides for everyday wear', 129.00, 179.00, 'AED', 28, 'shoes', 'sandals', ARRAY['minimalist'], ARRAY['7', '8', '9', '10', '11', '12'], ARRAY['Black', 'White', 'Navy'], 'Synthetic', 'Wipe clean', 'https://images.unsplash.com/photo-1603808033192-082d6919d3e1?w=800', ARRAY[]::TEXT[], 4.3, 667, false, false, false, true, 245, NOW(), NOW()),
  
  ('d4444444-4444-4444-4444-444444444444', 'AD-SK-001', 'amazon', 'https://www.amazon.ae/dp/AD-SK-001', 'Skate Shoes - Classic', 'Adidas', 'Durable skate shoes with reinforced toe', 279.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['streetwear_edge'], ARRAY['7', '8', '9', '10', '11', '12'], ARRAY['Black', 'White/Green', 'Navy'], 'Canvas and Suede', 'Wipe clean', 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800', ARRAY[]::TEXT[], 4.5, 523, false, true, false, true, 134, NOW(), NOW()),
  
  ('d5555555-5555-5555-5555-555555555555', 'NK-JR-001', 'amazon', 'https://www.amazon.ae/dp/NK-JR-001', 'Air Jordan Retro', 'Nike', 'Iconic Jordan silhouette', 749.00, 899.00, 'AED', 17, 'shoes', 'sneakers', ARRAY['streetwear_edge'], ARRAY['7', '8', '9', '10', '11', '12'], ARRAY['Red/Black', 'White/Blue', 'Black/Gold'], 'Leather', 'Wipe clean', 'https://images.unsplash.com/photo-1614252369475-531eba835eb1?w=800', ARRAY[]::TEXT[], 4.9, 2134, true, false, false, true, 45, NOW(), NOW()),
  
  ('d6666666-6666-6666-6666-666666666666', 'AD-CL-001', 'amazon', 'https://www.amazon.ae/dp/AD-CL-001', 'Chelsea Boots - Leather', 'Adidas', 'Premium leather Chelsea boots', 529.00, NULL, 'AED', 0, 'shoes', 'boots', ARRAY['minimalist'], ARRAY['7', '8', '9', '10', '11', '12'], ARRAY['Black', 'Brown'], '100% Leather', 'Polish regularly', 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=800', ARRAY[]::TEXT[], 4.7, 345, false, true, false, true, 67, NOW(), NOW()),
  
  -- Accessories (4 items)
  ('e1111111-1111-1111-1111-111111111111', 'HM-BG-001', 'amazon', 'https://www.amazon.ae/dp/HM-BG-001', 'Canvas Backpack', 'H&M', 'Spacious canvas backpack for daily use', 149.00, 199.00, 'AED', 25, 'accessories', 'bags', ARRAY['minimalist', 'urban_vibe'], ARRAY['One Size'], ARRAY['Black', 'Navy', 'Olive'], 'Canvas and Leather', 'Spot clean', 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800', ARRAY[]::TEXT[], 4.4, 456, false, false, false, true, 189, NOW(), NOW()),
  
  ('e2222222-2222-2222-2222-222222222222', 'SB-CP-001', 'amazon', 'https://www.amazon.ae/dp/SB-CP-001', 'Snapback Cap', 'Supreme Basics', 'Classic snapback with embroidered logo', 99.00, NULL, 'AED', 0, 'accessories', 'hats', ARRAY['streetwear_edge'], ARRAY['One Size'], ARRAY['Black', 'White', 'Red'], 'Cotton Twill', 'Hand wash', 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=800', ARRAY[]::TEXT[], 4.2, 234, true, false, false, true, 345, NOW(), NOW()),
  
  ('e3333333-3333-3333-3333-333333333333', 'MG-BL-002', 'amazon', 'https://www.amazon.ae/dp/MG-BL-002', 'Leather Belt - Classic', 'Mango', 'Premium leather belt with silver buckle', 129.00, 179.00, 'AED', 28, 'accessories', 'belts', ARRAY['minimalist'], ARRAY['S', 'M', 'L'], ARRAY['Black', 'Brown', 'Tan'], '100% Leather', 'Polish regularly', 'https://images.unsplash.com/photo-1624222247344-550fb60583bb?w=800', ARRAY[]::TEXT[], 4.5, 167, false, false, false, true, 234, NOW(), NOW()),
  
  ('e4444444-4444-4444-4444-444444444444', 'HM-SC-001', 'amazon', 'https://www.amazon.ae/dp/HM-SC-001', 'Wool Scarf', 'H&M', 'Soft wool scarf in classic patterns', 79.00, 119.00, 'AED', 34, 'accessories', 'scarves', ARRAY['minimalist'], ARRAY['One Size'], ARRAY['Gray', 'Black', 'Burgundy'], '100% Wool', 'Dry clean', 'https://images.unsplash.com/photo-1520903920243-00d872a2d1c9?w=800', ARRAY[]::TEXT[], 4.6, 523, false, true, false, true, 412, NOW(), NOW())
ON CONFLICT (external_id) DO NOTHING;

-- ==============================================
-- 3. CREATE MOCK USER FOR TESTING
-- ==============================================

-- Insert test user
INSERT INTO users (
  id, anonymous_id, is_anonymous, email, 
  gender_preference, style_preferences, price_tier,
  preferred_categories, preferred_brands, preferred_colors,
  total_swirls, total_swipes, days_active,
  created_at, updated_at, last_seen_at
)
VALUES (
  '99999999-9999-9999-9999-999999999999',
  '88888888-8888-8888-8888-888888888888',
  false,
  'test@swirl.app',
  'men',
  ARRAY['minimalist', 'urban_vibe'],
  'mid_range',
  ARRAY['men', 'shoes'],
  ARRAY['Nike', 'Uniqlo', 'Amazon Essentials'],
  ARRAY['Black', 'White', 'Navy'],
  15,
  127,
  7,
  NOW() - INTERVAL '7 days',
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- ==============================================
-- 4. INSERT WEEKLY OUTFITS FOR TEST USER
-- ==============================================

-- Calculate current week start (Monday)
DO $$
DECLARE
  week_start DATE := DATE_TRUNC('week', CURRENT_DATE);
  test_user_id UUID := '99999999-9999-9999-9999-999999999999';
BEGIN
  -- Coordinated Outfit 1: Casual Friday
  INSERT INTO weekly_outfits (
    id, user_id, outfit_type,
    top_product_id, bottom_product_id, shoes_product_id, accessory_product_id,
    confidence_score, was_viewed, was_liked, week_start_date, created_at
  )
  VALUES (
    'o1111111-1111-1111-1111-111111111111',
    test_user_id,
    'coordinated',
    'a1111111-1111-1111-1111-111111111111', -- Oxford Shirt
    'b1111111-1111-1111-1111-111111111111', -- Slim Chinos
    'd1111111-1111-1111-1111-111111111111', -- High-Top Sneakers
    NULL,
    0.92,
    false,
    false,
    week_start,
    NOW()
  )
  ON CONFLICT DO NOTHING;

  -- Coordinated Outfit 2: Smart Casual
  INSERT INTO weekly_outfits (
    id, user_id, outfit_type,
    top_product_id, bottom_product_id, shoes_product_id, accessory_product_id,
    confidence_score, was_viewed, was_liked, week_start_date, created_at
  )
  VALUES (
    'o2222222-2222-2222-2222-222222222222',
    test_user_id,
    'coordinated',
    'a5555555-5555-5555-5555-555555555555', -- Polo Shirt
    'b1111111-1111-1111-1111-111111111111', -- Slim Chinos
    'd6666666-6666-6666-6666-666666666666', -- Chelsea Boots
    'e3333333-3333-3333-3333-333333333333', -- Leather Belt
    0.87,
    false,
    false,
    week_start,
    NOW()
  )
  ON CONFLICT DO NOTHING;

  -- Individual High-Confidence Items (5 items)
  INSERT INTO weekly_outfits (
    id, user_id, outfit_type, product_id,
    confidence_score, was_viewed, was_liked, week_start_date, created_at
  )
  VALUES
    ('o3333333-3333-3333-3333-333333333333', test_user_id, 'individual_item', 'a2222222-2222-2222-2222-222222222222', 0.89, false, false, week_start, NOW()),
    ('o4444444-4444-4444-4444-444444444444', test_user_id, 'individual_item', 'a3333333-3333-3333-3333-333333333333', 0.85, false, false, week_start, NOW()),
    ('o5555555-5555-5555-5555-555555555555', test_user_id, 'individual_item', 'd2222222-2222-2222-2222-222222222222', 0.91, false, false, week_start, NOW()),
    ('o6666666-6666-6666-6666-666666666666', test_user_id, 'individual_item', 'b2222222-2222-2222-2222-222222222222', 0.82, false, false, week_start, NOW()),
    ('o7777777-7777-7777-7777-777777777777', test_user_id, 'individual_item', 'e2222222-2222-2222-2222-222222222222', 0.78, false, false, week_start, NOW())
  ON CONFLICT DO NOTHING;

END $$;

-- ==============================================
-- 5. INSERT SAMPLE SWIPE DATA
-- ==============================================

-- Create some swipe history for the test user
INSERT INTO swipes (
  user_id, product_id, session_id, direction, swipe_action,
  dwell_ms, card_position, price, brand, category, style_tags,
  created_at
)
SELECT
  '99999999-9999-9999-9999-999999999999',
  id,
  'session-001',
  CASE WHEN RANDOM() < 0.3 THEN 'right' ELSE 'up' END,
  CASE WHEN RANDOM() < 0.3 THEN 'like' ELSE 'skip' END,
  (1000 + RANDOM() * 4000)::INTEGER,
  (RANDOM() * 20)::INTEGER,
  price,
  brand,
  category,
  style_tags,
  NOW() - (RANDOM() * INTERVAL '7 days')
FROM products
LIMIT 50
ON CONFLICT DO NOTHING;

-- ==============================================
-- 6. INSERT SAMPLE SWIRLS (LIKED ITEMS)
-- ==============================================

INSERT INTO swirls (user_id, product_id, source, created_at)
SELECT
  '99999999-9999-9999-9999-999999999999',
  id,
  'swipe_right',
  NOW() - (RANDOM() * INTERVAL '5 days')
FROM products
WHERE category = 'men'
LIMIT 15
ON CONFLICT DO NOTHING;

-- ==============================================
-- 7. VERIFICATION QUERIES
-- ==============================================

-- Count products by category
SELECT category, COUNT(*) as count
FROM products
GROUP BY category
ORDER BY count DESC;

-- List brands with product counts
SELECT b.name, b.total_products, b.follower_count
FROM brands b
ORDER BY b.follower_count DESC;

-- Show weekly outfits for test user
SELECT 
  wo.outfit_type,
  wo.confidence_score,
  CASE 
    WHEN wo.outfit_type = 'coordinated' THEN 
      'Top: ' || pt.name || ' | Bottom: ' || pb.name || ' | Shoes: ' || ps.name
    ELSE
      'Item: ' || pi.name
  END as outfit_details
FROM weekly_outfits wo
LEFT JOIN products pt ON wo.top_product_id = pt.id
LEFT JOIN products pb ON wo.bottom_product_id = pb.id
LEFT JOIN products ps ON wo.shoes_product_id = ps.id
LEFT JOIN products pi ON wo.product_id = pi.id
WHERE wo.user_id = '99999999-9999-9999-9999-999999999999'
ORDER BY wo.confidence_score DESC;

-- Success message
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Enhanced Mock Data inserted successfully!';
    RAISE NOTICE '========================================';
    RAISE NOTICE '✓ 8 Brands';
    RAISE NOTICE '✓ 25 Products (Men, Women, Shoes, Accessories)';
    RAISE NOTICE '✓ 1 Test User';
    RAISE NOTICE '✓ 7 Weekly Outfit Recommendations';
    RAISE NOTICE '✓ 50 Swipe Records';
    RAISE NOTICE '✓ 15 Liked Items (Swirls)';
    RAISE NOTICE '';
    RAISE NOTICE 'Test User ID: 99999999-9999-9999-9999-999999999999';
    RAISE NOTICE 'Email: test@swirl.app';
    RAISE NOTICE '';
    RAISE NOTICE 'Ready to test the SWIRL app UI!';
    RAISE NOTICE '========================================';
END $$;