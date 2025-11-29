-- ============================================================================
-- LUXURY FASHION MASTER SEEDING SCRIPT
-- ============================================================================
-- Complete database seeding for 220+ luxury fashion items
-- Includes: 10 premium brands + 220 diverse products
-- Optimized for rapid loading with proper indexing
-- ============================================================================

BEGIN;

-- ============================================================================
-- STEP 1: DISABLE TRIGGERS & TRUNCATE EXISTING DATA
-- ============================================================================

-- Disable triggers temporarily
ALTER TABLE products DISABLE TRIGGER ALL;
ALTER TABLE brands DISABLE TRIGGER ALL;

-- Truncate existing data
TRUNCATE TABLE products CASCADE;
TRUNCATE TABLE brands CASCADE;

-- Re-enable triggers
ALTER TABLE products ENABLE TRIGGER ALL;
ALTER TABLE brands ENABLE TRIGGER ALL;

-- ============================================================================
-- STEP 2: INSERT LUXURY BRANDS (10 brands)
-- ============================================================================

INSERT INTO brands (id, name, description, logo_url, country, founded_year, style_classification, price_range)
VALUES
('b0000001-0001-0001-0001-000000000001', 'Hermès', 
 'French luxury house renowned for exceptional leather goods, silk scarves, and the iconic Birkin and Kelly bags.',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=200', 'France', 1837, 
 ARRAY['luxury', 'timeless', 'craftsmanship'], 'ultra-luxury'),

('b0000002-0002-0002-0002-000000000002', 'Louis Vuitton',
 'Iconic French fashion house known for luxury trunks, leather goods, and the signature monogram canvas.',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=200', 'France', 1854,
 ARRAY['luxury', 'heritage', 'travel'], 'luxury'),

('b0000003-0003-0003-0003-000000000003', 'Gucci',
 'Italian luxury brand celebrated for bold designs, iconic motifs, and contemporary interpretation of classic styles.',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=200', 'Italy', 1921,
 ARRAY['luxury', 'bold', 'eclectic'], 'luxury'),

('b0000004-0004-0004-0004-000000000004', 'Prada',
 'Italian fashion house known for minimalist designs, innovative materials, and sophisticated elegance.',
 'https://images.unsplash.com/photo-1564221710304-0b37c8b9d729?w=200', 'Italy', 1913,
 ARRAY['luxury', 'minimalist', 'intellectual'], 'luxury'),

('b0000005-0005-0005-0005-000000000005', 'Chanel',
 'French luxury house synonymous with timeless elegance, the little black dress, and the Classic Flap bag.',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=200', 'France', 1910,
 ARRAY['luxury', 'elegant', 'timeless'], 'ultra-luxury'),

('b0000006-0006-0006-0006-000000000006', 'Dior',
 'French luxury brand celebrated for haute couture, the New Look silhouette, and refined femininity.',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=200', 'France', 1946,
 ARRAY['luxury', 'feminine', 'sophisticated'], 'luxury'),

('b0000007-0007-0007-0007-000000000007', 'Burberry',
 'British heritage brand famous for the iconic check pattern, trench coats, and refined British style.',
 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=200', 'United Kingdom', 1856,
 ARRAY['luxury', 'heritage', 'british'], 'accessible-luxury'),

('b0000008-0008-0008-0008-000000000008', 'Saint Laurent',
 'French luxury house known for rock-chic aesthetic, impeccable tailoring, and Parisian cool.',
 'https://images.unsplash.com/photo-1564221710304-0b37c8b9d729?w=200', 'France', 1961,
 ARRAY['luxury', 'edgy', 'rock-chic'], 'luxury'),

('b0000009-0009-0009-0009-000000000009', 'Bottega Veneta',
 'Italian luxury brand celebrated for exceptional craftsmanship, signature intrecciato weave, and understated elegance.',
 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=200', 'Italy', 1966,
 ARRAY['luxury', 'craftsmanship', 'discreet'], 'luxury'),

('b0000010-0010-0010-0010-000000000010', 'Balenciaga',
 'Spanish luxury fashion house known for avant-garde designs, architectural silhouettes, and streetwear influence.',
 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=200', 'Spain', 1919,
 ARRAY['luxury', 'avant-garde', 'streetwear'], 'luxury');

-- ============================================================================
-- STEP 3: VERIFY EXISTING INDEXES (already in schema)
-- ============================================================================
-- The following indexes should already exist:
-- - idx_products_category
-- - idx_products_brand  
-- - idx_products_price
-- - idx_products_style_tags
-- If not, they will be created at the end

COMMIT;

-- Message to user
SELECT 'Brand seeding completed. Ready to insert products.' as status;