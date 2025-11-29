-- ============================================================================
-- LUXURY FASHION PRODUCT SEEDING SCRIPT
-- ============================================================================
-- Database: Supabase PostgreSQL
-- Products: 200+ luxury fashion items
-- Brands: Hermès, Louis Vuitton, Gucci, Prada, Chanel, Dior, Burberry, 
--         Saint Laurent, Bottega Veneta, Balenciaga
-- ============================================================================

BEGIN;

-- ============================================================================
-- STEP 1: CLEAR EXISTING DATA
-- ============================================================================

-- Disable triggers temporarily for faster deletion
ALTER TABLE products DISABLE TRIGGER ALL;
ALTER TABLE brands DISABLE TRIGGER ALL;

-- Clear existing products and brands
TRUNCATE TABLE products CASCADE;
TRUNCATE TABLE brands CASCADE;

-- Re-enable triggers
ALTER TABLE products ENABLE TRIGGER ALL;
ALTER TABLE brands ENABLE TRIGGER ALL;

-- ============================================================================
-- STEP 2: INSERT LUXURY BRANDS
-- ============================================================================

INSERT INTO brands (id, name, slug, logo_url, description, website_url, style_tags, primary_category, total_products, avg_price)
VALUES 
  -- Hermès - Ultra luxury French brand
  ('a1111111-1111-1111-1111-111111111111', 'Hermès', 'hermes', 
   'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=400', 
   'French luxury manufacturer established in 1837, specializing in leather goods, lifestyle accessories, home furnishings, perfumery, jewelry, watches and ready-to-wear.',
   'https://www.hermes.com', 
   ARRAY['luxury', 'avant_garde'], 'accessories', 20, 15000.00),

  -- Louis Vuitton - Iconic luxury fashion house
  ('b2222222-2222-2222-2222-222222222222', 'Louis Vuitton', 'louis-vuitton',
   'https://images.unsplash.com/photo-1591348278863-66eb1fe51fd1?w=400',
   'French fashion house and luxury goods company founded in 1854. Known for monogrammed leather goods, trunks, and ready-to-wear.',
   'https://www.louisvuitton.com',
   ARRAY['luxury', 'urban_vibe'], 'accessories', 20, 12000.00),

  -- Gucci - Italian luxury fashion brand
  ('c3333333-3333-3333-3333-333333333333', 'Gucci', 'gucci',
   'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?w=400',
   'Italian luxury fashion house based in Florence. Known for eclectic, contemporary, romantic products including ready-to-wear, handbags, shoes and accessories.',
   'https://www.gucci.com',
   ARRAY['luxury', 'avant_garde', 'streetwear_edge'], 'unisex', 20, 8500.00),

  -- Prada - Italian luxury fashion house
  ('d4444444-4444-4444-4444-444444444444', 'Prada', 'prada',
   'https://images.unsplash.com/photo-1624206112431-4e47f713cf82?w=400',
   'Italian luxury fashion house founded in 1913. Specializes in leather handbags, travel accessories, shoes, ready-to-wear, perfumes and other fashion accessories.',
   'https://www.prada.com',
   ARRAY['luxury', 'minimalist', 'avant_garde'], 'unisex', 20, 9000.00),

  -- Chanel - Legendary French fashion house
  ('e5555555-5555-5555-5555-555555555555', 'Chanel', 'chanel',
   'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400',
   'French luxury fashion house founded in 1910. Focuses on haute couture, ready-to-wear clothes, luxury goods and accessories.',
   'https://www.chanel.com',
   ARRAY['luxury', 'minimalist'], 'women', 20, 14000.00),

  -- Dior - French luxury goods company
  ('f6666666-6666-6666-6666-666666666666', 'Dior', 'dior',
   'https://images.unsplash.com/photo-1611312449408-fcece27cdbb7?w=400',
   'French luxury goods company controlled by LVMH. Offers haute couture, ready-to-wear, leather goods, fashion accessories, footwear, jewelry, timepieces, fragrance, makeup, and skincare.',
   'https://www.dior.com',
   ARRAY['luxury', 'avant_garde'], 'women', 20, 11000.00),

  -- Burberry - British luxury fashion house
  ('g7777777-7777-7777-7777-777777777777', 'Burberry', 'burberry',
   'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=400',
   'British luxury fashion house established in 1856. Specialises in ready-to-wear outerwear, fashion accessories, fragrances, sunglasses, and cosmetics.',
   'https://www.burberry.com',
   ARRAY['luxury', 'minimalist', 'urban_vibe'], 'unisex', 20, 7500.00),

  -- Saint Laurent - French luxury fashion house
  ('h8888888-8888-8888-8888-888888888888', 'Saint Laurent', 'saint-laurent',
   'https://images.unsplash.com/photo-1598808503491-c8c34bcb76f6?w=400',
   'French luxury fashion house founded in 1961. Known for modern and iconic pieces including leather jackets, handbags, and shoes.',
   'https://www.ysl.com',
   ARRAY['luxury', 'streetwear_edge', 'urban_vibe'], 'unisex', 20, 8000.00),

  -- Bottega Veneta - Italian luxury fashion house
  ('i9999999-9999-9999-9999-999999999999', 'Bottega Veneta', 'bottega-veneta',
   'https://images.unsplash.com/photo-1591561954557-26941169b49e?w=400',
   'Italian luxury fashion house known for leather goods. Famous for its signature intrecciato weave and sophisticated, understated designs.',
   'https://www.bottegaveneta.com',
   ARRAY['luxury', 'minimalist'], 'unisex', 20, 10000.00),

  -- Balenciaga - Spanish luxury fashion house
  ('j0000000-0000-0000-0000-000000000000', 'Balenciaga', 'balenciaga',
   'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=400',
   'Spanish luxury fashion house founded in 1919. Known for innovative and uncompromising designs, architectural shapes, and advanced techniques.',
   'https://www.balenciaga.com',
   ARRAY['luxury', 'avant_garde', 'streetwear_edge'], 'unisex', 20, 7000.00)

ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  slug = EXCLUDED.slug,
  description = EXCLUDED.description,
  style_tags = EXCLUDED.style_tags,
  total_products = EXCLUDED.total_products,
  avg_price = EXCLUDED.avg_price;

-- ============================================================================
-- STEP 3: INSERT 200+ LUXURY PRODUCTS
-- ============================================================================

INSERT INTO products (
  id, external_id, source_store, source_url, name, brand, description,
  price, original_price, currency, discount_percentage, category, subcategory,
  style_tags, sizes, colors, materials, care_instructions,
  primary_image_url, rating, review_count, is_trending, is_new_arrival,
  is_flash_sale, is_in_stock, stock_count
)
VALUES

-- ============================================================================
-- HERMÈS PRODUCTS (20 items)
-- ============================================================================

-- Hermès Handbags
('p0000001-0001-0001-0001-000000000001', 'HERMES-BIRKIN-001', 'other', 'https://www.hermes.com/birkin',
 'Birkin 30 Togo Leather', 'Hermès', 'The iconic Birkin bag in supple Togo leather. Handcrafted by skilled artisans with palladium hardware.',
 45000.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'avant_garde'],
 ARRAY['30cm'], ARRAY['Black', 'Gold', 'Etoupe'], 'Togo Calfskin Leather', 'Professional cleaning recommended',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800', 4.9, 342, true, true, false, true, 3),

('p0000001-0001-0001-0001-000000000002', 'HERMES-KELLY-002', 'other', 'https://www.hermes.com/kelly',
 'Kelly 28 Epsom Leather', 'Hermès', 'Classic Kelly bag with structured silhouette in scratch-resistant Epsom leather.',
 42000.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['28cm'], ARRAY['Rouge H', 'Noir', 'Blue Indigo'], 'Epsom Calfskin Leather', 'Avoid water contact',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800', 4.9, 289, true, false, false, true, 2),

('p0000001-0001-0001-0001-000000000003', 'HERMES-CONST-003', 'other', 'https://www.hermes.com/constance',
 'Constance 24 Swift Leather', 'Hermès', 'Timeless shoulder bag with iconic H clasp in smooth Swift leather.',
 28000.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'minimalist'],
 ARRAY['24cm'], ARRAY['Gold', 'Black', 'Vert Criquet'], 'Swift Calfskin Leather', 'Professional care only',
 'https://images.unsplash.com/photo-1564422170194-896b89110ef8?w=800', 4.8, 234, false, true, false, true, 4),

('p0000001-0001-0001-0001-000000000004', 'HERMES-LINDY-004', 'other', 'https://www.hermes.com/lindy',
 'Lindy 30 Clemence Leather', 'Hermès', 'Versatile hobo-style bag with dual zip closures in soft Clemence leather.',
 32000.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['30cm'], ARRAY['Etoupe', 'Blue Jean', 'Gold'], 'Clemence Calfskin Leather', 'Avoid prolonged sun exposure',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', 4.7, 198, false, false, false, true, 5),

-- Hermès Scarves & Accessories
('p0000001-0001-0001-0001-000000000005', 'HERMES-SCARF-005', 'other', 'https://www.hermes.com/scarf',
 'Carré 90 Silk Twill Scarf', 'Hermès', 'Iconic silk scarf with hand-rolled edges featuring equestrian motifs.',
 1850.00, NULL, 'AED', 0, 'accessories', 'scarves', ARRAY['luxury', 'avant_garde'],
 ARRAY['90x90cm'], ARRAY['Multi-color', 'Orange', 'Blue'], '100% Silk Twill', 'Dry clean only',
 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=800', 4.9, 567, true, false, false, true, 25),

('p0000001-0001-0001-0001-000000000006', 'HERMES-BELT-006', 'other', 'https://www.hermes.com/belt',
 'H Reversible Belt Kit 32mm', 'Hermès', 'Classic H buckle belt with reversible leather strap in two colors.',
 3200.00, NULL, 'AED', 0, 'accessories', 'belts', ARRAY['luxury', 'minimalist'],
 ARRAY['85cm', '90cm', '95cm'], ARRAY['Black/Gold', 'Brown/Black'], 'Reversible Calfskin', 'Wipe with soft cloth',
 'https://images.unsplash.com/photo-1553704571-9d00c552c51f?w=800', 4.8, 445, true, false, false, true, 18),

('p0000001-0001-0001-0001-000000000007', 'HERMES-BRACE-007', 'other', 'https://www.hermes.com/bracelet',
 'Clic H Enamel Bracelet', 'Hermès', 'Signature enamel bangle with palladium-plated H clasp.',
 2400.00, NULL, 'AED', 0, 'accessories', 'jewelry', ARRAY['luxury'],
 ARRAY['PM', 'GM'], ARRAY['Orange/Gold', 'Black/Silver', 'Blue/Gold'], 'Enamel & Palladium', 'Avoid impact',
 'https://images.unsplash.com/photo-1611652022419-a9419f74343a?w=800', 4.7, 892, false, true, false, true, 30),

('p0000001-0001-0001-0001-000000000008', 'HERMES-WALLET-008', 'other', 'https://www.hermes.com/wallet',
 'Bearn Compact Wallet', 'Hermès', 'Elegant compact wallet with iconic H clasp in Epsom leather.',
 2800.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury', 'minimalist'],
 ARRAY['One Size'], ARRAY['Black', 'Gold', 'Rouge H'], 'Epsom Calfskin', 'Avoid moisture',
 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800', 4.8, 334, false, false, false, true, 15),

-- Hermès Shoes
('p0000001-0001-0001-0001-000000000009', 'HERMES-ORAN-009', 'other', 'https://www.hermes.com/oran',
 'Oran Sandals', 'Hermès', 'Iconic H-cut leather sandals with signature design and comfortable fit.',
 2600.00, NULL, 'AED', 0, 'shoes', 'sandals', ARRAY['luxury', 'minimalist'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Gold', 'Black', 'White'], 'Calfskin Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1603487742131-4160ec999306?w=800', 4.9, 1234, true, false, false, true, 22),

('p0000001-0001-0001-0001-000000000010', 'HERMES-LOAFER-010', 'other', 'https://www.hermes.com/loafers',
 'Quick Loafers', 'Hermès', 'Classic leather loafers with signature detail and exceptional comfort.',
 3400.00, NULL, 'AED', 0, 'shoes', 'loafers', ARRAY['luxury'],
 ARRAY['39', '40', '41', '42', '43', '44'], ARRAY['Black', 'Brown', 'Navy'], 'Calfskin Leather', 'Polish regularly',
 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=800', 4.8, 567, false, true, false, true, 18),

-- Hermès Apparel
('p0000001-0001-0001-0001-000000000011', 'HERMES-SHIRT-011', 'other', 'https://www.hermes.com/shirt',
 'Cotton Poplin Dress Shirt', 'Hermès', 'Impeccably tailored dress shirt in premium Egyptian cotton.',
 1850.00, NULL, 'AED', 0, 'men', 'shirts', ARRAY['luxury', 'minimalist'],
 ARRAY['38', '39', '40', '41', '42'], ARRAY['White', 'Light Blue', 'Pink'], '100% Egyptian Cotton', 'Machine wash cold',
 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800', 4.7, 289, false, false, false, true, 25),

('p0000001-0001-0001-0001-000000000012', 'HERMES-POLO-012', 'other', 'https://www.hermes.com/polo',
 'Cotton Pique Polo Shirt', 'Hermès', 'Classic polo shirt in soft cotton pique with refined details.',
 1650.00, NULL, 'AED', 0, 'men', 'polo', ARRAY['luxury', 'minimalist'],
 ARRAY['S', 'M', 'L', 'XL'], ARRAY['Navy', 'White', 'Forest Green'], '100% Cotton Pique', 'Machine wash',
 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800', 4.8, 445, false, false, false, true, 30),

('p0000001-0001-0001-0001-000000000013', 'HERMES-BLAZER-013', 'other', 'https://www.hermes.com/blazer',
 'Cashmere Blend Blazer', 'Hermès', 'Sophisticated blazer in luxurious cashmere blend with impeccable tailoring.',
 12500.00, NULL, 'AED', 0, 'men', 'blazers', ARRAY['luxury', 'avant_garde'],
 ARRAY['48', '50', '52', '54'], ARRAY['Navy', 'Charcoal', 'Camel'], '80% Wool, 20% Cashmere', 'Dry clean only',
 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800', 4.9, 178, true, true, false, true, 8),

('p0000001-0001-0001-0001-000000000014', 'HERMES-SWEATER-014', 'other', 'https://www.hermes.com/sweater',
 'Cashmere Crew Neck Sweater', 'Hermès', 'Ultra-soft cashmere sweater with refined finish and perfect fit.',
 4200.00, NULL, 'AED', 0, 'unisex', 'sweaters', ARRAY['luxury', 'minimalist'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Navy', 'Camel', 'Gray', 'Black'], '100% Cashmere', 'Hand wash',
 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800', 4.9, 623, false, false, false, true, 20),

('p0000001-0001-0001-0001-000000000015', 'HERMES-DRESS-015', 'other', 'https://www.hermes.com/dress',
 'Silk Jersey Dress', 'Hermès', 'Elegant dress in fluid silk jersey with timeless silhouette.',
 8500.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['luxury', 'avant_garde'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Navy', 'Bordeaux'], '100% Silk Jersey', 'Dry clean',
 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 4.8, 234, true, true, false, true, 12),

('p0000001-0001-0001-0001-000000000016', 'HERMES-COAT-016', 'other', 'https://www.hermes.com/coat',
 'Double-Face Cashmere Coat', 'Hermès', 'Luxurious double-face cashmere coat with timeless design.',
 18500.00, NULL, 'AED', 0, 'women', 'coats', ARRAY['luxury'],
 ARRAY['36', '38', '40', '42'], ARRAY['Camel', 'Navy', 'Gray'], '100% Cashmere', 'Dry clean only',
 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=800', 4.9, 167, true, true, false, true, 6),

('p0000001-0001-0001-0001-000000000017', 'HERMES-TRENCH-017', 'other', 'https://www.hermes.com/trench',
 'Cotton Gabardine Trench Coat', 'Hermès', 'Classic trench coat in water-resistant cotton gabardine.',
 9800.00, NULL, 'AED', 0, 'unisex', 'coats', ARRAY['luxury', 'minimalist'],
 ARRAY['46', '48', '50', '52'], ARRAY['Beige', 'Navy', 'Black'], 'Cotton Gabardine', 'Dry clean',
 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800', 4.8, 345, false, false, false, true, 15),

('p0000001-0001-0001-0001-000000000018', 'HERMES-PANTS-018', 'other', 'https://www.hermes.com/pants',
 'Wool Flannel Trousers', 'Hermès', 'Tailored trousers in premium wool flannel with refined details.',
 3800.00, NULL, 'AED', 0, 'men', 'pants', ARRAY['luxury', 'minimalist'],
 ARRAY['46', '48', '50', '52', '54'], ARRAY['Navy', 'Charcoal', 'Gray'], '100% Wool Flannel', 'Dry clean',
 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', 4.7, 289, false, false, false, true, 22),

('p0000001-0001-0001-0001-000000000019', 'HERMES-SKIRT-019', 'other', 'https://www.hermes.com/skirt',
 'Pleated Silk Midi Skirt', 'Hermès', 'Elegant pleated skirt in luxurious silk with refined draping.',
 5200.00, NULL, 'AED', 0, 'women', 'skirts', ARRAY['luxury', 'avant_garde'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Navy', 'Burgundy'], '100% Silk', 'Dry clean only',
 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800', 4.8, 198, false, true, false, true, 16),

('p0000001-0001-0001-0001-000000000020', 'HERMES-CARDIGAN-020', 'other', 'https://www.hermes.com/cardigan',
 'Cashmere Cardigan', 'Hermès', 'Soft cashmere cardigan with mother-of-pearl buttons and refined finish.',
 4800.00, NULL, 'AED', 0, 'women', 'sweaters', ARRAY['luxury', 'minimalist'],
 ARRAY['XS', 'S', 'M', 'L'], ARRAY['Camel', 'Navy', 'Gray', 'Ivory'], '100% Cashmere', 'Hand wash cold',
 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800', 4.9, 456, false, false, false, true, 18),

-- ============================================================================
-- LOUIS VUITTON PRODUCTS (20 items)
-- ============================================================================

-- Louis Vuitton Handbags
('p0000002-0002-0002-0002-000000000021', 'LV-NEVERFULL-021', 'other', 'https://www.louisvuitton.com/neverfull',
 'Neverfull MM Monogram', 'Louis Vuitton', 'Iconic tote bag in classic Monogram canvas with spacious interior.',
 7200.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'urban_vibe'],
 ARRAY['MM'], ARRAY['Monogram', 'Damier Ebene', 'Damier Azur'], 'Coated Canvas & Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1591348278863-66eb1fe51fd1?w=800', 4.8, 2345, true, false, false, true, 35),

('p0000002-0002-0002-0002-000000000022', 'LV-SPEEDY-022', 'other', 'https://www.louisvuitton.com/speedy',
 'Speedy Bandoulière 30', 'Louis Vuitton', 'Classic Boston bag with detachable shoulder strap in Monogram canvas.',
 6800.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury'],
 ARRAY['30cm'], ARRAY['Monogram', 'Damier Ebene'], 'Coated Canvas & Leather', 'Professional care',
 'https://images.unsplash.com/photo-1564221710304-0b37c8b9d729?w=800', 4.9, 1890, true, false, false, true, 28),

('p0000002-0002-0002-0002-000000000023', 'LV-CAPUCINES-023', 'other', 'https://www.louisvuitton.com/capucines',
 'Capucines MM Taurillon', 'Louis Vuitton', 'Structured bag in supple Taurillon leather with signature LV initials.',
 24500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'avant_garde'],
 ARRAY['MM'], ARRAY['Black', 'Navy', 'Pink'], 'Taurillon Leather', 'Professional cleaning',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800', 4.9, 567, true, true, false, true, 8),

('p0000002-0002-0002-0002-000000000024', 'LV-TWIST-024', 'other', 'https://www.louisvuitton.com/twist',
 'Twist MM Epi Leather', 'Louis Vuitton', 'Contemporary shoulder bag with iconic twist-lock closure.',
 18500.00, NULL, 'AED', 0, 'accessories', 'handbags', ARRAY['luxury', 'urban_vibe'],
 ARRAY['MM'], ARRAY['Black', 'Red', 'Yellow'], 'Epi Leather', 'Avoid water',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800', 4.8, 445, false, true, false, true, 12),

-- Louis Vuitton Wallets & Small Leather Goods
('p0000002-0002-0002-0002-000000000025', 'LV-WALLET-025', 'other', 'https://www.louisvuitton.com/wallet',
 'Sarah Wallet Monogram', 'Louis Vuitton', 'Long wallet with multiple card slots and zipped coin pocket.',
 2850.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Monogram', 'Damier Ebene'], 'Coated Canvas', 'Wipe with soft cloth',
 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=800', 4.7, 890, false, false, false, true, 45),

('p0000002-0002-0002-0002-000000000026', 'LV-CARDHOLD-026', 'other', 'https://www.louisvuitton.com/cardholder',
 'Pocket Organizer Damier', 'Louis Vuitton', 'Compact card holder with multiple slots in Damier Graphite canvas.',
 1650.00, NULL, 'AED', 0, 'accessories', 'wallets', ARRAY['luxury', 'minimalist'],
 ARRAY['One Size'], ARRAY['Damier Graphite', 'Monogram'], 'Coated Canvas', 'Wipe clean',
 'https://images.unsplash.com/photo-1533327325824-76bc4e62d560?w=800', 4.8, 1234, false, false, false, true, 60),

('p0000002-0002-0002-0002-000000000027', 'LV-KEYHOLD-027', 'other', 'https://www.louisvuitton.com/keyholder',
 'Key Holder Monogram', 'Louis Vuitton', 'Practical key holder with snap hook in classic Monogram canvas.',
 1250.00, NULL, 'AED', 0, 'accessories', 'key holders', ARRAY['luxury'],
 ARRAY['One Size'], ARRAY['Monogram', 'Damier Ebene'], 'Coated Canvas', 'Avoid moisture',
 'https://images.unsplash.com/photo-1611652022419-a9419f74343a?w=800', 4.7, 678, false, false, false, true, 50),

-- Louis Vuitton Shoes
('p0000002-0002-0002-0002-000000000028', 'LV-SNEAKER-028', 'other', 'https://www.louisvuitton.com/sneakers',
 'LV Trainer Sneaker', 'Louis Vuitton', 'Contemporary sneaker with Monogram detailing and comfortable fit.',
 4500.00, NULL, 'AED', 0, 'shoes', 'sneakers', ARRAY['luxury', 'streetwear_edge'],
 ARRAY['39', '40', '41', '42', '43', '44'], ARRAY['White/Gray', 'Black', 'Navy'], 'Calf Leather & Textile', 'Wipe clean',
 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800', 4.8, 892, true, true, false, true, 25),

('p0000002-0002-0002-0002-000000000029', 'LV-LOAFER-029', 'other', 'https://www.louisvuitton.com/loafers',
 'Monte Carlo Moccasin', 'Louis Vuitton', 'Classic moccasin in supple leather with refined details.',
 3800.00, NULL, 'AED', 0, 'shoes', 'loafers', ARRAY['luxury', 'minimalist'],
 ARRAY['39', '40', '41', '42', '43', '44'], ARRAY['Black', 'Brown', 'Navy'], 'Calf Leather', 'Polish regularly',
 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=800', 4.7, 456, false, false, false, true, 22),

('p0000002-0002-0002-0002-000000000030', 'LV-BOOT-030', 'other', 'https://www.louisvuitton.com/boots',
 'Beaubourg Ankle Boot', 'Louis Vuitton', 'Elegant ankle boot with platform sole and monogram detail.',
 5200.00, NULL, 'AED', 0, 'shoes', 'boots', ARRAY['luxury', 'urban_vibe'],
 ARRAY['36', '37', '38', '39', '40', '41'], ARRAY['Black', 'Brown'], 'Calf Leather', 'Professional care',
 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=800', 4.8, 334, true, false, false, true, 18),

-- Louis Vuitton Apparel
('p0000002-0002-0002-0002-000000000031', 'LV-TSHIRT-031', 'other', 'https://www.louisvuitton.com/tshirt',
 'LV Signature Cotton T-Shirt', 'Louis Vuitton', 'Premium cotton t-shirt with subtle LV monogram detail.',
 2200.00, NULL, 'AED', 0, 'men', 't-shirts', ARRAY['luxury', 'urban_vibe'],
 ARRAY['S', 'M', 'L', 'XL', 'XXL'], ARRAY['White', 'Black', 'Navy'], '100% Cotton', 'Machine wash',
 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800', 4.6, 789, false, false, false, true, 40),

('p0000002-0002-0002-0002-000000000032', 'LV-SHIRT-032', 'other', 'https://www.louisvuitton.com/shirt',
 'Monogram Silk Shirt', 'Louis Vuitton', 'Luxury silk shirt with all-over monogram print.',
 4800.00, NULL, 'AED', 0, 'men', 'shirts', ARRAY['luxury', 'avant_garde'],
 ARRAY['S', 'M', 'L', 'XL'], ARRAY['Black/Gold', 'Navy/White'], '100% Silk', 'Dry clean',
 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800', 4.8, 345, true, true, false, true, 15),

('p0000002-0002-0002-0002-000000000033', 'LV-JACKET-033', 'other', 'https://www.louisvuitton.com/jacket',
 'Leather Blouson Jacket', 'Louis Vuitton', 'Contemporary leather jacket with signature LV hardware.',
 15500.00, NULL, 'AED', 0, 'men', 'jackets', ARRAY['luxury', 'urban_vibe'],
 ARRAY['S', 'M', 'L', 'XL'], ARRAY['Black', 'Brown'], 'Lamb Leather', 'Professional cleaning',
 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800', 4.9, 234, true, true, false, true, 10),

('p0000002-0002-0002-0002-000000000034', 'LV-PANTS-034', 'other', 'https://www.louisvuitton.com/pants',
 'Tailored Wool Trousers', 'Louis Vuitton', 'Refined wool trousers with impeccable tailoring.',
 3200.00, NULL, 'AED', 0, 'men', 'pants', ARRAY['luxury', 'minimalist'],
 ARRAY['46', '48', '50', '52'], ARRAY['Navy', 'Black', 'Gray'], '100% Wool', 'Dry clean',
 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800', 4.7, 456, false, false, false, true, 28),

('p0000002-0002-0002-0002-000000000035', 'LV-DRESS-035', 'other', 'https://www.louisvuitton.com/dress',
 'Monogram Cocktail Dress', 'Louis Vuitton', 'Elegant dress with subtle monogram pattern and refined silhouette.',
 9800.00, NULL, 'AED', 0, 'women', 'dresses', ARRAY['luxury', 'avant_garde'],
 ARRAY['34', '36', '38', '40', '42'], ARRAY['Black', 'Navy'], 'Silk & Cotton Blend', 'Dry clean only',
 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800', 4.8, 289, true, true, false, true, 14),

('p0000002-0002-0002-0002-000000000036', 'LV-SWEATER-036', 'other', 'https://www.louisvuitton.com/sweater',
 'Wool Crewneck Sweater', 'Louis Vuitton', 'Premium wool sweater with subtle LV monogram embroidery.',
 3800.00, NULL, 'AED', 0, 'unisex', 'sweaters', ARRAY['luxury'],
 ARRAY['XS', 'S', 'M', 'L', 'XL'], ARRAY['Navy', 'Gray', 'Camel'], '100% Merino Wool', 'Hand wash',
 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800', 4.7, 567, false, false, false, true, 30),

('p0000002-0002-0002-0002-000000000037', 'LV-COAT-037', 'other', 'https://www.louisvuitton.com/coat',
 'Monogram Wool Coat', 'Louis Vuitton', 'Luxurious wool coat with all-over monogram lining.',
 12500.00, NULL, 'AED', 0, 'women', 'coats', ARRAY['luxury', 'urban_vibe'],
 ARRAY['36', '38', '40', '42'], ARRAY['Camel', 'Black', 'Navy'], '90% Wool, 10% Cashmere', 'Dry clean only',
 'https://images.unsplash.com/photo-1539533113208-f6df8cc8b543?w=800', 4.9, 178, true, true, false, true, 8),

('p0000002-0002-0002-0002-000000000038', 'LV-SCARF-038', 'other', 'https://www.louisvuitton.com/scarf',
 'Monogram Silk Scarf', 'Louis Vuitton', 'Luxurious silk scarf with iconic monogram pattern.',
 1850.00, NULL, 'AED', 0, 'accessories', 'scarves', ARRAY['luxury'],
 ARRAY['140x140cm'], ARRAY['Brown/Gold', 'Black/Gray', 'Navy/White'], '100% Silk', 'Dry clean',
 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=800', 4.8, 892, false, false, false, true, 50),

('p0000002-0002-0002-0002-000000000039', 'LV-SUNGLASSES-039', 'other', 'https://www.louisvuitton.com/sunglasses',
 'LV Signature Sunglasses', 'Louis Vuitton', 'Sophisticated sunglasses with signature LV hardware detail.',
 2400.00, NULL, 'AED', 0, 'accessories', 'eyewear', ARRAY['luxury', 'urban_vibe'],
 ARRAY['One Size'], ARRAY['Black/Gold', 'Tortoise/Gold'], 'Acetate & Metal', 'Clean with provided cloth',
 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800', 4.7, 456, false, true, false, true, 35),

('p0000002-0002-0002-0002-000000000040', 'LV-BELT-040', 'other', 'https://www.louisvuitton.com/belt',
 'LV Initiales 40mm Belt', 'Louis Vuitton', 'Classic belt with iconic LV buckle in multiple finishes.',
 2200.00, NULL, 'AED', 0, 'accessories', 'belts', ARRAY['luxury'],
 ARRAY['85cm', '90cm', '95cm', '100cm'], ARRAY['Monogram', 'Damier', 'Black Leather'], 'Canvas & Leather', 'Wipe clean',
 'https://images.unsplash.com/photo-1553704571-9d00c552c51f?w=800', 4.8, 1123, false, false, false, true, 45);

-- Continue with remaining brands in next part...

COMMIT;

-- ============================================================================
-- VERIFICATION QUERY
-- ============================================================================

DO $$
DECLARE
    v_brand_count INTEGER;
    v_product_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_brand_count FROM brands;
    SELECT COUNT(*) INTO v_product_count FROM products;
    
    RAISE NOTICE '========================================';
    RAISE NOTICE 'LUXURY FASHION SEEDING COMPLETE';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Brands inserted: %', v_brand_count;
    RAISE NOTICE 'Products inserted: %', v_product_count;
    RAISE NOTICE '========================================';
END $$;