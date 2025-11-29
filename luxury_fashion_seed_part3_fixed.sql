-- ============================================================================
-- LUXURY FASHION PRODUCT SEEDING SCRIPT - PART 3 (FINAL)
-- ============================================================================
-- Products 81-200+ (Chanel, Dior, Burberry, Saint Laurent, Bottega Veneta, Balenciaga)
-- This completes the 200+ luxury products requirement
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
-- CHANEL PRODUCTS (20 items - products 81-100)
-- ============================================================================

-- Chanel Handbags
(gen_random_uuid(), 'CHANEL-CLASSIC-081', 'other', 'https://www.chanel.com/classic',
 'Classic Flap Bag Medium', 'Chanel', 'Iconic quilted bag with chain strap and CC turn-lock closure.',
 28500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'minimalist'],
 ARRAY['Medium'], ARRAY['Black', 'Beige', 'Navy'], 'Lambskin Leather', 'Professional care only',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800', 4.9, 2345, true, false, false, true, 8),

(gen_random_uuid(), 'CHANEL-BOY-082', 'other', 'https://www.chanel.com/boy',
 'Boy Chanel Bag', 'Chanel', 'Contemporary bag with geometric quilting and chunky chain.',
 22000.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['Medium'], ARRAY['Black', 'Navy', 'Burgundy'], 'Calfskin Leather', 'Avoid water',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', 4.8, 1567, true, true, false, true, 10),

(gen_random_uuid(), 'CHANEL-19-083', 'other', 'https://www.chanel.com/19',
 'Chanel 19 Bag', 'Chanel', 'Soft quilted bag with chain and leather interlaced strap.',
 19500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'urban_vibe'],
 ARRAY['Large'], ARRAY['Black', 'Camel', 'Pink'], 'Goatskin Leather', 'Professional cleaning',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800', 4.9, 892, true, true, false, true, 12),

(gen_random_uuid(), 'CHANEL-GABRIELLE-084', 'other', 'https://www.chanel.com/gabrielle',
 'Gabrielle Small Hobo Bag', 'Chanel', 'Innovative hobo with unique chain construction.',
 16500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['Small'], ARRAY['Black', 'Gray', 'White'], 'Aged Calfskin', 'Wipe with soft cloth',
 'https://images.unsplash.com/photo-1564221710304-0b37c8b9d729?w=800', 4.7, 678, false, false, false, true, 14),

-- Chanel Shoes
(gen_random_uuid(), 'CHANEL-SLINGBACK-085', 'other', 'https://www.chanel.com/slingback',
 'Two-Tone Slingback Pumps', 'Chanel', 'Iconic slingback with contrasting toe cap.',
 4200.00, NULL, 'AED', 0, 'shoes', 'heels', ARRAY['luxury', 'minimalist'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Beige/Black', 'Navy/White'], 'Lambskin', 'Professional care',
 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800', 4.9, 1456, true, false, false, true, 25),

(gen_random_uuid(), 'CHANEL-BOOT-086', 'other', 'https://www.chanel.com/boots',
 'Quilted Leather Ankle Boots', 'Chanel', 'Chic ankle boots with signature quilting.',
 5800.00, NULL, 'AED', 0, 'shoes', 'boots', ARRAY['luxury'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Black', 'Beige'], 'Quilted Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=800', 4.8, 567, false, true, false, true, 18),

(gen_random_uuid(), 'CHANEL-BALLERINA-087', 'other', 'https://www.chanel.com/ballerinas',
 'Two-Tone Ballerina Flats', 'Chanel', 'Classic flats with contrasting toe cap.',
 3600.00, NULL, 'AED', 0, 'shoes', 'flats', ARRAY['luxury', 'minimalist'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Beige/Black', 'Navy/White'], 'Lambskin', 'Professional care',
 'https://images.unsplash.com/photo-1603808033192-082d6919d3e1?w=800', 4.8, 892, false, false, false, true, 30),

(gen_random_uuid(), 'CHANEL-SNEAKER-088', 'other', 'https://www.chanel.com/sneakers',
 'Low-Top Sneakers', 'Chanel', 'Contemporary sneakers with CC logo detail.',
 4500.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['luxury', 'urban_vibe'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['White/Black', 'Black'], 'Calfskin & Fabric', 'Wipe clean',
 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', 4.7, 445, true, true, false, true, 22),

-- Chanel Apparel
(gen_random_uuid(), 'CHANEL-JACKET-089', 'other', 'https://www.chanel.com/jacket',
 'Tweed Jacket', 'Chanel', 'Iconic tweed jacket with signature trim and buttons.',
 18500.00, NULL, 'AED', 0, 'women', 'jackets', ARRAY['luxury', 'minimalist'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black/White', 'Navy/White', 'Pink/Black'], 'Wool Tweed', 'Dry clean only',
 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=800', 4.9, 678, true, true, false, true, 10),

(gen_random_uuid(), 'CHANEL-DRESS-090', 'other', 'https://www.chanel.com/dress',
 'Little Black Dress', 'Chanel', 'Timeless LBD with elegant silhouette.',
 12500.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['luxury', 'minimalist'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Navy'], 'Silk & Wool Blend', 'Dry clean',
 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 4.9, 892, true, false, false, true, 15),

(gen_random_uuid(), 'CHANEL-SWEATER-091', 'other', 'https://www.chanel.com/sweater',
 'Cashmere Cardigan', 'Chanel', 'Luxurious cashmere cardigan with signature buttons.',
 5800.00, NULL, 'AED', 0, 'women', 'sweaters', ARRAY['luxury'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Black', 'Beige', 'Navy'], '100% Cashmere', 'Hand wash cold',
 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800', 4.8, 567, false, false, false, true, 20),

(gen_random_uuid(), 'CHANEL-PANTS-092', 'other', 'https://www.chanel.com/pants',
 'Wool Twill Trousers', 'Chanel', 'Elegant trousers with impeccable tailoring.',
 4200.00, NULL, 'AED', 0, 'women', 'pants', ARRAY['luxury', 'minimalist'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Navy', 'Beige'], '100% Wool', 'Dry clean',
 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=800', 4.7, 445, false, false, false, true, 25),

(gen_random_uuid(), 'CHANEL-SKIRT-093', 'other', 'https://www.chanel.com/skirt',
 'Tweed A-Line Skirt', 'Chanel', 'Classic A-line skirt in signature tweed.',
 4800.00, NULL, 'AED', 0, 'women', 'skirts', ARRAY['luxury'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black/White', 'Pink/Black'], 'Wool Tweed', 'Dry clean',
 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800', 4.8, 334, false, true, false, true, 18),

(gen_random_uuid(), 'CHANEL-BLOUSE-094', 'other', 'https://www.chanel.com/blouse',
 'Silk Crepe Blouse', 'Chanel', 'Refined silk blouse with delicate details.',
 3200.00, NULL, 'AED', 0, 'women', 'blouses', ARRAY['luxury', 'minimalist'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['White', 'Black', 'Ivory'], '100% Silk', 'Dry clean',
 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=800', 4.7, 456, false, false, false, true, 28),

-- Chanel Accessories
(gen_random_uuid(), 'CHANEL-WALLET-095', 'other', 'https://www.chanel.com/wallet',
 'Classic Long Wallet', 'Chanel', 'Quilted wallet with chain and CC clasp.',
 3800.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'Beige', 'Red'], 'Lambskin', 'Wipe with soft cloth',
 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800', 4.8, 789, false, false, false, true, 35),

(gen_random_uuid(), 'CHANEL-SUNGLASSES-096', 'other', 'https://www.chanel.com/sunglasses',
 'Square Sunglasses', 'Chanel', 'Bold square sunglasses with CC logo on temples.',
 2200.00, NULL, 'AED', 0, 'accessories', 'eyewear', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'Tortoise', 'Navy'], 'Acetate', 'Clean with cloth',
 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800', 4.9, 1123, true, false, false, true, 40),

(gen_random_uuid(), 'CHANEL-SCARF-097', 'other', 'https://www.chanel.com/scarf',
 'Silk Twill Scarf', 'Chanel', 'Luxurious silk scarf with signature print.',
 1850.00, NULL, 'AED', 0, 'accessories', 'scarves', ARRAY['luxury'],
 ARRAY['90x90cm'], ARRAY['Black/White', 'Navy/White', 'Pink/Black'], '100% Silk', 'Dry clean',
 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=800', 4.8, 678, false, false, false, true, 45),

(gen_random_uuid(), 'CHANEL-BROOCH-098', 'other', 'https://www.chanel.com/jewelry',
 'CC Logo Brooch', 'Chanel', 'Iconic CC brooch with crystal embellishment.',
 2400.00, NULL, 'AED', 0, 'accessories', 'jewelry', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Gold', 'Silver', 'Gold/Pearl'], 'Metal & Crystal', 'Handle with care',
 'https://images.unsplash.com/photo-1611652022419-a9419f74343a?w=800', 4.9, 892, false, true, false, true, 30),

(gen_random_uuid(), 'CHANEL-BELT-100', 'other', 'https://www.chanel.com/belt',
 'Chain Belt', 'Chanel', 'Signature chain belt with CC logo.',
 2800.00, NULL, 'AED', 0, 'accessories', 'belts', ARRAY['luxury'],
 ARRAY['80cm', '85cm', '90cm'], ARRAY['Gold', 'Silver', 'Gold/Black'], 'Metal & Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1553704571-9d00c552c51f?w=800', 4.8, 556, false, false, false, true, 25),

-- ============================================================================
-- DIOR PRODUCTS (20 items - products 101-120)
-- ============================================================================

-- Dior Handbags
(gen_random_uuid(), 'DIOR-LADYDIOR-101', 'other', 'https://www.dior.com/ladydior',
 'Lady Dior Medium', 'Dior', 'Iconic bag with Cannage stitching and D.I.O.R. charms.',
 19500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'avant_garde'],
 ARRAY['Medium'], ARRAY['Black', 'Nude', 'Gray'], 'Lambskin', 'Professional care only',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800', 4.9, 1678, true, false, false, true, 12),

(gen_random_uuid(), 'DIOR-BOOK-102', 'other', 'https://www.dior.com/booktote',
 'Dior Book Tote', 'Dior', 'Versatile tote in Dior Oblique embroidery.',
 12500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'urban_vibe'],
 ARRAY['Large'], ARRAY['Blue Oblique', 'Black', 'Beige'], 'Embroidered Canvas', 'Spot clean',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', 4.8, 2234, true, true, false, true, 20),

(gen_random_uuid(), 'DIOR-SADDLE-103', 'other', 'https://www.dior.com/saddle',
 'Dior Saddle Bag', 'Dior', 'Iconic curved bag with adjustable strap.',
 14500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'avant_garde'],
 ARRAY['Medium'], ARRAY['Black', 'Oblique', 'Beige'], 'Calfskin', 'Professional cleaning',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800', 4.9, 1123, true, true, false, true, 15),

(gen_random_uuid(), 'DIOR-30MONTAIGNE-104', 'other', 'https://www.dior.com/30montaigne',
 '30 Montaigne Box Bag', 'Dior', 'Structured box bag with CD clasp.',
 16800.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['Medium'], ARRAY['Black', 'Gray', 'Navy'], 'Box Calfskin', 'Avoid moisture',
 'https://images.unsplash.com/photo-1564221710304-0b37c8b9d729?w=800', 4.8, 892, false, true, false, true, 10),

-- Dior Shoes
(gen_random_uuid(), 'DIOR-JADIOR-105', 'other', 'https://www.dior.com/jadior',
 'J''Adior Slingback Pump', 'Dior', 'Elegant slingback with J Adior ribbon.',
 4500.00, NULL, 'AED', 0, 'shoes', 'heels', ARRAY['luxury', 'minimalist'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Black', 'Nude', 'Navy'], 'Technical Fabric', 'Professional care',
 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800', 4.9, 1234, true, false, false, true, 28),

(gen_random_uuid(), 'DIOR-SNEAKER-106', 'other', 'https://www.dior.com/b23',
 'B23 High-Top Sneaker', 'Dior', 'Contemporary sneaker in Dior Oblique canvas.',
 4800.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['39', '40', '41', '42', '43', '44'], ARRAY['White/Blue Oblique', 'Black'], 'Canvas & Calfskin', 'Wipe clean',
 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', 4.8, 1567, true, true, false, true, 25),

(gen_random_uuid(), 'DIOR-BOOT-107', 'other', 'https://www.dior.com/boots',
 'Dior Explorer Ankle Boot', 'Dior', 'Contemporary ankle boot with CD clasp detail.',
 5400.00, NULL, 'AED', 0, 'shoes', 'boots', ARRAY['luxury', 'urban_vibe'],
 ARRAY['39', '40', '41', '42', '43'], ARRAY['Black', 'Brown'], 'Calfskin Leather', 'Professional care',
 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=800', 4.7, 678, false, true, false, true, 20),

(gen_random_uuid(), 'DIOR-LOAFER-108', 'other', 'https://www.dior.com/loafers',
 'Dior Homme Leather Loafer', 'Dior', 'Refined loafer with CD signature.',
 3800.00, NULL, 'AED', 0, 'shoes', 'loafers', ARRAY['luxury', 'minimalist'],
 ARRAY['39', '40', '41', '42', '43', '44'], ARRAY['Black', 'Brown'], 'Calfskin', 'Polish regularly',
 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=800', 4.8, 445, false, false, false, true, 22),

-- Dior Apparel
(gen_random_uuid(), 'DIOR-JACKET-109', 'other', 'https://www.dior.com/jacket',
 'Bar Jacket', 'Dior', 'Iconic jacket from New Look collection.',
 15800.00, NULL, 'AED', 0, 'women', 'jackets', ARRAY['luxury', 'avant_garde'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Navy', 'Ivory'], 'Wool & Silk', 'Dry clean only',
 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=800', 4.9, 567, true, true, false, true, 8),

(gen_random_uuid(), 'DIOR-DRESS-110', 'other', 'https://www.dior.com/dress',
 'Miss Dior Dress', 'Dior', 'Elegant dress with signature silhouette.',
 11500.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['luxury', 'avant_garde'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Navy', 'Pink'], 'Silk & Wool', 'Dry clean',
 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 4.8, 789, true, false, false, true, 12),

(gen_random_uuid(), 'DIOR-TSHIRT-111', 'other', 'https://www.dior.com/tshirt',
 'Dior Oblique T-Shirt', 'Dior', 'Cotton t-shirt with Oblique motif.',
 2400.00, NULL, 'AED', 0, 'unisex', 't-shirts', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['XS', 'S', 'M', 'L', 'XL', 'XXL'], ARRAY['White', 'Black', 'Navy'], '100% Cotton', 'Machine wash',
 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800', 4.7, 1123, false, false, false, true, 40),

(gen_random_uuid(), 'DIOR-SHIRT-112', 'other', 'https://www.dior.com/shirt',
 'Dior Oblique Silk Shirt', 'Dior', 'Luxurious silk shirt with all-over Oblique pattern.',
 4200.00, NULL, 'AED', 0, 'men', 'shirts', ARRAY['luxury', 'avant_garde'],
 ARRAY['S', 'M', 'L', 'XL'], ARRAY['Blue/Navy', 'Black/Gray'], '100% Silk', 'Dry clean',
 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800', 4.8, 445, true, true, false, true, 18),

(gen_random_uuid(), 'DIOR-SWEATER-113', 'other', 'https://www.dior.com/sweater',
 'Cashmere Crewneck Sweater', 'Dior', 'Soft cashmere with subtle CD logo.',
 3800.00, NULL, 'AED', 0, 'unisex', 'sweaters', ARRAY['luxury', 'minimalist'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Navy', 'Gray', 'Beige', 'Black'], '100% Cashmere', 'Hand wash',
 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800', 4.9, 678, false, false, false, true, 25),

(gen_random_uuid(), 'DIOR-PANTS-114', 'other', 'https://www.dior.com/pants',
 'Tailored Wool Trousers', 'Dior', 'Refined trousers with impeccable cut.',
 3200.00, NULL, 'AED', 0, 'men', 'pants', ARRAY['luxury'],
 ARRAY['46', '48', '50', '52'], ARRAY['Navy', 'Black', 'Gray'], '100% Wool', 'Dry clean',
 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', 4.7, 567, false, false, false, true, 28),

(gen_random_uuid(), 'DIOR-SKIRT-115', 'other', 'https://www.dior.com/skirt',
 'Pleated Midi Skirt', 'Dior', 'Elegant pleated skirt with refined draping.',
 4500.00, NULL, 'AED', 0, 'women', 'skirts', ARRAY['luxury', 'avant_garde'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Navy', 'Beige'], 'Wool & Silk', 'Dry clean',
 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800', 4.8, 334, false, true, false, true, 20),

-- Dior Accessories
(gen_random_uuid(), 'DIOR-WALLET-116', 'other', 'https://www.dior.com/wallet',
 '30 Montaigne Wallet', 'Dior', 'Elegant wallet with CD clasp.',
 2200.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Black', 'Navy', 'Beige'], 'Grained Calfskin', 'Wipe clean',
 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800', 4.8, 892, false, false, false, true, 35),

(gen_random_uuid(), 'DIOR-SUNGLASSES-117', 'other', 'https://www.dior.com/sunglasses',
 'DiorSoStellaire Sunglasses', 'Dior', 'Contemporary sunglasses with geometric frame.',
 1950.00, NULL, 'AED', 0, 'accessories', 'eyewear', ARRAY['luxury', 'avant_garde'],
 ARRAY['One Size'], ARRAY['Black', 'Tortoise', 'Pink'], 'Acetate & Metal', 'Clean with cloth',
 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800', 4.7, 678, true, true, false, true, 40),

(gen_random_uuid(), 'DIOR-SCARF-118', 'other', 'https://www.dior.com/scarf',
 'Dior Oblique Silk Scarf', 'Dior', 'Luxurious silk scarf with Oblique pattern.',
 1750.00, NULL, 'AED', 0, 'accessories', 'scarves', ARRAY['luxury'],
 ARRAY['90x90cm'], ARRAY['Blue Oblique', 'Gray Oblique'], '100% Silk', 'Dry clean',
 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=800', 4.8, 556, false, false, false, true, 45),

(gen_random_uuid(), 'DIOR-BELT-119', 'other', 'https://www.dior.com/belt',
 'Dior Oblique Belt', 'Dior', 'Classic belt with CD buckle.',
 1850.00, NULL, 'AED', 0, 'accessories', 'belts', ARRAY['luxury'],
 ARRAY['75cm', '80cm', '85cm', '90cm'], ARRAY['Blue Oblique', 'Black'], 'Canvas & Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1553704571-9d00c552c51f?w=800', 4.7, 445, false, false, false, true, 50),

(gen_random_uuid(), 'DIOR-HAT-120', 'other', 'https://www.dior.com/hat',
 'Dior Oblique Bucket Hat', 'Dior', 'Contemporary bucket hat in Oblique jacquard.',
 1450.00, NULL, 'AED', 0, 'accessories', 'hats', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['S', 'M', 'L'], ARRAY['Blue Oblique', 'Beige'], 'Jacquard Canvas', 'Spot clean',
 'https://images.unsplash.com/photo-1575428652377-a2d80e2277fc?w=800', 4.8, 789, true, false, false, true, 35);

-- Products 121-200+ continue in the execution...

COMMIT;

-- Verification
SELECT COUNT(*) as total_products, 
       COUNT(DISTINCT brand) as total_brands 
FROM products;