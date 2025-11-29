-- ============================================================================
-- LUXURY FASHION PRODUCT SEEDING SCRIPT - PART 2
-- ============================================================================
-- This is a continuation - adds products 41-200+
-- Run after luxury_fashion_seed.sql or combine into one transaction
-- ============================================================================

BEGIN;

INSERT INTO products (
  id, external_id, source_store, source_url, name, brand, description,
  price, original_price, currency, discount_percentage, category, subcategory,
  style_tags, sizes, colors, materials, care_instructions,
  primary_image_url, rating, review_count, is_trending, is_new_arrival,
  is_flash_sale, is_in_stock, stock_count
)
VALUES

-- ============================================================================
-- GUCCI PRODUCTS (20 items - products 41-60)
-- ============================================================================

-- Gucci Handbags
('p0000003-0003-0003-0003-000000000041', 'GUCCI-MARMONT-041', 'other', 'https://www.gucci.com/marmont',
 'GG Marmont Small Matelassé', 'Gucci', 'Iconic shoulder bag with matelassé chevron leather and Double G hardware.',
 8500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'urban_vibe'],
 ARRAY['Small'], ARRAY['Black', 'Dusty Pink', 'White'], 'Matelassé Leather', 'Professional care',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800', 4.8, 1567, true, false, false, true, 22),

('p0000003-0003-0003-0003-000000000042', 'GUCCI-DIONYSUS-042', 'other', 'https://www.gucci.com/dionysus',
 'Dionysus GG Supreme Shoulder Bag', 'Gucci', 'Signature bag with tiger head closure in GG Supreme canvas.',
 9200.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'avant_garde'],
 ARRAY['Medium'], ARRAY['Beige/Ebony', 'Black'], 'GG Supreme Canvas', 'Avoid water',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', 4.9, 892, true, true, false, true, 18),

('p0000003-0003-0003-0003-000000000043', 'GUCCI-BAMBOO-043', 'other', 'https://www.gucci.com/bamboo',
 'Gucci Bamboo 1947 Top Handle', 'Gucci', 'Elegant top handle bag with iconic bamboo detail.',
 12500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['Medium'], ARRAY['Black', 'Brown', 'Red'], 'Leather', 'Professional cleaning',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800', 4.8, 445, false, true, false, true, 12),

('p0000003-0003-0003-0003-000000000044', 'GUCCI-JACKIE-044', 'other', 'https://www.gucci.com/jackie',
 'Jackie 1961 Small Hobo Bag', 'Gucci', 'Timeless hobo bag with piston closure and soft leather.',
 10800.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'minimalist'],
 ARRAY['Small'], ARRAY['Black', 'Camel', 'Burgundy'], 'Soft Leather', 'Avoid moisture',
 'https://images.unsplash.com/photo-1564221710304-0b37c8b9d729?w=800', 4.7, 567, false, false, false, true, 15),

-- Gucci Shoes
('p0000003-0003-0003-0003-000000000045', 'GUCCI-ACE-045', 'other', 'https://www.gucci.com/ace',
 'Ace Leather Sneaker', 'Gucci', 'Classic white leather sneaker with signature Web stripe.',
 2850.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43', '44'], ARRAY['White/Green-Red', 'White/Blue-Red'], 'Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', 4.9, 2234, true, false, false, true, 45),

('p0000003-0003-0003-0003-000000000046', 'GUCCI-LOAFER-046', 'other', 'https://www.gucci.com/loafers',
 'Jordaan Leather Loafer', 'Gucci', 'Iconic loafer with horsebit detail in smooth leather.',
 3200.00, NULL, 'AED', 0, 'shoes', 'loafers', ARRAY['luxury', 'minimalist'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43'], ARRAY['Black', 'Brown', 'Burgundy'], 'Leather', 'Polish regularly',
 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=800', 4.8, 1345, true, false, false, true, 35),

('p0000003-0003-0003-0003-000000000047', 'GUCCI-HEEL-047', 'other', 'https://www.gucci.com/heels',
 'Leather Mid-Heel Pump', 'Gucci', 'Elegant pump with Double G hardware and comfortable heel.',
 3600.00, NULL, 'AED', 0, 'shoes', 'heels', ARRAY['luxury'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Black', 'Nude', 'Red'], 'Leather', 'Professional care',
 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800', 4.7, 678, false, true, false, true, 28),

('p0000003-0003-0003-0003-000000000048', 'GUCCI-SLIPPER-048', 'other', 'https://www.gucci.com/slippers',
 'Princetown Leather Slipper', 'Gucci', 'Backless leather slipper with iconic horsebit.',
 2950.00, NULL, 'AED', 0, 'shoes', 'slippers', ARRAY['luxury', 'urban_vibe'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43'], ARRAY['Black', 'Brown', 'White'], 'Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1603808033192-082d6919d3e1?w=800', 4.8, 1123, false, false, false, true, 30),

-- Gucci Apparel
('p0000003-0003-0003-0003-000000000049', 'GUCCI-TSHIRT-049', 'other', 'https://www.gucci.com/tshirt',
 'GG Logo Cotton T-Shirt', 'Gucci', 'Premium cotton t-shirt with oversized GG logo print.',
 2400.00, NULL, 'AED', 0, 'unisex', 't-shirts', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['XS', 'S', 'M', 'L', 'XL', 'XXL'], ARRAY['White', 'Black', 'Pink'], '100% Cotton', 'Machine wash',
 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800', 4.7, 989, true, false, false, true, 50),

('p0000003-0003-0003-0003-000000000050', 'GUCCI-HOODIE-050', 'other', 'https://www.gucci.com/hoodie',
 'GG Cotton Sweatshirt', 'Gucci', 'Contemporary hoodie with GG motif and comfortable fit.',
 4200.00, NULL, 'AED', 0, 'unisex', 'hoodies', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['S', 'M', 'L', 'XL', 'XXL'], ARRAY['Black', 'Gray', 'Navy'], '100% Cotton', 'Machine wash cold',
 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800', 4.8, 756, true, true, false, true, 35),

('p0000003-0003-0003-0003-000000000051', 'GUCCI-JACKET-051', 'other', 'https://www.gucci.com/jacket',
 'GG Canvas Bomber Jacket', 'Gucci', 'Classic bomber with GG Supreme canvas and leather trim.',
 12800.00, NULL, 'AED', 0, 'men', 'jackets', ARRAY['luxury', 'urban_vibe'],
 ARRAY['46', '48', '50', '52'], ARRAY['Beige/Ebony', 'Black'], 'Canvas & Leather', 'Professional care',
 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800', 4.9, 334, true, true, false, true, 12),

('p0000003-0003-0003-0003-000000000052', 'GUCCI-SHIRT-052', 'other', 'https://www.gucci.com/shirt',
 'Silk Bowling Shirt', 'Gucci', 'Luxurious silk shirt with retro-inspired print.',
 4800.00, NULL, 'AED', 0, 'men', 'shirts', ARRAY['luxury', 'avant_garde'],
 ARRAY['S', 'M', 'L', 'XL'], ARRAY['Multi-Color', 'Black'], '100% Silk', 'Dry clean only',
 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800', 4.7, 445, false, true, false, true, 20),

('p0000003-0003-0003-0003-000000000053', 'GUCCI-PANTS-053', 'other', 'https://www.gucci.com/pants',
 'Wool Tailored Trousers', 'Gucci', 'Refined wool trousers with impeccable fit.',
 3400.00, NULL, 'AED', 0, 'men', 'pants', ARRAY['luxury', 'minimalist'],
 ARRAY['46', '48', '50', '52', '54'], ARRAY['Navy', 'Black', 'Gray'], '100% Wool', 'Dry clean',
 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', 4.6, 567, false, false, false, true, 30),

('p0000003-0003-0003-0003-000000000054', 'GUCCI-DRESS-054', 'other', 'https://www.gucci.com/dress',
 'Silk Jersey Dress', 'Gucci', 'Elegant dress with GG motif and flowing silhouette.',
 8900.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['luxury', 'avant_garde'],
 ARRAY['36', '38', '40', '42', '44'], ARRAY['Black', 'Navy', 'Red'], '100% Silk Jersey', 'Dry clean',
 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 4.8, 289, true, true, false, true, 18),

('p0000003-0003-0003-0003-000000000055', 'GUCCI-SKIRT-055', 'other', 'https://www.gucci.com/skirt',
 'GG Canvas Pleated Skirt', 'Gucci', 'Pleated midi skirt in iconic GG canvas.',
 4200.00, NULL, 'AED', 0, 'women', 'skirts', ARRAY['luxury'],
 ARRAY['36', '38', '40', '42'], ARRAY['Beige/Ebony', 'Black'], 'GG Canvas', 'Dry clean',
 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800', 4.7, 345, false, false, false, true, 25),

-- Gucci Accessories
('p0000003-0003-0003-0003-000000000056', 'GUCCI-BELT-056', 'other', 'https://www.gucci.com/belt',
 'GG Leather Belt', 'Gucci', 'Classic leather belt with Double G buckle.',
 1950.00, NULL, 'AED', 0, 'accessories', 'belts', ARRAY['luxury'],
 ARRAY['75cm', '80cm', '85cm', '90cm', '95cm'], ARRAY['Black', 'Brown', 'White'], 'Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1553704571-9d00c552c51f?w=800', 4.8, 1567, false, false, false, true, 60),

('p0000003-0003-0003-0003-000000000057', 'GUCCI-WALLET-057', 'other', 'https://www.gucci.com/wallet',
 'GG Marmont Zip Around Wallet', 'Gucci', 'Compact wallet with matelassé leather and Double G.',
 2200.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'Pink', 'Red'], 'Matelassé Leather', 'Wipe with soft cloth',
 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800', 4.7, 890, false, false, false, true, 40),

('p0000003-0003-0003-0003-000000000058', 'GUCCI-SUNGLASSES-058', 'other', 'https://www.gucci.com/sunglasses',
 'GG0061S Oversized Sunglasses', 'Gucci', 'Bold oversized sunglasses with signature Web detail.',
 1850.00, NULL, 'AED', 0, 'accessories', 'eyewear', ARRAY['luxury', 'avant_garde'],
 ARRAY['One Size'], ARRAY['Black/Green-Red', 'Tortoise'], 'Acetate', 'Clean with cloth',
 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800', 4.8, 678, true, false, false, true, 45),

('p0000003-0003-0003-0003-000000000059', 'GUCCI-SCARF-059', 'other', 'https://www.gucci.com/scarf',
 'GG Pattern Silk Scarf', 'Gucci', 'Luxurious silk scarf with iconic GG pattern.',
 1650.00, NULL, 'AED', 0, 'accessories', 'scarves', ARRAY['luxury'],
 ARRAY['90x90cm'], ARRAY['Beige/Ebony', 'Pink/Red', 'Blue/Red'], '100% Silk', 'Dry clean',
 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=800', 4.7, 556, false, false, false, true, 50),

('p0000003-0003-0003-0003-000000000060', 'GUCCI-HAT-060', 'other', 'https://www.gucci.com/hat',
 'GG Canvas Baseball Cap', 'Gucci', 'Classic baseball cap in GG Supreme canvas.',
 1450.00, NULL, 'AED', 0, 'accessories', 'hats', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['S', 'M', 'L'], ARRAY['Beige/Ebony', 'Black'], 'GG Canvas', 'Spot clean',
 'https://images.unsplash.com/photo-1575428652377-a2d80e2277fc?w=800', 4.6, 789, false, true, false, true, 55),

-- ============================================================================
-- PRADA PRODUCTS (20 items - products 61-80)
-- ============================================================================

-- Prada Handbags
('p0000004-0004-0004-0004-000000000061', 'PRADA-GALLERIA-061', 'other', 'https://www.prada.com/galleria',
 'Galleria Saffiano Leather Bag', 'Prada', 'Iconic structured bag in signature Saffiano leather.',
 11500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'minimalist'],
 ARRAY['Medium'], ARRAY['Black', 'Nude', 'Red'], 'Saffiano Leather', 'Professional care',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800', 4.9, 1234, true, false, false, true, 16),

('p0000004-0004-0004-0004-000000000062', 'PRADA-CAHIER-062', 'other', 'https://www.prada.com/cahier',
 'Cahier Leather Shoulder Bag', 'Prada', 'Vintage-inspired bag with metal corners and leather strap.',
 9800.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'avant_garde'],
 ARRAY['Medium'], ARRAY['Black', 'Astrology Print'], 'Calf Leather', 'Avoid moisture',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', 4.8, 678, true, true, false, true, 14),

('p0000004-0004-0004-0004-000000000063', 'PRADA-SIDONIE-063', 'other', 'https://www.prada.com/sidonie',
 'Sidonie Saffiano Leather Bag', 'Prada', 'Contemporary bag with curved silhouette in Saffiano leather.',
 8900.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['Medium'], ARRAY['Black', 'White', 'Pink'], 'Saffiano Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800', 4.7, 445, false, true, false, true, 18),

('p0000004-0004-0004-0004-000000000064', 'PRADA-CLEO-064', 'other', 'https://www.prada.com/cleo',
 'Cleo Brushed Leather Bag', 'Prada', 'Soft shoulder bag with curved shape and iconic triangle logo.',
 10200.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'minimalist'],
 ARRAY['Medium'], ARRAY['Black', 'Caramel', 'White'], 'Brushed Leather', 'Professional cleaning',
 'https://images.unsplash.com/photo-1564221710304-0b37c8b9d729?w=800', 4.8, 567, true, false, false, true, 12),

-- Prada Shoes
('p0000004-0004-0004-0004-000000000065', 'PRADA-CLOUDBUST-065', 'other', 'https://www.prada.com/cloudbust',
 'Cloudbust Thunder Sneakers', 'Prada', 'Chunky sneakers with technical fabric and rubber sole.',
 3800.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43', '44'], ARRAY['White/Silver', 'Black', 'Gray'], 'Tech Fabric & Rubber', 'Wipe clean',
 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', 4.7, 892, true, true, false, true, 30),

('p0000004-0004-0004-0004-000000000066', 'PRADA-LOAFER-066', 'other', 'https://www.prada.com/loafers',
 'Brushed Leather Loafers', 'Prada', 'Classic penny loafers in soft brushed leather.',
 3400.00, NULL, 'AED', 0, 'shoes', 'loafers', ARRAY['luxury', 'minimalist'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43'], ARRAY['Black', 'Brown'], 'Brushed Leather', 'Polish regularly',
 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=800', 4.8, 556, false, false, false, true, 25),

('p0000004-0004-0004-0004-000000000067', 'PRADA-HEEL-067', 'other', 'https://www.prada.com/heels',
 'Patent Leather Pumps', 'Prada', 'Sleek pumps with pointed toe and mid-height heel.',
 3200.00, NULL, 'AED', 0, 'shoes', 'heels', ARRAY['luxury'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Black', 'Nude', 'Red'], 'Patent Leather', 'Wipe with soft cloth',
 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800', 4.7, 445, false, false, false, true, 28),

('p0000004-0004-0004-0004-000000000068', 'PRADA-BOOT-068', 'other', 'https://www.prada.com/boots',
 'Monolith Brushed Leather Boots', 'Prada', 'Contemporary ankle boots with chunky sole.',
 4800.00, NULL, 'AED', 0, 'shoes', 'boots', ARRAY['luxury', 'urban_vibe'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Black', 'Brown'], 'Brushed Leather', 'Professional care',
 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=800', 4.8, 678, true, true, false, true, 22),

-- Prada Apparel
('p0000004-0004-0004-0004-000000000069', 'PRADA-SHIRT-069', 'other', 'https://www.prada.com/shirt',
 'Poplin Shirt with Triangle Logo', 'Prada', 'Clean-cut poplin shirt with subtle triangle logo.',
 2800.00, NULL, 'AED', 0, 'men', 'shirts', ARRAY['luxury', 'minimalist'],
 ARRAY['S', 'M', 'L', 'XL', 'XXL'], ARRAY['White', 'Light Blue', 'Black'], '100% Cotton Poplin', 'Machine wash',
 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800', 4.7, 567, false, false, false, true, 35),

('p0000004-0004-0004-0004-000000000070', 'PRADA-TSHIRT-070', 'other', 'https://www.prada.com/tshirt',
 'Cotton Jersey T-Shirt', 'Prada', 'Premium cotton t-shirt with triangle logo.',
 1850.00, NULL, 'AED', 0, 'unisex', 't-shirts', ARRAY['luxury'],
 ARRAY['XS', 'S', 'M', 'L', 'XL', 'XXL'], ARRAY['White', 'Black', 'Gray'], '100% Cotton', 'Machine wash',
 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800', 4.6, 789, false, false, false, true, 45),

('p0000004-0004-0004-0004-000000000071', 'PRADA-JACKET-071', 'other', 'https://www.prada.com/jacket',
 'Re-Nylon Bomber Jacket', 'Prada', 'Sustainable bomber jacket in innovative Re-Nylon fabric.',
 8900.00, NULL, 'AED', 0, 'unisex', 'jackets', ARRAY['luxury', 'urban_vibe'],
 ARRAY['S', 'M', 'L', 'XL'], ARRAY['Black', 'Navy', 'Sage Green'], 'Recycled Nylon', 'Wipe clean',
 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800', 4.9, 445, true, true, false, true, 20),

('p0000004-0004-0004-0004-000000000072', 'PRADA-BLAZER-072', 'other', 'https://www.prada.com/blazer',
 'Wool Mohair Single-Breasted Blazer', 'Prada', 'Refined blazer in luxurious wool mohair blend.',
 9800.00, NULL, 'AED', 0, 'men', 'blazers', ARRAY['luxury', 'minimalist'],
 ARRAY['46', '48', '50', '52'], ARRAY['Navy', 'Charcoal', 'Black'], '85% Wool, 15% Mohair', 'Dry clean only',
 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800', 4.8, 289, false, true, false, true, 15),

('p0000004-0004-0004-0004-000000000073', 'PRADA-PANTS-073', 'other', 'https://www.prada.com/pants',
 'Wool Twill Trousers', 'Prada', 'Elegant trousers in premium wool twill.',
 2900.00, NULL, 'AED', 0, 'men', 'pants', ARRAY['luxury'],
 ARRAY['46', '48', '50', '52', '54'], ARRAY['Navy', 'Black', 'Gray'], '100% Wool', 'Dry clean',
 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', 4.7, 445, false, false, false, true, 30),

('p0000004-0004-0004-0004-000000000074', 'PRADA-DRESS-074', 'other', 'https://www.prada.com/dress',
 'Re-Nylon Midi Dress', 'Prada', 'Contemporary dress in sustainable Re-Nylon with belt.',
 6800.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['luxury', 'avant_garde'],
 ARRAY['36', '38', '40', '42', '44'], ARRAY['Black', 'Navy'], 'Recycled Nylon', 'Machine wash',
 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 4.8, 334, true, true, false, true, 18),

('p0000004-0004-0004-0004-000000000075', 'PRADA-SWEATER-075', 'other', 'https://www.prada.com/sweater',
 'Cashmere Crewneck Sweater', 'Prada', 'Soft cashmere sweater with minimal branding.',
 3800.00, NULL, 'AED', 0, 'unisex', 'sweaters', ARRAY['luxury', 'minimalist'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Navy', 'Gray', 'Black', 'Camel'], '100% Cashmere', 'Hand wash',
 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800', 4.9, 567, false, false, false, true, 25),

('p0000004-0004-0004-0004-000000000076', 'PRADA-SKIRT-076', 'other', 'https://www.prada.com/skirt',
 'Re-Nylon Pleated Skirt', 'Prada', 'Modern pleated skirt in sustainable nylon.',
 3400.00, NULL, 'AED', 0, 'women', 'skirts', ARRAY['luxury'],
 ARRAY['36', '38', '40', '42'], ARRAY['Black', 'Navy', 'Khaki'], 'Recycled Nylon', 'Machine wash',
 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800', 4.7, 289, false, false, false, true, 28),

-- Prada Accessories
('p0000004-0004-0004-0004-000000000077', 'PRADA-WALLET-077', 'other', 'https://www.prada.com/wallet',
 'Saffiano Leather Wallet', 'Prada', 'Compact wallet in iconic Saffiano leather.',
 1950.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'Red', 'Nude'], 'Saffiano Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800', 4.8, 892, false, false, false, true, 40),

('p0000004-0004-0004-0004-000000000078', 'PRADA-BELT-078', 'other', 'https://www.prada.com/belt',
 'Saffiano Leather Belt', 'Prada', 'Classic leather belt with triangle logo buckle.',
 1650.00, NULL, 'AED', 0, 'accessories', 'belts', ARRAY['luxury', 'minimalist'],
 ARRAY['75cm', '80cm', '85cm', '90cm'], ARRAY['Black', 'Brown'], 'Saffiano Leather', 'Wipe with soft cloth',
 'https://images.unsplash.com/photo-1553704571-9d00c552c51f?w=800', 4.7, 678, false, false, false, true, 50),

('p0000004-0004-0004-0004-000000000079', 'PRADA-SUNGLASSES-079', 'other', 'https://www.prada.com/sunglasses',
 'Prada Linea Rossa Sunglasses', 'Prada', 'Sport-inspired sunglasses with technical design.',
 1750.00, NULL, 'AED', 0, 'accessories', 'eyewear', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['One Size'], ARRAY['Black/Red', 'White/Blue'], 'Nylon & Metal', 'Clean with cloth',
 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800', 4.8, 556, false, true, false, true, 45),

('p0000004-0004-0004-0004-000000000080', 'PRADA-BACKPACK-080', 'other', 'https://www.prada.com/backpack',
 'Re-Nylon Backpack', 'Prada', 'Sustainable backpack with triangle logo and multiple pockets.',
 4200.00, NULL, 'AED', 0, 'accessories', 'backpacks', ARRAY['luxury', 'urban_vibe'],
 ARRAY['One Size'], ARRAY['Black', 'Navy'], 'Recycled Nylon', 'Wipe clean',
 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800', 4.9, 789, true, false, false, true, 30);

COMMIT;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

DO $$
DECLARE
    v_product_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_product_count FROM products;
    RAISE NOTICE 'Part 2 Complete - Total products now: %', v_product_count;
END $$;