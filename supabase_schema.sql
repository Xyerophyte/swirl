-- SWIRL Database Schema
-- Version: 1.0 (Aligned with PRD v1.0)
-- Platform: Supabase (PostgreSQL)
-- Created: 2025-11-12

-- ============================================================================
-- ENABLE EXTENSIONS
-- ============================================================================

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable vector similarity search (for ML embeddings)
-- Note: pgvector extension must be enabled in Supabase dashboard first
-- CREATE EXTENSION IF NOT EXISTS vector;

-- ============================================================================
-- DROP EXISTING TABLES (for clean migration)
-- ============================================================================

DROP TABLE IF EXISTS analytics_events CASCADE;
DROP TABLE IF EXISTS weekly_outfits CASCADE;
DROP TABLE IF EXISTS collection_items CASCADE;
DROP TABLE IF EXISTS collections CASCADE;
DROP TABLE IF EXISTS wishlist CASCADE;
DROP TABLE IF EXISTS swirls CASCADE;
DROP TABLE IF EXISTS brand_follows CASCADE;
DROP TABLE IF EXISTS brands CASCADE;
DROP TABLE IF EXISTS swipes CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================================================
-- USERS TABLE
-- ============================================================================

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Anonymous tracking (default mode)
  anonymous_id UUID UNIQUE DEFAULT uuid_generate_v4(),
  is_anonymous BOOLEAN DEFAULT true,

  -- Authentication (populated when user signs up)
  email TEXT UNIQUE,
  phone TEXT UNIQUE,
  auth_provider TEXT CHECK (auth_provider IN ('email', 'google', 'apple', 'phone')),

  -- Profile
  display_name TEXT,
  avatar_url TEXT,

  -- Onboarding data (from quiz)
  gender_preference TEXT CHECK (gender_preference IN ('men', 'women', 'both')),
  style_preferences TEXT[] DEFAULT ARRAY[]::TEXT[],
  -- Valid style_preferences: 'minimalist', 'urban_vibe', 'streetwear_edge', 'avant_garde'
  price_tier TEXT CHECK (price_tier IN ('budget', 'mid_range', 'premium', 'luxury')),

  -- Computed preferences (ML-driven, updated periodically)
  preferred_categories TEXT[] DEFAULT ARRAY[]::TEXT[],
  preferred_brands TEXT[] DEFAULT ARRAY[]::TEXT[],
  preferred_colors TEXT[] DEFAULT ARRAY[]::TEXT[],
  avg_liked_price DECIMAL(10,2),

  -- Stats (denormalized for performance)
  total_swirls INTEGER DEFAULT 0,
  total_swipes INTEGER DEFAULT 0,
  days_active INTEGER DEFAULT 0,

  -- Metadata
  device_locale TEXT DEFAULT 'en-AE',
  timezone TEXT DEFAULT 'Asia/Dubai',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_seen_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for users
CREATE INDEX idx_users_anonymous ON users(anonymous_id);
CREATE INDEX idx_users_email ON users(email) WHERE email IS NOT NULL;
CREATE INDEX idx_users_phone ON users(phone) WHERE phone IS NOT NULL;
CREATE INDEX idx_users_last_seen ON users(last_seen_at);
CREATE INDEX idx_users_is_anonymous ON users(is_anonymous);

-- ============================================================================
-- BRANDS TABLE
-- ============================================================================

CREATE TABLE brands (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Brand info
  name TEXT UNIQUE NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  logo_url TEXT,
  description TEXT,
  website_url TEXT,

  -- Classification
  style_tags TEXT[] DEFAULT ARRAY[]::TEXT[],
  primary_category TEXT,

  -- Stats (denormalized, updated by triggers or jobs)
  total_products INTEGER DEFAULT 0,
  avg_price DECIMAL(10,2),
  follower_count INTEGER DEFAULT 0,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for brands
CREATE INDEX idx_brands_name ON brands(name);
CREATE INDEX idx_brands_slug ON brands(slug);
CREATE INDEX idx_brands_style_tags ON brands USING GIN(style_tags);

-- ============================================================================
-- PRODUCTS TABLE
-- ============================================================================

CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Source data (Amazon API or other stores)
  external_id TEXT UNIQUE NOT NULL, -- Amazon ASIN, Noon SKU, etc.
  source_store TEXT NOT NULL CHECK (source_store IN ('amazon', 'noon', 'namshi', 'other')),
  source_url TEXT NOT NULL,

  -- Basic info
  name TEXT NOT NULL,
  brand TEXT NOT NULL, -- FK to brands.name (soft reference)
  description TEXT,

  -- Pricing
  price DECIMAL(10,2) NOT NULL,
  original_price DECIMAL(10,2),
  currency TEXT DEFAULT 'AED',
  discount_percentage INTEGER DEFAULT 0 CHECK (discount_percentage >= 0 AND discount_percentage <= 100),

  -- Classification
  category TEXT NOT NULL CHECK (category IN ('men', 'women', 'unisex', 'accessories', 'shoes')),
  subcategory TEXT, -- 'shirts', 'pants', 'dresses', 'sneakers', etc.
  style_tags TEXT[] DEFAULT ARRAY[]::TEXT[], -- ML-generated or manual tags
  -- Valid style_tags: 'minimalist', 'urban_vibe', 'streetwear_edge', 'avant_garde'

  -- Product details
  sizes TEXT[] DEFAULT ARRAY[]::TEXT[],
  colors TEXT[] DEFAULT ARRAY[]::TEXT[],
  materials TEXT,
  care_instructions TEXT,

  -- Images
  primary_image_url TEXT NOT NULL,
  additional_images TEXT[] DEFAULT ARRAY[]::TEXT[],

  -- CDN mirrors (our cached versions)
  cdn_primary_image TEXT,
  cdn_thumbnail TEXT, -- 150x150
  cdn_medium TEXT, -- 400x400

  -- Quality metrics
  rating DECIMAL(2,1) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
  review_count INTEGER DEFAULT 0,

  -- Flags
  is_trending BOOLEAN DEFAULT false,
  is_new_arrival BOOLEAN DEFAULT false,
  is_flash_sale BOOLEAN DEFAULT false,
  is_in_stock BOOLEAN DEFAULT true,
  stock_count INTEGER DEFAULT 100,

  -- ML embeddings (for recommendations)
  -- Uncomment when pgvector is enabled
  -- embedding VECTOR(512),

  -- Metadata
  metadata JSONB, -- Flexible additional data
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_synced_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for products
CREATE INDEX idx_products_external_id ON products(external_id);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_brand ON products(brand);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_style_tags ON products USING GIN(style_tags);
CREATE INDEX idx_products_trending ON products(is_trending) WHERE is_trending = true;
CREATE INDEX idx_products_new ON products(is_new_arrival) WHERE is_new_arrival = true;
CREATE INDEX idx_products_flash_sale ON products(is_flash_sale) WHERE is_flash_sale = true;
CREATE INDEX idx_products_in_stock ON products(is_in_stock) WHERE is_in_stock = true;
CREATE INDEX idx_products_created ON products(created_at DESC);

-- Vector similarity index (when pgvector is enabled)
-- CREATE INDEX idx_products_embedding ON products USING ivfflat(embedding vector_cosine_ops) WITH (lists = 100);

-- ============================================================================
-- SWIPES TABLE (Comprehensive Tracking for ML)
-- ============================================================================

CREATE TABLE swipes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Identifiers
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  session_id UUID, -- Group swipes by session

  -- Swipe data
  direction TEXT NOT NULL CHECK (direction IN ('right', 'left', 'up', 'down')),
  swipe_action TEXT NOT NULL CHECK (swipe_action IN ('like', 'details_view', 'skip', 'wishlist')),

  -- Engagement metrics (ML features)
  dwell_ms INTEGER, -- Time spent viewing card before swipe (milliseconds)
  card_position INTEGER, -- Position in feed (0-indexed)
  is_repeat_view BOOLEAN DEFAULT false, -- User saw this item before?

  -- Product snapshot (denormalized for ML training)
  price DECIMAL(10,2),
  currency TEXT DEFAULT 'AED',
  brand TEXT,
  category TEXT,
  subcategory TEXT,
  style_tags TEXT[] DEFAULT ARRAY[]::TEXT[],

  -- Context at time of swipe
  device_locale TEXT,
  device_platform TEXT CHECK (device_platform IN ('ios', 'android', 'web')),
  active_style_filters TEXT[] DEFAULT ARRAY[]::TEXT[], -- Active filters when swiped
  time_of_day INTEGER CHECK (time_of_day >= 0 AND time_of_day <= 23), -- Hour (0-23)
  day_of_week INTEGER CHECK (day_of_week >= 0 AND day_of_week <= 6), -- 0=Sunday, 6=Saturday

  -- Timestamp
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for swipes
CREATE INDEX idx_swipes_user ON swipes(user_id);
CREATE INDEX idx_swipes_product ON swipes(product_id);
CREATE INDEX idx_swipes_direction ON swipes(direction);
CREATE INDEX idx_swipes_action ON swipes(swipe_action);
CREATE INDEX idx_swipes_session ON swipes(session_id);
CREATE INDEX idx_swipes_created ON swipes(created_at DESC);
CREATE INDEX idx_swipes_user_created ON swipes(user_id, created_at DESC);

-- ============================================================================
-- BRAND FOLLOWS TABLE
-- ============================================================================

CREATE TABLE brand_follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

  -- Follow metadata
  source TEXT CHECK (source IN ('manual', 'auto_5_likes', 'onboarding')),
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, brand_id)
);

-- Indexes for brand_follows
CREATE INDEX idx_brand_follows_user ON brand_follows(user_id);
CREATE INDEX idx_brand_follows_brand ON brand_follows(brand_id);
CREATE INDEX idx_brand_follows_created ON brand_follows(created_at DESC);

-- ============================================================================
-- SWIRLS TABLE (Liked Items)
-- ============================================================================

CREATE TABLE swirls (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

  -- Swirl metadata
  source TEXT CHECK (source IN ('swipe_right', 'swipe_down', 'double_tap', 'detail_view')),
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, product_id)
);

-- Indexes for swirls
CREATE INDEX idx_swirls_user ON swirls(user_id);
CREATE INDEX idx_swirls_product ON swirls(product_id);
CREATE INDEX idx_swirls_created ON swirls(created_at DESC);
CREATE INDEX idx_swirls_user_created ON swirls(user_id, created_at DESC);

-- ============================================================================
-- WISHLIST TABLE
-- ============================================================================

CREATE TABLE wishlist (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

  -- Wishlist metadata
  source TEXT CHECK (source IN ('swipe_down', 'detail_view_button', 'search_result')),
  notes TEXT, -- User can add personal notes
  price_alert_enabled BOOLEAN DEFAULT true, -- Notify on price drop
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, product_id)
);

-- Indexes for wishlist
CREATE INDEX idx_wishlist_user ON wishlist(user_id);
CREATE INDEX idx_wishlist_product ON wishlist(product_id);
CREATE INDEX idx_wishlist_price_alert ON wishlist(price_alert_enabled) WHERE price_alert_enabled = true;
CREATE INDEX idx_wishlist_created ON wishlist(created_at DESC);

-- ============================================================================
-- COLLECTIONS TABLE (Phase 2 - User-Created Outfit Collections)
-- ============================================================================

CREATE TABLE collections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  -- Collection info
  name TEXT NOT NULL,
  description TEXT,
  cover_image_url TEXT, -- First item image or user-selected

  -- Visibility
  is_public BOOLEAN DEFAULT false,

  -- Stats (denormalized)
  item_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for collections
CREATE INDEX idx_collections_user ON collections(user_id);
CREATE INDEX idx_collections_public ON collections(is_public) WHERE is_public = true;
CREATE INDEX idx_collections_created ON collections(created_at DESC);

-- Collection Items (many-to-many: collections <-> products)
CREATE TABLE collection_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  collection_id UUID NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

  -- Order in collection
  position INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(collection_id, product_id)
);

-- Indexes for collection_items
CREATE INDEX idx_collection_items_collection ON collection_items(collection_id);
CREATE INDEX idx_collection_items_product ON collection_items(product_id);
CREATE INDEX idx_collection_items_position ON collection_items(collection_id, position);

-- ============================================================================
-- WEEKLY OUTFITS TABLE (Personalized Recommendations)
-- ============================================================================

CREATE TABLE weekly_outfits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  -- Outfit type
  outfit_type TEXT NOT NULL CHECK (outfit_type IN ('coordinated', 'individual_item')),

  -- Coordinated outfit items (only for outfit_type='coordinated')
  top_product_id UUID REFERENCES products(id) ON DELETE SET NULL,
  bottom_product_id UUID REFERENCES products(id) ON DELETE SET NULL,
  shoes_product_id UUID REFERENCES products(id) ON DELETE SET NULL,
  accessory_product_id UUID REFERENCES products(id) ON DELETE SET NULL,

  -- Individual item (only for outfit_type='individual_item')
  product_id UUID REFERENCES products(id) ON DELETE SET NULL,

  -- ML confidence score
  confidence_score DECIMAL(3,2) CHECK (confidence_score >= 0 AND confidence_score <= 1),

  -- User interaction
  was_viewed BOOLEAN DEFAULT false,
  was_liked BOOLEAN DEFAULT false,

  -- Week identifier
  week_start_date DATE NOT NULL,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for weekly_outfits
CREATE INDEX idx_weekly_outfits_user ON weekly_outfits(user_id);
CREATE INDEX idx_weekly_outfits_week ON weekly_outfits(week_start_date DESC);
CREATE INDEX idx_weekly_outfits_user_week ON weekly_outfits(user_id, week_start_date DESC);
CREATE INDEX idx_weekly_outfits_type ON weekly_outfits(outfit_type);

-- ============================================================================
-- ANALYTICS EVENTS TABLE (Backup for Firebase Analytics)
-- ============================================================================

CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Identifiers
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID,

  -- Event data
  event_name TEXT NOT NULL,
  event_params JSONB, -- Flexible event parameters

  -- Context
  device_platform TEXT,
  app_version TEXT,

  -- Timestamp
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for analytics_events
CREATE INDEX idx_analytics_user ON analytics_events(user_id);
CREATE INDEX idx_analytics_event_name ON analytics_events(event_name);
CREATE INDEX idx_analytics_created ON analytics_events(created_at DESC);
CREATE INDEX idx_analytics_session ON analytics_events(session_id);

-- ============================================================================
-- TRIGGERS (Automated Updates)
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_brands_updated_at BEFORE UPDATE ON brands
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_collections_updated_at BEFORE UPDATE ON collections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to increment total_swirls when swirl is added
CREATE OR REPLACE FUNCTION increment_user_swirls()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users
    SET total_swirls = total_swirls + 1
    WHERE id = NEW.user_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER swirl_added AFTER INSERT ON swirls
    FOR EACH ROW EXECUTE FUNCTION increment_user_swirls();

-- Function to decrement total_swirls when swirl is removed
CREATE OR REPLACE FUNCTION decrement_user_swirls()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users
    SET total_swirls = total_swirls - 1
    WHERE id = OLD.user_id AND total_swirls > 0;
    RETURN OLD;
END;
$$ language 'plpgsql';

CREATE TRIGGER swirl_removed AFTER DELETE ON swirls
    FOR EACH ROW EXECUTE FUNCTION decrement_user_swirls();

-- Function to increment brand follower count
CREATE OR REPLACE FUNCTION increment_brand_followers()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE brands
    SET follower_count = follower_count + 1
    WHERE id = NEW.brand_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER brand_followed AFTER INSERT ON brand_follows
    FOR EACH ROW EXECUTE FUNCTION increment_brand_followers();

-- Function to decrement brand follower count
CREATE OR REPLACE FUNCTION decrement_brand_followers()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE brands
    SET follower_count = follower_count - 1
    WHERE id = OLD.brand_id AND follower_count > 0;
    RETURN OLD;
END;
$$ language 'plpgsql';

CREATE TRIGGER brand_unfollowed AFTER DELETE ON brand_follows
    FOR EACH ROW EXECUTE FUNCTION decrement_brand_followers();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE swirls ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlist ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE collection_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_outfits ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

-- Users: Can read own data, service role can do everything
CREATE POLICY users_select_own ON users FOR SELECT
    USING (auth.uid() = id OR is_anonymous = true);

CREATE POLICY users_update_own ON users FOR UPDATE
    USING (auth.uid() = id);

-- Products: Public read, service role can write
CREATE POLICY products_select_all ON products FOR SELECT
    TO authenticated, anon
    USING (true);

-- Brands: Public read
CREATE POLICY brands_select_all ON brands FOR SELECT
    TO authenticated, anon
    USING (true);

-- Swipes: Users can insert/read own swipes
CREATE POLICY swipes_insert_own ON swipes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY swipes_select_own ON swipes FOR SELECT
    USING (auth.uid() = user_id);

-- Swirls: Users can manage own swirls
CREATE POLICY swirls_all_own ON swirls
    USING (auth.uid() = user_id);

-- Wishlist: Users can manage own wishlist
CREATE POLICY wishlist_all_own ON wishlist
    USING (auth.uid() = user_id);

-- Brand Follows: Users can manage own follows
CREATE POLICY brand_follows_all_own ON brand_follows
    USING (auth.uid() = user_id);

-- Collections: Users can manage own collections, read public ones
CREATE POLICY collections_select_own_or_public ON collections FOR SELECT
    USING (auth.uid() = user_id OR is_public = true);

CREATE POLICY collections_manage_own ON collections
    USING (auth.uid() = user_id);

-- Collection Items: Follow collection permissions
CREATE POLICY collection_items_manage ON collection_items
    USING (
        EXISTS (
            SELECT 1 FROM collections
            WHERE collections.id = collection_items.collection_id
            AND (collections.user_id = auth.uid() OR collections.is_public = true)
        )
    );

-- Weekly Outfits: Users can read own outfits
CREATE POLICY weekly_outfits_select_own ON weekly_outfits FOR SELECT
    USING (auth.uid() = user_id);

-- Analytics: Users can insert own events
CREATE POLICY analytics_insert_own ON analytics_events FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- INITIAL DATA SETUP (Optional)
-- ============================================================================

-- Insert system user for anonymous tracking
INSERT INTO users (id, is_anonymous, anonymous_id, display_name)
VALUES ('00000000-0000-0000-0000-000000000000', true, '00000000-0000-0000-0000-000000000000', 'System')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- SCHEMA COMPLETE
-- ============================================================================

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'SWIRL database schema created successfully!';
    RAISE NOTICE 'Next steps:';
    RAISE NOTICE '1. Enable pgvector extension for ML features (optional)';
    RAISE NOTICE '2. Run mock data insert script';
    RAISE NOTICE '3. Configure Supabase Storage buckets for images';
    RAISE NOTICE '4. Set up Firebase Analytics (app-side)';
END $$;
