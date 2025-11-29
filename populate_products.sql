-- Upsert brands first
INSERT INTO brands (id, name, slug, style_tags, primary_category, total_products)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'Amazon Essentials', 'amazon-essentials', ARRAY['minimalist', 'urban_vibe'], 'men', 1),
  ('22222222-2222-2222-2222-222222222222', 'Supreme Basics', 'supreme-basics', ARRAY['streetwear_edge', 'urban_vibe'], 'men', 1),
  ('33333333-3333-3333-3333-333333333333', 'ZARA Couture', 'zara-couture', ARRAY['avant_garde'], 'women', 1),
  ('44444444-4444-4444-4444-444444444444', 'Uniqlo', 'uniqlo', ARRAY['minimalist'], 'unisex', 1),
  ('55555555-5555-5555-5555-555555555555', 'Nike', 'nike', ARRAY['streetwear_edge', 'urban_vibe'], 'shoes', 1)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  slug = EXCLUDED.slug,
  style_tags = EXCLUDED.style_tags,
  primary_category = EXCLUDED.primary_category,
  total_products = EXCLUDED.total_products;

-- Upsert products with dynamic Unsplash images
INSERT INTO products (id, external_id, source_store, source_url, name, brand, description, price, original_price, currency, discount_percentage, category, subcategory, style_tags, sizes, colors, materials, care_instructions, primary_image_url, additional_images, rating, review_count, is_trending, is_new_arrival, is_flash_sale, is_in_stock, stock_count)
VALUES 
  -- Product 1: Men's Slim Fit Oxford Shirt
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'B07XYZ1001', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1001', 
   'Men''s Slim Fit Oxford Shirt - Long Sleeve', 'Amazon Essentials', 
   'Classic oxford button-down shirt with modern slim fit. Perfect for business casual or everyday wear.',
   89.00, 129.00, 'AED', 31, 'men', 'shirts', ARRAY['minimalist', 'urban_vibe'],
   ARRAY['S', 'M', 'L', 'XL', 'XXL'], ARRAY['White', 'Light Blue', 'Navy', 'Black'],
   '100% Cotton', 'Machine wash cold. Tumble dry low.',
   'https://source.unsplash.com/800x800/?dress+shirt+fashion', ARRAY[]::text[],
   4.5, 234, false, true, false, true, 150),

  -- Product 2: Oversized Graphic Hoodie
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'B07XYZ1002', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1002',
   'Oversized Graphic Hoodie - Streetwear', 'Supreme Basics',
   'Bold oversized hoodie with graphic print. Premium heavyweight cotton blend for ultimate comfort.',
   245.00, NULL, 'AED', 0, 'men', 'hoodies', ARRAY['streetwear_edge', 'urban_vibe'],
   ARRAY['M', 'L', 'XL', 'XXL'], ARRAY['Black', 'Gray', 'Olive Green'],
   '80% Cotton, 20% Polyester', 'Machine wash cold inside out. Do not bleach.',
   'https://source.unsplash.com/800x800/?hoodie+streetwear', ARRAY[]::text[],
   4.7, 567, true, false, false, true, 85),

  -- Product 3: Avant-Garde Asymmetric Blazer
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'B07XYZ1003', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1003',
   'Avant-Garde Asymmetric Blazer', 'ZARA Couture',
   'Experimental design with asymmetric cut and unique draping. Statement piece for the fashion-forward.',
   899.00, 1299.00, 'AED', 31, 'women', 'blazers', ARRAY['avant_garde'],
   ARRAY['XS', 'S', 'M', 'L'], ARRAY['Black', 'Cream'],
   '65% Wool, 35% Polyester', 'Dry clean only.',
   'https://source.unsplash.com/800x800/?blazer+fashion', ARRAY[]::text[],
   4.3, 89, false, true, false, true, 25),

  -- Product 4: Minimalist Crew Neck T-Shirt Pack
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'B07XYZ1004', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1004',
   'Minimalist Crew Neck T-Shirt - Pack of 3', 'Uniqlo',
   'Essential basics in premium cotton. Clean lines and perfect fit for everyday layering.',
   119.00, NULL, 'AED', 0, 'unisex', 't-shirts', ARRAY['minimalist'],
   ARRAY['S', 'M', 'L', 'XL'], ARRAY['White', 'Black', 'Gray'],
   '100% Supima Cotton', 'Machine wash. Tumble dry low.',
   'https://source.unsplash.com/800x800/?tshirt+minimal', ARRAY[]::text[],
   4.8, 1234, true, false, false, true, 500),

  -- Product 5: Retro High-Top Sneakers
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'B07XYZ1005', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1005',
   'Retro High-Top Sneakers', 'Nike',
   'Classic basketball-inspired sneakers with modern comfort technology. Iconic design that never goes out of style.',
   349.00, 449.00, 'AED', 22, 'shoes', 'sneakers', ARRAY['streetwear_edge', 'urban_vibe'],
   ARRAY['7', '8', '9', '10', '11', '12'], ARRAY['White/Red', 'Black/White', 'Navy/Gold'],
   'Leather and Synthetic upper', 'Wipe clean with damp cloth.',
   'https://source.unsplash.com/800x800/?sneakers+shoes', ARRAY[]::text[],
   4.6, 892, true, false, true, true, 120),

  -- Product 6: Classic Chino Shorts
  ('ffffffff-ffff-ffff-ffff-ffffffffffff', 'B07XYZ1006', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1006',
   'Classic Chino Shorts - Summer Essential', 'Amazon Essentials',
   'Comfortable cotton chino shorts perfect for casual summer days. Classic fit with modern styling.',
   79.00, 99.00, 'AED', 20, 'men', 'shorts', ARRAY['minimalist', 'urban_vibe'],
   ARRAY['28', '30', '32', '34', '36'], ARRAY['Khaki', 'Navy', 'Black', 'Olive'],
   '98% Cotton, 2% Elastane', 'Machine wash cold. Tumble dry low.',
   'https://source.unsplash.com/800x800/?shorts+men+fashion', ARRAY[]::text[],
   4.4, 456, false, true, false, true, 200),

  -- Product 7: Slim Fit Denim Jeans
  ('10101010-1010-1010-1010-101010101010', 'B07XYZ1007', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1007',
   'Slim Fit Dark Wash Denim Jeans', 'Uniqlo',
   'Premium denim with stretch comfort. Versatile dark wash for any occasion.',
   159.00, NULL, 'AED', 0, 'men', 'jeans', ARRAY['minimalist', 'urban_vibe'],
   ARRAY['28', '30', '32', '34', '36', '38'], ARRAY['Dark Wash', 'Medium Wash', 'Black'],
   '92% Cotton, 6% Polyester, 2% Elastane', 'Machine wash cold. Hang dry.',
   'https://source.unsplash.com/800x800/?jeans+denim', ARRAY[]::text[],
   4.6, 789, true, false, false, true, 180),

  -- Product 8: Leather Bomber Jacket
  ('20202020-2020-2020-2020-202020202020', 'B07XYZ1008', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1008',
   'Classic Leather Bomber Jacket', 'Supreme Basics',
   'Timeless leather bomber with modern fit. Premium genuine leather construction.',
   799.00, 999.00, 'AED', 20, 'men', 'jackets', ARRAY['streetwear_edge', 'urban_vibe'],
   ARRAY['S', 'M', 'L', 'XL'], ARRAY['Black', 'Brown'],
   '100% Genuine Leather', 'Professional leather cleaning only.',
   'https://source.unsplash.com/800x800/?jacket+fashion', ARRAY[]::text[],
   4.8, 234, true, true, false, true, 45),

  -- Product 9: Floral Summer Dress
  ('30303030-3030-3030-3030-303030303030', 'B07XYZ1009', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1009',
   'Floral Print Summer Dress', 'ZARA Couture',
   'Lightweight floral dress perfect for summer occasions. Flattering silhouette with elegant draping.',
   259.00, 349.00, 'AED', 26, 'women', 'dresses', ARRAY['avant_garde'],
   ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Floral Blue', 'Floral Pink', 'Floral Yellow'],
   '100% Rayon', 'Hand wash cold. Line dry.',
   'https://source.unsplash.com/800x800/?dress+fashion', ARRAY[]::text[],
   4.7, 567, true, true, true, true, 95),

  -- Product 10: Wool Blend Sweater
  ('40404040-4040-4040-4040-404040404040', 'B07XYZ1010', 'amazon', 'https://www.amazon.ae/dp/B07XYZ1010',
   'Merino Wool Crew Neck Sweater', 'Uniqlo',
   'Premium merino wool sweater. Soft, breathable, and perfect for layering.',
   199.00, NULL, 'AED', 0, 'unisex', 'sweaters', ARRAY['minimalist'],
   ARRAY['S', 'M', 'L', 'XL'], ARRAY['Navy', 'Gray', 'Burgundy', 'Forest Green'],
   '100% Merino Wool', 'Hand wash cold. Lay flat to dry.',
   'https://source.unsplash.com/800x800/?sweater+fashion', ARRAY[]::text[],
   4.9, 1123, false, false, false, true, 250)

ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  brand = EXCLUDED.brand,
  description = EXCLUDED.description,
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  primary_image_url = EXCLUDED.primary_image_url,
  rating = EXCLUDED.rating,
  review_count = EXCLUDED.review_count,
  is_trending = EXCLUDED.is_trending,
  is_new_arrival = EXCLUDED.is_new_arrival,
  is_flash_sale = EXCLUDED.is_flash_sale,
  stock_count = EXCLUDED.stock_count;