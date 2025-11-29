-- ============================================================================
-- FINAL PRODUCTS PART 4 - Bottega Veneta & Balenciaga (40 items)
-- ============================================================================
-- Products 181-220 to complete 200+ luxury items requirement
-- Run this AFTER previous parts
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
-- BOTTEGA VENETA PRODUCTS (20 items - products 181-200)
-- ============================================================================

('p0000009-0009-0009-0009-000000000181', 'BV-CASSETTE-181', 'other', 'https://www.bottegaveneta.com/cassette',
 'Cassette Padded Bag', 'Bottega Veneta', 'Iconic intrecciato woven leather bag.',
 12500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'avant_garde'],
 ARRAY['Medium'], ARRAY['Black', 'Parakeet', 'Fondant'], 'Intrecciato Leather', 'Professional care',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800', 4.9, 1890, true, true, false, true, 18),

('p0000009-0009-0009-0009-000000000182', 'BV-JODIE-182', 'other', 'https://www.bottegaveneta.com/jodie',
 'Jodie Mini Hobo Bag', 'Bottega Veneta', 'Soft woven leather hobo with knot detail.',
 9800.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'minimalist'],
 ARRAY['Mini'], ARRAY['Black', 'Maple', 'Seagrass'], 'Intrecciato Nappa', 'Handle with care',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', 4.8, 1567, true, false, false, true, 22),

('p0000009-0009-0009-0009-000000000183', 'BV-ARCO-183', 'other', 'https://www.bottegaveneta.com/arco',
 'Arco Tote Bag', 'Bottega Veneta', 'Structured tote with signature intrecciato.',
 13500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['48'], ARRAY['Black', 'Parakeet', 'Fondant'], 'Intrecciato Calf Leather', 'Professional cleaning',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800', 4.9, 1234, true, true, false, true, 15),

('p0000009-0009-0009-0009-000000000184', 'BV-POUCH-184', 'other', 'https://www.bottegaveneta.com/pouch',
 'The Pouch Clutch', 'Bottega Veneta', 'Iconic gathered leather pouch.',
 6500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'minimalist'],
 ARRAY['Large'], ARRAY['Black', 'Bottega Green', 'Optic White'], 'Butter Calf Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1564221710304-0b37c8b9d729?w=800', 4.8, 2345, true, false, false, true, 25),

('p0000009-0009-0009-0009-000000000185', 'BV-BOOT-185', 'other', 'https://www.bottegaveneta.com/boots',
 'The Puddle Boots', 'Bottega Veneta', 'Iconic rubber boots with exaggerated silhouette.',
 3800.00, NULL, 'AED', 0, 'shoes', 'boots', ARRAY['luxury', 'avant_garde'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Black', 'Flash', 'Parakeet'], 'Rubber', 'Wipe clean',
 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=800', 4.7, 1678, true, true, false, true, 28),

('p0000009-0009-0009-0009-000000000186', 'BV-TIRE-186', 'other', 'https://www.bottegaveneta.com/tire',
 'Tire Chelsea Boots', 'Bottega Veneta', 'Bold Chelsea boots with oversized sole.',
 4200.00, NULL, 'AED', 0, 'shoes', 'boots', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['39', '40', '41', '42', '43', '44'], ARRAY['Black', 'Brown'], 'Leather', 'Professional care',
 'https://images.unsplash.com/photo-1542280756-74b2f55e73ab?w=800', 4.8, 1123, true, false, false, true, 22),

('p0000009-0009-0009-0009-000000000187', 'BV-SLIDER-187', 'other', 'https://www.bottegaveneta.com/slides',
 'Lido Intrecciato Slides', 'Bottega Veneta', 'Woven leather slides with square toe.',
 2450.00, NULL, 'AED', 0, 'shoes', 'sandals', ARRAY['luxury', 'minimalist'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43'], ARRAY['Black', 'Parakeet', 'Optic White'], 'Intrecciato Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1603487742131-4160ec999306?w=800', 4.7, 892, false, true, false, true, 35),

('p0000009-0009-0009-0009-000000000188', 'BV-COAT-188', 'other', 'https://www.bottegaveneta.com/coat',
 'Double-Face Cashmere Coat', 'Bottega Veneta', 'Luxurious oversized cashmere coat.',
 16500.00, NULL, 'AED', 0, 'unisex', 'coats', ARRAY['luxury', 'minimalist'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Camel', 'Black', 'Charcoal'], '100% Cashmere', 'Dry clean only',
 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=800', 4.9, 678, true, true, false, true, 12),

('p0000009-0009-0009-0009-000000000189', 'BV-SHIRT-189', 'other', 'https://www.bottegaveneta.com/shirt',
 'Cotton Poplin Shirt', 'Bottega Veneta', 'Contemporary oversized shirt in crisp cotton.',
 2850.00, NULL, 'AED', 0, 'unisex', 'shirts', ARRAY['luxury', 'minimalist'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['White', 'Black', 'Bottega Green'], '100% Cotton', 'Machine wash',
 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800', 4.7, 789, false, false, false, true, 40),

('p0000009-0009-0009-0009-000000000190', 'BV-PANTS-190', 'other', 'https://www.bottegaveneta.com/pants',
 'Wool Straight Leg Trousers', 'Bottega Veneta', 'Clean-cut trousers with modern silhouette.',
 3200.00, NULL, 'AED', 0, 'unisex', 'pants', ARRAY['luxury', 'minimalist'],
 ARRAY['44', '46', '48', '50', '52'], ARRAY['Black', 'Navy', 'Gray'], '100% Wool', 'Dry clean',
 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', 4.8, 567, false, false, false, true, 30),

('p0000009-0009-0009-0009-000000000191', 'BV-KNIT-191', 'other', 'https://www.bottegaveneta.com/knitwear',
 'Cashmere Crewneck Sweater', 'Bottega Veneta', 'Soft cashmere sweater with clean lines.',
 3800.00, NULL, 'AED', 0, 'unisex', 'sweaters', ARRAY['luxury', 'minimalist'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Black', 'Camel', 'Bottega Green'], '100% Cashmere', 'Hand wash',
 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800', 4.9, 445, false, true, false, true, 28),

('p0000009-0009-0009-0009-000000000192', 'BV-DRESS-192', 'other', 'https://www.bottegaveneta.com/dress',
 'Silk Satin Slip Dress', 'Bottega Veneta', 'Elegant slip dress in luxurious silk satin.',
 7800.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['luxury', 'minimalist'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Parakeet', 'Fondant'], 'Silk Satin', 'Dry clean',
 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 4.8, 678, false, true, false, true, 18),

('p0000009-0009-0009-0009-000000000193', 'BV-WALLET-193', 'other', 'https://www.bottegaveneta.com/wallet',
 'Intrecciato Bi-fold Wallet', 'Bottega Veneta', 'Classic woven leather wallet.',
 1950.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'Fondant', 'Parakeet'], 'Intrecciato Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800', 4.8, 892, false, false, false, true, 45),

('p0000009-0009-0009-0009-000000000194', 'BV-BELT-194', 'other', 'https://www.bottegaveneta.com/belt',
 'Intrecciato Leather Belt', 'Bottega Veneta', 'Woven leather belt with metal buckle.',
 1650.00, NULL, 'AED', 0, 'accessories', 'belts', ARRAY['luxury', 'minimalist'],
 ARRAY['75cm', '80cm', '85cm', '90cm', '95cm'], ARRAY['Black', 'Brown', 'Fondant'], 'Intrecciato Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1553704571-9d00c552c51f?w=800', 4.7, 567, false, false, false, true, 50),

('p0000009-0009-0009-0009-000000000195', 'BV-SUNGLASSES-195', 'other', 'https://www.bottegaveneta.com/sunglasses',
 'BV1123S Sunglasses', 'Bottega Veneta', 'Contemporary sunglasses with bold design.',
 1850.00, NULL, 'AED', 0, 'accessories', 'eyewear', ARRAY['luxury', 'avant_garde'],
 ARRAY['One Size'], ARRAY['Black', 'Tortoise', 'Transparent'], 'Acetate', 'Clean with cloth',
 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800', 4.8, 678, false, true, false, true, 35),

('p0000009-0009-0009-0009-000000000196', 'BV-BACKPACK-196', 'other', 'https://www.bottegaveneta.com/backpack',
 'Intrecciato Leather Backpack', 'Bottega Veneta', 'Functional backpack in signature weave.',
 5800.00, NULL, 'AED', 0, 'accessories', 'backpacks', ARRAY['luxury', 'urban_vibe'],
 ARRAY['One Size'], ARRAY['Black', 'Bottega Green', 'Brown'], 'Intrecciato Leather', 'Professional care',
 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800', 4.8, 445, false, false, false, true, 25),

('p0000009-0009-0009-0009-000000000197', 'BV-LOAFER-197', 'other', 'https://www.bottegaveneta.com/loafers',
 'Intrecciato Leather Loafers', 'Bottega Veneta', 'Woven leather loafers with almond toe.',
 3600.00, NULL, 'AED', 0, 'shoes', 'loafers', ARRAY['luxury', 'minimalist'],
 ARRAY['39', '40', '41', '42', '43', '44'], ARRAY['Black', 'Brown', 'Fondant'], 'Intrecciato Leather', 'Polish regularly',
 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=800', 4.9, 789, false, false, false, true, 28),

('p0000009-0009-0009-0009-000000000198', 'BV-JACKET-198', 'other', 'https://www.bottegaveneta.com/jacket',
 'Leather Bomber Jacket', 'Bottega Veneta', 'Contemporary bomber in soft lamb leather.',
 14500.00, NULL, 'AED', 0, 'unisex', 'jackets', ARRAY['luxury', 'urban_vibe'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Black', 'Brown'], '100% Lamb Leather', 'Professional care',
 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800', 4.8, 567, true, true, false, true, 15),

('p0000009-0009-0009-0009-000000000199', 'BV-SCARF-199', 'other', 'https://www.bottegaveneta.com/scarf',
 'Cashmere Scarf', 'Bottega Veneta', 'Soft cashmere scarf with fringe detail.',
 1450.00, NULL, 'AED', 0, 'accessories', 'scarves', ARRAY['luxury', 'minimalist'],
 ARRAY['One Size'], ARRAY['Black', 'Camel', 'Parakeet'], '100% Cashmere', 'Dry clean',
 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=800', 4.7, 678, false, false, false, true, 55),

('p0000009-0009-0009-0009-000000000200', 'BV-CARDHOLD-200', 'other', 'https://www.bottegaveneta.com/cardholder',
 'Intrecciato Card Holder', 'Bottega Veneta', 'Slim woven leather card holder.',
 950.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'Fondant', 'Bottega Green'], 'Intrecciato Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1533327325824-76bc4e62d560?w=800', 4.8, 892, false, false, false, true, 60),

-- ============================================================================
-- BALENCIAGA PRODUCTS (20 items - products 201-220)
-- ============================================================================

('p0000010-0010-0010-0010-000000000201', 'BAL-CITY-201', 'other', 'https://www.balenciaga.com/city',
 'City Bag Medium', 'Balenciaga', 'Iconic studded leather bag with signature hardware.',
 9800.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['Medium'], ARRAY['Black', 'Gray', 'Red'], 'Lambskin', 'Professional care',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800', 4.8, 1890, true, false, false, true, 20),

('p0000010-0010-0010-0010-000000000202', 'BAL-HOURGLASS-202', 'other', 'https://www.balenciaga.com/hourglass',
 'Hourglass Small Bag', 'Balenciaga', 'Structured bag with curved silhouette.',
 8500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'avant_garde'],
 ARRAY['Small'], ARRAY['Black', 'White', 'Pink'], 'Calfskin', 'Wipe clean',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', 4.9, 1567, true, true, false, true, 18),

('p0000010-0010-0010-0010-000000000203', 'BAL-TRIPLE-203', 'other', 'https://www.balenciaga.com/triple-s',
 'Triple S Sneakers', 'Balenciaga', 'Iconic chunky sneakers with layered sole.',
 4200.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43', '44'], ARRAY['White', 'Black', 'Gray'], 'Mesh & Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', 4.7, 2345, true, false, false, true, 35),

('p0000010-0010-0010-0010-000000000204', 'BAL-TRACK-204', 'other', 'https://www.balenciaga.com/track',
 'Track Sneakers', 'Balenciaga', 'Technical sneakers with exaggerated sole.',
 3850.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43', '44'], ARRAY['Black', 'White', 'Orange'], 'Technical Mesh', 'Wipe clean',
 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=800', 4.8, 1678, true, true, false, true, 30),

('p0000010-0010-0010-0010-000000000205', 'BAL-SPEED-205', 'other', 'https://www.balenciaga.com/speed',
 'Speed Trainers', 'Balenciaga', 'Sock-like sneakers with iconic silhouette.',
 3400.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['luxury', 'urban_vibe'],
 ARRAY['36', '37', '38', '39', '40', '41', '42', '43', '44'], ARRAY['Black', 'White', 'Red'], 'Knit Fabric', 'Hand wash',
 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800', 4.7, 1890, true, false, false, true, 40),

('p0000010-0010-0010-0010-000000000206', 'BAL-HOODIE-206', 'other', 'https://www.balenciaga.com/hoodie',
 'Logo Hoodie', 'Balenciaga', 'Oversized hoodie with bold logo print.',
 3800.00, NULL, 'AED', 0, 'unisex', 'hoodies', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['XS', 'S', 'M', 'L', 'XL', 'XXL'], ARRAY['Black', 'White', 'Gray'], '100% Cotton', 'Machine wash',
 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800', 4.8, 1234, true, true, false, true, 45),

('p0000010-0010-0010-0010-000000000207', 'BAL-TSHIRT-207', 'other', 'https://www.balenciaga.com/tshirt',
 'Logo T-Shirt', 'Balenciaga', 'Cotton t-shirt with signature logo.',
 1950.00, NULL, 'AED', 0, 'unisex', 't-shirts', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['XS', 'S', 'M', 'L', 'XL', 'XXL'], ARRAY['Black', 'White', 'Navy'], '100% Cotton', 'Machine wash',
 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800', 4.7, 1567, false, false, false, true, 60),

('p0000010-0010-0010-0010-000000000208', 'BAL-JACKET-208', 'other', 'https://www.balenciaga.com/jacket',
 'Denim Jacket', 'Balenciaga', 'Oversized denim jacket with logo detail.',
 4500.00, NULL, 'AED', 0, 'unisex', 'jackets', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Blue', 'Black'], '100% Cotton Denim', 'Machine wash',
 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800', 4.8, 892, true, false, false, true, 28),

('p0000010-0010-0010-0010-000000000209', 'BAL-BACKPACK-209', 'other', 'https://www.balenciaga.com/backpack',
 'Explorer Backpack', 'Balenciaga', 'Technical backpack with multiple pockets.',
 4200.00, NULL, 'AED', 0, 'accessories', 'backpacks', ARRAY['luxury', 'urban_vibe'],
 ARRAY['One Size'], ARRAY['Black', 'Navy', 'Orange'], 'Nylon', 'Spot clean',
 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800', 4.7, 1123, false, true, false, true, 32),

('p0000010-0010-0010-0010-000000000210', 'BAL-CAP-210', 'other', 'https://www.balenciaga.com/cap',
 'Logo Baseball Cap', 'Balenciaga', 'Cotton cap with embroidered logo.',
 950.00, NULL, 'AED', 0, 'accessories', 'hats', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['S', 'M', 'L'], ARRAY['Black', 'White', 'Red'], 'Cotton', 'Spot clean',
 'https://images.unsplash.com/photo-1575428652377-a2d80e2277fc?w=800', 4.6, 1678, false, false, false, true, 70),

('p0000010-0010-0010-0010-000000000211', 'BAL-PANTS-211', 'other', 'https://www.balenciaga.com/pants',
 'Track Pants', 'Balenciaga', 'Sporty track pants with logo detail.',
 2850.00, NULL, 'AED', 0, 'unisex', 'pants', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Black', 'Navy', 'Gray'], 'Polyester', 'Machine wash',
 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', 4.7, 892, false, false, false, true, 40),

('p0000010-0010-0010-0010-000000000212', 'BAL-COAT-212', 'other', 'https://www.balenciaga.com/coat',
 'Oversized Wool Coat', 'Balenciaga', 'Dramatic oversized coat in premium wool.',
 12500.00, NULL, 'AED', 0, 'unisex', 'coats', ARRAY['luxury', 'avant_garde'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Black', 'Camel', 'Gray'], '100% Wool', 'Dry clean only',
 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=800', 4.8, 678, true, true, false, true, 15),

('p0000010-0010-0010-0010-000000000213', 'BAL-BELT-213', 'other', 'https://www.balenciaga.com/belt',
 'B Logo Belt', 'Balenciaga', 'Leather belt with large B buckle.',
 1450.00, NULL, 'AED', 0, 'accessories', 'belts', ARRAY['luxury'],
 ARRAY['75cm', '80cm', '85cm', '90cm', '95cm'], ARRAY['Black', 'Brown'], 'Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1553704571-9d00c552c51f?w=800', 4.7, 789, false, false, false, true, 50),

('p0000010-0010-0010-0010-000000000214', 'BAL-SUNGLASSES-214', 'other', 'https://www.balenciaga.com/sunglasses',
 'Shield Sunglasses', 'Balenciaga', 'Futuristic shield sunglasses.',
 1650.00, NULL, 'AED', 0, 'accessories', 'eyewear', ARRAY['luxury', 'avant_garde'],
 ARRAY['One Size'], ARRAY['Black', 'Silver', 'Gold'], 'Metal & Plastic', 'Clean with cloth',
 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800', 4.8, 567, true, true, false, true, 35),

('p0000010-0010-0010-0010-000000000215', 'BAL-DRESS-215', 'other', 'https://www.balenciaga.com/dress',
 'Jersey Bodycon Dress', 'Balenciaga', 'Form-fitting dress in stretch jersey.',
 4800.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['luxury', 'urban_vibe'],
 ARRAY['XS', 'S', 'M', 'L'], ARRAY['Black', 'Navy', 'Red'], 'Jersey Fabric', 'Machine wash',
 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 4.7, 445, false, true, false, true, 25),

('p0000010-0010-0010-0010-000000000216', 'BAL-WALLET-216', 'other', 'https://www.balenciaga.com/wallet',
 'Cash Long Wallet', 'Balenciaga', 'Leather wallet with logo print.',
 1850.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'White', 'Red'], 'Calfskin', 'Wipe clean',
 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800', 4.7, 892, false, false, false, true, 45),

('p0000010-0010-0010-0010-000000000217', 'BAL-SWEATER-217', 'other', 'https://www.balenciaga.com/sweater',
 'Logo Crewneck Sweater', 'Balenciaga', 'Wool sweater with intarsia logo.',
 3400.00, NULL, 'AED', 0, 'unisex', 'sweaters', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Black', 'White', 'Navy'], '100% Wool', 'Hand wash',
 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800', 4.8, 678, false, false, false, true, 32),

('p0000010-0010-0010-0010-000000000218', 'BAL-SCARF-218', 'other', 'https://www.balenciaga.com/scarf',
 'Logo Wool Scarf', 'Balenciaga', 'Soft wool scarf with all-over logo.',
 1350.00, NULL, 'AED', 0, 'accessories', 'scarves', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'Gray', 'Red'], '100% Wool', 'Dry clean',
 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=800', 4.6, 567, false, false, false, true, 55),

('p0000010-0010-0010-0010-000000000219', 'BAL-BOOT-219', 'other', 'https://www.balenciaga.com/boots',
 'Knife Boots', 'Balenciaga', 'Pointed stiletto boots with extreme silhouette.',
 5200.00, NULL, 'AED', 0, 'shoes', 'boots', ARRAY['luxury', 'avant_garde'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Black', 'Silver'], 'Leather', 'Professional care',
 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=800', 4.8, 789, true, true, false, true, 22),

('p0000010-0010-0010-0010-000000000220', 'BAL-TOTE-220', 'other', 'https://www.balenciaga.com/tote',
 'Shopper Tote Bag', 'Balenciaga', 'Large tote with logo print.',
 3800.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'urban_vibe'],
 ARRAY['Large'], ARRAY['Black/White', 'Navy/White'], 'Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800', 4.7, 1123, false, false, false, true, 30);

COMMIT;

-- Verification query
SELECT 
  brand,
  COUNT(*) as product_count,
  MIN(price) as min_price,
  MAX(price) as max_price,
  AVG(price)::NUMERIC(10,2) as avg_price
FROM products
WHERE id >= 'p0000007-0007-0007-0007-000000000121'
GROUP BY brand
ORDER BY brand;

-- Total count check
SELECT COUNT(*) as total_products_added 
FROM products 
WHERE id >= 'p0000007-0007-0007-0007-000000000121';
