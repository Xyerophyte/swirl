# SWIRL - Product Requirements Document (PRD)

**Version:** 1.0
**Date:** November 12, 2025
**Status:** Draft for Implementation
**Author:** Product Team

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Product Vision & Goals](#2-product-vision--goals)
3. [Core Features](#3-core-features)
4. [User Experience](#4-user-experience)
5. [Technical Architecture](#5-technical-architecture)
6. [Data Models & Schema](#6-data-models--schema)
7. [Machine Learning & Personalization](#7-machine-learning--personalization)
8. [API Integration](#8-api-integration)
9. [Phase Breakdown](#9-phase-breakdown)
10. [Success Metrics](#10-success-metrics)

---

## 1. Executive Summary

### 1.1 Product Name
**SWIRL** - Personalized Fashion Discovery Platform

### 1.2 Product Tagline
"Swipe your style into existence"

### 1.3 Core Problem
Users in the UAE/Middle East struggle to discover fashion items that match their personal style across fragmented online stores. Traditional e-commerce requires active searching and filtering, creating friction in the discovery process.

### 1.4 Solution
SWIRL uses a swipe-based interface (Tinder for fashion) powered by AI-driven personalization to curate clothing items from UAE/Middle East online stores, learning user preferences through swipe behavior and delivering personalized weekly outfit recommendations.

### 1.5 Target Market
- **Primary:** UAE/Middle East fashion consumers (Ages 18-35)
- **Secondary:** Style-conscious users seeking personalized discovery
- **Tertiary:** Brand-conscious shoppers following specific fashion labels

### 1.6 Unique Value Proposition
- Zero-effort discovery through swipe mechanics
- AI learns preferences without explicit input
- Curated from actual UAE/Middle East stores (Amazon, Noon, Namshi)
- Personalized weekly outfit drops
- Frictionless anonymous browsing

---

## 2. Product Vision & Goals

### 2.1 Vision Statement
To become the primary fashion discovery platform in the Middle East by making personalized style curation as addictive and effortless as swiping on social media.

### 2.2 Product Goals

#### Short-term (3 months)
- Launch MVP with core swipe functionality
- Achieve 10,000+ items swiped per day
- Build ML dataset with 50,000+ swipe interactions
- Establish product catalog from 3+ major stores

#### Medium-term (6 months)
- Implement ML-powered personalization
- Launch weekly outfit recommendations
- Achieve 70%+ user return rate (Day 7)
- Partner with 5+ UAE/Middle East brands

#### Long-term (12 months)
- Full checkout integration
- Social features (outfit collections, influencer follows)
- Expand to GCC markets
- Launch brand analytics dashboard

---

## 3. Core Features

### 3.1 Swipe-Based Discovery

#### 3.1.1 Swipe Mechanics
**Gesture Mapping:**
- **Swipe Right** → Like / Save (Swirl)
- **Swipe Left** → View Details (full product info)
- **Swipe Up** → Next Card (skip)
- **Swipe Down** → Quick Save to Wishlist

**Interaction Rules:**
- Minimum swipe distance: 30% of screen width
- Velocity threshold: 300 pixels/second
- Animation duration: 300ms with ease-out cubic curve
- Haptic feedback: Light impact on swipe, medium on save

#### 3.1.2 Card Interface
**Card Components:**
- Primary product image (full card background)
- Product name (18px, SemiBold)
- Brand name (14px, Regular)
- Price (20px, Bold)
- Original price if discounted (16px, strikethrough)
- Like indicator (animated heart)
- Dislike indicator (animated X)

**Card Stack:**
- Visible: 3 cards (current + 2 behind)
- Preloaded: Next 5 cards fully loaded
- Queued: Next 5 cards loading
- Fetched: Next 10 cards in background

#### 3.1.3 Detail View (Left Swipe)
**Full-Screen Modal:**
- Image carousel (swipeable, 3-5 images)
- Product title & brand
- Price & discount badge
- Size selector (interactive chips)
- Color selector (interactive swatches)
- Full description (expandable)
- Materials & care instructions
- "Buy Now" CTA (redirects to store)
- "Add to Cart" button (Phase 2)
- Back gesture to return to feed

**Transition:**
- Shared-element animation from card to modal
- Duration: 400ms
- Curve: Ease-in-out

### 3.2 Swirls Metric

#### 3.2.1 Definition
"Swirls" are the unique engagement metric representing items a user has liked or saved.

**Counting Rules:**
- Right swipe (Like) = +1 Swirl
- Down swipe (Quick Wishlist) = +1 Swirl
- Double-tap on card = +1 Swirl
- Removing from wishlist = -1 Swirl (but keeps swipe data)

#### 3.2.2 Display Locations
- User stats screen: Total Swirls count
- Profile: Swirl history timeline
- Bottom nav badge: New Swirls since last view

### 3.3 Personalized Weekly Outfits

#### 3.3.1 Format
**Weekly Drop Contents:**
- 1-2 Complete Coordinated Outfits (top + bottom + shoes + optional accessory)
- 5 Individual High-Confidence Items

**Delivery:**
- Push notification: Every Monday 9 AM local time
- In-app banner: "Your Weekly Swirl is Ready"
- Dedicated section: "This Week for You" in Home tab

#### 3.3.2 Personalization Logic
**Input Signals:**
- Swipe history (liked categories, brands, price points)
- Dwell time on cards
- Items viewed in detail (left swipe)
- Style filter preferences
- Followed brands
- Time-of-day patterns
- Seasonal relevance

**Output Criteria:**
- Min 80% confidence score for outfit items
- Min 70% confidence for individual items
- Price range: User's average ± 30%
- Category balance: Mix of discovered + familiar
- Freshness: 70% new items, 30% similar to liked

### 3.4 Style Filters

#### 3.4.1 Available Styles
1. **Minimalist** - Clean lines, neutral colors, simple silhouettes
2. **Urban Vibe** - Streetwear, contemporary, bold graphics
3. **Streetwear Edge** - Athletic, oversized, brand-heavy
4. **Avant-Garde** - Experimental, high-fashion, unique cuts

#### 3.4.2 Filter Behavior
**Multi-Select:**
- Users can select multiple styles simultaneously
- Default: All styles enabled on first launch
- Persistence: Saved locally + synced to backend

**Impact on Feed:**
- **Soft Bias Mode (Default):** Increases score/rank of matching items, doesn't exclude others
- **Strict Filter Mode (Optional):** Only shows items matching selected styles

**UI:**
- Horizontal scrollable chips on Home screen
- Toggleable pills (filled = active, outline = inactive)
- Live feed re-ranking on toggle (no reload)

### 3.5 Brand Following

#### 3.5.1 Follow Functionality
**How to Follow:**
- Tap brand name on product card → Brand profile sheet
- Tap "Follow" button on brand profile
- Auto-follow brands with 5+ consecutive likes

**Follow Benefits:**
- Soft priority in main feed (1.5x score boost)
- Separate "Following" tab with brand-only feed
- Weekly digest: "New Arrivals from [Brand]"

#### 3.5.2 Brand Profile
**Content:**
- Brand logo & description
- Total items in catalog
- User's liked items from brand
- Latest arrivals (last 7 days)
- Brand style tags
- Link to brand store

### 3.6 Search & Browse

#### 3.6.1 Search Functionality
**Text Search:**
- Real-time suggestions as you type
- Search scope: Product names, brands, categories
- Search history: Last 10 searches
- Trending searches: Auto-populated

**Search Filters:**
- Category (Men, Women, Unisex, Accessories, Shoes)
- Price range (slider with AED currency)
- Brand (multi-select from followed + popular)
- Color (visual color chips)
- Style tags (same as style filters)
- Size (multi-select)
- Availability (In stock only toggle)

**Search Results:**
- Grid view (2 columns on mobile)
- Sort options: Relevance, Price (low-high), Price (high-low), Newest, Most liked
- Quick actions on cards: Like, Wishlist, View details

#### 3.6.2 Browse Categories
**Primary Categories:**
- Men
- Women
- Unisex
- Accessories
- Shoes
- New / Trending

**Category Display:**
- Horizontal category selector at top of Search tab
- Active category highlighted
- Subcategories expand below (e.g., Men → Shirts, Pants, Outerwear)

### 3.7 Social Features

#### 3.7.1 Phase 1 (MVP)
- Like items (Swirls)
- Follow brands
- Share individual items (native share sheet)

#### 3.7.2 Phase 2 (Future)
- Create outfit collections ("My Swirls")
- Follow other users
- Comment on items
- Follow fashion influencers
- User-generated outfit boards
- "Worn by" influencer tags

### 3.8 Bottom Navigation

#### 3.8.1 Navigation Structure
**4 Primary Tabs:**

1. **Home** (Icon: Layers/Cards)
   - Main swipe feed
   - Style filter chips
   - Weekly outfit banner

2. **Search** (Icon: Magnifying glass)
   - Search bar
   - Category browser
   - Filter modal
   - Search results grid

3. **Swirls** (Icon: Heart)
   - Liked items grid
   - Wishlist items
   - Saved outfits (Phase 2)
   - Collections (Phase 2)

4. **Profile** (Icon: Person)
   - User stats (Swirls count, Following count, Days active)
   - Style preferences editor
   - Settings
   - Help & feedback

**Navigation Behavior:**
- Persistent bottom bar (visible on all screens)
- Active tab highlighted with filled icon + accent color
- Smooth tab transitions (fade + slight scale)
- Tab badge for new items in Swirls

---

## 4. User Experience

### 4.1 User Flow

#### 4.1.1 Primary Flow
```
Launch App → [Optional Onboarding] → Swipe Feed → Like (Right) → Save to Swirls →
View in Swirls Tab → Tap Item → Detail View → Buy Now → External Store
```

#### 4.1.2 Secondary Flow
```
Launch App → Search Tab → Enter Keyword → Apply Filters →
Browse Results → Like Items → Add to Wishlist → View Details → Buy Now
```

#### 4.1.3 Discovery Flow
```
Swipe Feed → Like Multiple Items → ML Learns Preferences →
Weekly Outfit Notification → Open App → View Curated Outfits →
Like Outfit Items → Refine Recommendations
```

### 4.2 Onboarding

#### 4.2.1 First Launch Experience
**Optional Quick Quiz (3 Questions):**

**Question 1: Gender Preference**
- Men's Fashion
- Women's Fashion
- Both
- Skip

**Question 2: Style Preferences (Select 1-2)**
- Minimalist
- Urban Vibe
- Streetwear Edge
- Avant-Garde

**Question 3: Price Comfort Zone**
- Budget-Friendly (Under 200 AED)
- Mid-Range (200-500 AED)
- Premium (500-1000 AED)
- Luxury (1000+ AED)

**Skip Option:**
- Prominent "Start Swiping Now" button at bottom
- If skipped: Show trending items + prompt quiz later

#### 4.2.2 Cold Start Seed Content
**If Quiz Completed:**
- 70% items matching selected styles
- 30% diverse discovery items
- Price range: User's selected tier ± 20%

**If Quiz Skipped:**
- Show region's trending items
- Balanced mix of all style categories
- Mid-range pricing focus
- "Quick Swipe 8 Items" mini-session prompt after 3 swipes

### 4.3 Authentication

#### 4.3.1 Anonymous Browsing
**Default Behavior:**
- No login required on first launch
- Local storage for swipe history
- Swirls & wishlist saved locally
- UUID assigned for anonymous tracking

**Limitations:**
- Data not synced across devices
- No access to weekly outfit notifications
- Cannot participate in social features (Phase 2)

#### 4.3.2 Auth Triggers
**User Prompted to Sign Up When:**
- Attempting to purchase (redirect to Buy Now)
- Opening app on a different device
- Reaching 50+ Swirls (prompt: "Save your style forever")
- Accessing Profile stats (show what they'll get)

**Auth Methods:**
- Email + Password (Supabase Auth)
- Google Sign-In
- Apple Sign-In
- Phone Number (OTP)

**Data Migration:**
- On signup: Migrate anonymous swipe history to user account
- Preserve Swirls, wishlist, and preferences
- Seamless transition (no data loss)

### 4.4 Notifications

#### 4.4.1 Push Notifications
**Enabled Notifications:**
- Weekly outfit drop (Monday 9 AM)
- Followed brand new arrivals (Max 1/day)
- Price drop on wishlist items
- Back in stock alerts
- App re-engagement (if 3+ days inactive)

**Disabled by Default:**
- Social notifications (Phase 2)
- Daily swipe reminders
- General marketing

---

## 5. Technical Architecture

### 5.1 Tech Stack

#### 5.1.1 Frontend
**Framework:** Flutter (Dart)
- **Why:** Single codebase for iOS + Android, excellent performance, rich animation support

**Key Libraries:**
- `flutter_riverpod` - State management
- `flutter_animate` - Complex animations
- `cached_network_image` - Image caching
- `shimmer` - Loading placeholders
- `photo_view` - Image zoom in detail view
- `smooth_page_indicator` - Carousel indicators

#### 5.1.2 Backend
**Framework:** Node.js (Express)
- **Why:** Fast prototyping, excellent ecosystem, easy ML integration

**Key Services:**
- Product catalog API
- Recommendation engine
- Weekly outfit generator
- Image processing pipeline
- Analytics collector

#### 5.1.3 Database
**Primary:** Supabase (Postgres)
- **Why:** Real-time capabilities, built-in auth, generous free tier, SQL flexibility

**Storage:** Supabase Storage (CDN-backed)
- **Why:** Integrated with Postgres, automatic CDN, image transformations

#### 5.1.4 ML & Personalization
**Framework:** TensorFlow.js or Python microservice
- **Why:** Flexible deployment, can run inference on backend or edge

**Initial Approach:**
- Content-based filtering using item embeddings
- Collaborative filtering as user base grows
- Hybrid model combining both

#### 5.1.5 Analytics
**Platform:** Firebase Analytics (hidden from user)
- **Why:** Free, comprehensive, easy Flutter integration, no visible UI

### 5.2 System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        Flutter App                          │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Swipe UI  │  │  Search UI   │  │  Profile UI  │      │
│  └──────┬──────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                │                  │               │
│         └────────────────┴──────────────────┘               │
│                          │                                  │
│                 ┌────────▼─────────┐                        │
│                 │  Riverpod State  │                        │
│                 └────────┬─────────┘                        │
│                          │                                  │
│         ┌────────────────┼────────────────┐                │
│         │                │                │                │
│  ┌──────▼──────┐  ┌──────▼──────┐  ┌─────▼─────┐          │
│  │  Product    │  │    User     │  │ Analytics │          │
│  │  Repository │  │  Repository │  │Repository │          │
│  └──────┬──────┘  └──────┬──────┘  └─────┬─────┘          │
│         │                │                │                │
└─────────┼────────────────┼────────────────┼────────────────┘
          │                │                │
          │                │                │
┌─────────▼────────────────▼────────────────▼────────────────┐
│                    API Gateway (Express)                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  Product API │  │  User API    │  │  Swipe API   │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                 │                  │              │
│         └─────────────────┴──────────────────┘              │
│                           │                                 │
└───────────────────────────┼─────────────────────────────────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
  ┌───────▼────────┐ ┌──────▼──────┐ ┌───────▼────────┐
  │   Supabase     │ │   Firebase  │ │  Amazon API    │
  │   (Postgres)   │ │  Analytics  │ │  (Mock Data)   │
  └────────────────┘ └─────────────┘ └────────────────┘
          │
          │
  ┌───────▼────────┐
  │  ML Inference  │
  │   (TF.js or    │
  │  Python svc)   │
  └────────────────┘
```

### 5.3 Performance Requirements

#### 5.3.1 Loading Times
- Initial app launch: < 2 seconds
- Card transitions: < 300ms (60 FPS)
- Image load time: < 1 second (with progressive loading)
- Search results: < 500ms

#### 5.3.2 Feed Preloading
- Next 5 cards: Fully loaded (images cached)
- Next 5 cards: In loading queue
- Next 10 cards: Fetched from API (metadata only)
- Background fetch triggers when 5 cards remaining

#### 5.3.3 Memory Management
- Max loaded cards in memory: 10
- Dispose cards after 10 positions behind
- Image cache limit: 100 MB
- Clear cache on low memory warning

---

## 6. Data Models & Schema

### 6.1 Database Tables

#### 6.1.1 Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Anonymous tracking
  anonymous_id UUID UNIQUE,
  is_anonymous BOOLEAN DEFAULT true,

  -- Auth (when user signs up)
  email TEXT UNIQUE,
  phone TEXT UNIQUE,
  auth_provider TEXT, -- 'email', 'google', 'apple', 'phone'

  -- Profile
  display_name TEXT,
  avatar_url TEXT,

  -- Onboarding data
  gender_preference TEXT, -- 'men', 'women', 'both', null
  style_preferences TEXT[], -- ['minimalist', 'urban_vibe', 'streetwear_edge', 'avant_garde']
  price_tier TEXT, -- 'budget', 'mid_range', 'premium', 'luxury'

  -- Computed preferences (ML-driven)
  preferred_categories TEXT[] DEFAULT ARRAY[]::TEXT[],
  preferred_brands TEXT[] DEFAULT ARRAY[]::TEXT[],
  preferred_colors TEXT[] DEFAULT ARRAY[]::TEXT[],
  avg_liked_price DECIMAL(10,2),

  -- Stats
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

CREATE INDEX idx_users_anonymous ON users(anonymous_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_last_seen ON users(last_seen_at);
```

#### 6.1.2 Products Table
```sql
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Source data
  external_id TEXT UNIQUE NOT NULL, -- Amazon ASIN or equivalent
  source_store TEXT NOT NULL, -- 'amazon', 'noon', 'namshi'
  source_url TEXT NOT NULL,

  -- Basic info
  name TEXT NOT NULL,
  brand TEXT NOT NULL,
  description TEXT,

  -- Pricing
  price DECIMAL(10,2) NOT NULL,
  original_price DECIMAL(10,2), -- If discounted
  currency TEXT DEFAULT 'AED',
  discount_percentage INTEGER DEFAULT 0,

  -- Classification
  category TEXT NOT NULL, -- 'men', 'women', 'unisex', 'accessories', 'shoes'
  subcategory TEXT, -- 'shirts', 'pants', 'dresses', etc.
  style_tags TEXT[] DEFAULT ARRAY[]::TEXT[], -- ['minimalist', 'urban_vibe', ...]

  -- Product details
  sizes TEXT[] DEFAULT ARRAY[]::TEXT[],
  colors TEXT[] DEFAULT ARRAY[]::TEXT[],
  materials TEXT,
  care_instructions TEXT,

  -- Images
  primary_image_url TEXT NOT NULL,
  additional_images TEXT[] DEFAULT ARRAY[]::TEXT[],
  cdn_primary_image TEXT, -- Our CDN mirror
  cdn_thumbnail TEXT, -- Small thumbnail
  cdn_medium TEXT, -- Medium size

  -- Quality metrics
  rating DECIMAL(2,1) DEFAULT 0,
  review_count INTEGER DEFAULT 0,

  -- Flags
  is_trending BOOLEAN DEFAULT false,
  is_new_arrival BOOLEAN DEFAULT false,
  is_flash_sale BOOLEAN DEFAULT false,
  is_in_stock BOOLEAN DEFAULT true,
  stock_count INTEGER DEFAULT 100,

  -- ML embeddings (for recommendations)
  embedding VECTOR(512), -- Using pgvector extension

  -- Metadata
  metadata JSONB, -- Flexible additional data
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_synced_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_brand ON products(brand);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_style_tags ON products USING GIN(style_tags);
CREATE INDEX idx_products_trending ON products(is_trending) WHERE is_trending = true;
CREATE INDEX idx_products_new ON products(is_new_arrival) WHERE is_new_arrival = true;
CREATE INDEX idx_products_embedding ON products USING ivfflat(embedding vector_cosine_ops) WITH (lists = 100);
```

#### 6.1.3 Swipes Table (Comprehensive Tracking)
```sql
CREATE TABLE swipes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Identifiers
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  session_id UUID, -- Group swipes by session

  -- Swipe data
  direction TEXT NOT NULL, -- 'right', 'left', 'up', 'down'
  swipe_action TEXT NOT NULL, -- 'like', 'details_view', 'skip', 'wishlist'

  -- Engagement metrics
  dwell_ms INTEGER, -- Time spent viewing card before swipe
  card_position INTEGER, -- Position in feed (0-indexed)
  is_repeat_view BOOLEAN DEFAULT false, -- Saw this item before?

  -- Context (snapshot at swipe time)
  price DECIMAL(10,2),
  currency TEXT DEFAULT 'AED',
  brand TEXT,
  category TEXT,
  subcategory TEXT,
  style_tags TEXT[] DEFAULT ARRAY[]::TEXT[],

  -- Device context
  device_locale TEXT,
  device_platform TEXT, -- 'ios', 'android'

  -- ML features (for training)
  active_style_filters TEXT[] DEFAULT ARRAY[]::TEXT[],
  time_of_day INTEGER, -- Hour of day (0-23)
  day_of_week INTEGER, -- 0 = Sunday, 6 = Saturday

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_swipes_user ON swipes(user_id);
CREATE INDEX idx_swipes_product ON swipes(product_id);
CREATE INDEX idx_swipes_direction ON swipes(direction);
CREATE INDEX idx_swipes_action ON swipes(swipe_action);
CREATE INDEX idx_swipes_session ON swipes(session_id);
CREATE INDEX idx_swipes_created ON swipes(created_at);
```

#### 6.1.4 Brands Table
```sql
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

  -- Stats
  total_products INTEGER DEFAULT 0,
  avg_price DECIMAL(10,2),
  follower_count INTEGER DEFAULT 0,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_brands_name ON brands(name);
CREATE INDEX idx_brands_slug ON brands(slug);
```

#### 6.1.5 Brand Follows Table
```sql
CREATE TABLE brand_follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,

  -- Follow metadata
  source TEXT, -- 'manual', 'auto_5_likes', 'onboarding'
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, brand_id)
);

CREATE INDEX idx_brand_follows_user ON brand_follows(user_id);
CREATE INDEX idx_brand_follows_brand ON brand_follows(brand_id);
```

#### 6.1.6 Swirls (Liked Items) Table
```sql
CREATE TABLE swirls (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

  -- Swirl metadata
  source TEXT, -- 'swipe_right', 'swipe_down', 'double_tap', 'detail_view'
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, product_id)
);

CREATE INDEX idx_swirls_user ON swirls(user_id);
CREATE INDEX idx_swirls_product ON swirls(product_id);
CREATE INDEX idx_swirls_created ON swirls(created_at);
```

#### 6.1.7 Wishlist Table
```sql
CREATE TABLE wishlist (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

  -- Wishlist metadata
  source TEXT, -- 'swipe_down', 'detail_view_button'
  notes TEXT, -- User can add personal notes
  price_alert_enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, product_id)
);

CREATE INDEX idx_wishlist_user ON wishlist(user_id);
CREATE INDEX idx_wishlist_product ON wishlist(product_id);
```

#### 6.1.8 Collections Table (Phase 2)
```sql
CREATE TABLE collections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  -- Collection info
  name TEXT NOT NULL,
  description TEXT,
  cover_image_url TEXT,

  -- Visibility
  is_public BOOLEAN DEFAULT false,

  -- Stats
  item_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE collection_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  collection_id UUID NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

  -- Order in collection
  position INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(collection_id, product_id)
);
```

#### 6.1.9 Weekly Outfits Table
```sql
CREATE TABLE weekly_outfits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  -- Outfit type
  outfit_type TEXT NOT NULL, -- 'coordinated', 'individual_item'

  -- Outfit items (for coordinated)
  top_product_id UUID REFERENCES products(id),
  bottom_product_id UUID REFERENCES products(id),
  shoes_product_id UUID REFERENCES products(id),
  accessory_product_id UUID REFERENCES products(id),

  -- Individual item (if not coordinated)
  product_id UUID REFERENCES products(id),

  -- ML confidence
  confidence_score DECIMAL(3,2), -- 0.00 to 1.00

  -- User interaction
  was_viewed BOOLEAN DEFAULT false,
  was_liked BOOLEAN DEFAULT false,

  -- Week identifier
  week_start_date DATE NOT NULL,

  -- Metadata
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_weekly_outfits_user ON weekly_outfits(user_id);
CREATE INDEX idx_weekly_outfits_week ON weekly_outfits(week_start_date);
```

#### 6.1.10 Analytics Events Table (Firebase backup)
```sql
CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Identifiers
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  session_id UUID,

  -- Event data
  event_name TEXT NOT NULL,
  event_params JSONB,

  -- Context
  device_platform TEXT,
  app_version TEXT,

  -- Timestamp
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_analytics_user ON analytics_events(user_id);
CREATE INDEX idx_analytics_event_name ON analytics_events(event_name);
CREATE INDEX idx_analytics_created ON analytics_events(created_at);
```

### 6.2 Data Model Relationships

```
users (1) ─────< (many) swipes
users (1) ─────< (many) swirls
users (1) ─────< (many) wishlist
users (1) ─────< (many) brand_follows
users (1) ─────< (many) collections
users (1) ─────< (many) weekly_outfits

products (1) ───< (many) swipes
products (1) ───< (many) swirls
products (1) ───< (many) wishlist
products (1) ───< (many) collection_items
products (1) ───< (many) weekly_outfits

brands (1) ─────< (many) brand_follows
brands (1) ─────< (many) products (FK: brand_name)

collections (1) ─< (many) collection_items
```

---

## 7. Machine Learning & Personalization

### 7.1 Data Collection Strategy

#### 7.1.1 Swipe Tracking
**Every swipe records:**
- `direction` - right/left/up/down
- `swipe_action` - like/details_view/skip/wishlist
- `dwell_ms` - Time spent viewing card
- `card_position` - Position in feed
- `is_repeat_view` - Saw this before?
- Product snapshot: price, brand, category, subcategory, style_tags
- Context: active_style_filters, time_of_day, day_of_week

**Implicit Positive Signals:**
- Right swipe (Like): Strong positive (+10)
- Left swipe (Details view): Medium positive (+5)
- Down swipe (Wishlist): Strong positive (+10)
- High dwell time (>3s): Weak positive (+2)
- Repeat view: Interest signal (+3)

**Implicit Negative Signals:**
- Up swipe (Skip): Strong negative (-5)
- Low dwell time (<1s): Weak negative (-1)

#### 7.1.2 Engagement Metrics
**Session-level:**
- Session duration
- Swipes per session
- Like rate (likes / total swipes)
- Skip rate (skips / total swipes)
- Detail view rate (details / total swipes)
- Average dwell time

**User-level:**
- Total swipes
- Total swirls (likes)
- Category affinity scores
- Brand affinity scores
- Price sensitivity
- Style consistency

### 7.2 Recommendation Engine

#### 7.2.1 Phase 1: Rule-Based
**Initial Implementation (No ML model yet):**

```javascript
function getRankedFeed(user) {
  let products = getAllProducts();

  // Base scoring
  products = products.map(p => ({
    ...p,
    score: calculateBaseScore(p, user)
  }));

  // Apply boosts
  products = applyFilters(products, user);

  // Diversity injection
  products = injectDiversity(products);

  // Sort and return
  return products.sort((a, b) => b.score - a.score);
}

function calculateBaseScore(product, user) {
  let score = 0;

  // Category match
  if (user.preferred_categories.includes(product.category)) {
    score += 10;
  }

  // Brand match
  if (user.preferred_brands.includes(product.brand)) {
    score += 8;
  }

  // Price match (within ±30% of user's avg)
  const priceRatio = product.price / user.avg_liked_price;
  if (priceRatio >= 0.7 && priceRatio <= 1.3) {
    score += 5;
  }

  // Style filter match
  const styleMatch = product.style_tags.filter(
    tag => user.active_style_filters.includes(tag)
  ).length;
  score += styleMatch * 3;

  // Trending boost
  if (product.is_trending) score += 3;
  if (product.is_new_arrival) score += 2;

  // Followed brand boost
  if (user.followed_brands.includes(product.brand)) {
    score += 15; // Soft priority (1.5x effective)
  }

  return score;
}
```

#### 7.2.2 Phase 2: ML-Powered
**Model Architecture:**

**Content-Based Filtering:**
- Product embeddings using CLIP (image + text)
- User profile embedding (aggregated from liked items)
- Cosine similarity for ranking

**Collaborative Filtering:**
- User-item interaction matrix
- Matrix factorization (ALS or SVD)
- "Users like you also liked..."

**Hybrid Model:**
- Combine content + collaborative scores
- Weighted average: 60% content, 40% collaborative
- Contextual bandits for A/B testing

**Model Training:**
- Frequency: Weekly batch training
- Data: All swipes from past 60 days
- Validation: Hold out last 7 days
- Metrics: CTR, Like Rate, Session Duration

### 7.3 Weekly Outfit Generation

#### 7.3.1 Algorithm
```python
def generate_weekly_outfits(user_id):
    user = get_user(user_id)
    user_embedding = compute_user_embedding(user)

    # Get candidate products (high confidence items)
    candidates = get_high_confidence_products(user_embedding, min_score=0.7)

    # Generate coordinated outfits
    outfits = []

    # Outfit 1: Casual
    casual = {
        'top': find_best_match(candidates, category='shirts', style='casual'),
        'bottom': find_best_match(candidates, category='pants', style='casual'),
        'shoes': find_best_match(candidates, category='shoes', style='casual'),
        'confidence': calculate_outfit_confidence()
    }
    if casual['confidence'] > 0.8:
        outfits.append(casual)

    # Outfit 2: Smart/Formal (if user has shown interest)
    if user.has_liked_category('formal'):
        formal = {
            'top': find_best_match(candidates, category='shirts', style='formal'),
            'bottom': find_best_match(candidates, category='pants', style='formal'),
            'shoes': find_best_match(candidates, category='shoes', style='formal'),
            'confidence': calculate_outfit_confidence()
        }
        if formal['confidence'] > 0.8:
            outfits.append(formal)

    # Individual items (top 5 confidence)
    individual_items = get_top_items(candidates, count=5)

    return {
        'coordinated_outfits': outfits,
        'individual_items': individual_items
    }
```

#### 7.3.2 Outfit Compatibility
**Matching Rules:**
- Color harmony (complementary or analogous colors)
- Style consistency (don't mix avant-garde with minimalist)
- Occasion appropriateness (casual/formal/sport)
- Season relevance (UAE weather: mostly hot)
- Price balance (items within similar tier)

### 7.4 Cold Start Strategy

#### 7.4.1 Onboarding Quiz Impact
**Quiz Completed:**
- Use selected gender, styles, price tier
- Fetch seed products matching criteria
- Start with 70% match, 30% diverse

**Quiz Skipped:**
- Show region's trending items
- Balanced style mix
- Mid-range pricing

#### 7.4.2 Fast Learning
**"Quick Swipe 8 Items" Mini-Session:**
- After 3 swipes, prompt: "Swipe 5 more to unlock personalization"
- Show diverse items (2 per style category)
- Immediate feedback: "Learning your style..."
- After 8 swipes: Apply initial personalization

#### 7.4.3 First Session Optimization
**Goals:**
- Collect 20+ swipes
- Identify at least 2 liked categories
- Capture 1+ brand preference
- Get sense of price sensitivity

**Tactics:**
- Mix obvious choices with variety
- Inject 2-3 highly popular items (85%+ like rate)
- Show breadth early, depth later

---

## 8. API Integration

### 8.1 Amazon API (Product Source)

#### 8.1.1 API Structure
**Endpoint:** Amazon Product Advertising API 5.0
**Note:** Using mock data for Phase 1 testing; real API integration in Phase 2

**Required Fields:**
- ASIN (unique product ID)
- Title
- Brand
- Price & original price
- Images (primary + additional)
- Product URL
- Category & subcategory
- Availability status
- Rating & review count

#### 8.1.2 Mock Data Structure
```json
{
  "asin": "B07XYZ12345",
  "title": "Men's Slim Fit Oxford Shirt - Long Sleeve",
  "brand": "Amazon Essentials",
  "price": {
    "value": 89.00,
    "currency": "AED",
    "original_value": 129.00
  },
  "images": {
    "primary": "https://m.media-amazon.com/images/I/71abc123xyz.jpg",
    "additional": [
      "https://m.media-amazon.com/images/I/71def456uvw.jpg",
      "https://m.media-amazon.com/images/I/71ghi789rst.jpg"
    ]
  },
  "url": "https://www.amazon.ae/dp/B07XYZ12345",
  "category": "men",
  "subcategory": "shirts",
  "style_tags": ["minimalist", "urban_vibe"],
  "sizes": ["S", "M", "L", "XL", "XXL"],
  "colors": ["White", "Blue", "Black"],
  "materials": "100% Cotton",
  "rating": 4.5,
  "review_count": 234,
  "is_in_stock": true,
  "is_trending": false,
  "is_new_arrival": true
}
```

#### 8.1.3 Product Sync Process
**Frequency:** Weekly (Every Sunday at 2 AM UAE time)

**Process:**
1. Query Amazon API for each category × brand combination
2. Fetch 50-100 products per query
3. Deduplicate by ASIN
4. Download product images
5. Generate thumbnails (small: 150x150, medium: 400x400)
6. Upload images to Supabase Storage
7. Extract style tags using ML classifier
8. Compute product embeddings (CLIP)
9. Upsert products to database (update if ASIN exists)
10. Update brand catalog
11. Log sync results

**Error Handling:**
- Rate limiting: Exponential backoff
- Missing images: Use placeholder
- Invalid data: Skip product, log error
- API downtime: Retry after 1 hour

### 8.2 Backend API Endpoints

#### 8.2.1 Feed API
```
GET /api/v1/feed
  Query Params:
    - user_id (UUID)
    - limit (int, default 20)
    - offset (int, default 0)
    - style_filters (array of strings)

  Response:
    {
      "products": [...],
      "next_offset": 20,
      "has_more": true
    }
```

#### 8.2.2 Swipe API
```
POST /api/v1/swipes
  Body:
    {
      "user_id": "uuid",
      "product_id": "uuid",
      "direction": "right",
      "swipe_action": "like",
      "dwell_ms": 2345,
      "card_position": 5,
      ...
    }

  Response:
    {
      "success": true,
      "updated_swirls_count": 42
    }
```

#### 8.2.3 Search API
```
GET /api/v1/search
  Query Params:
    - q (string, search query)
    - category (string)
    - min_price (decimal)
    - max_price (decimal)
    - brand (array of strings)
    - color (array of strings)
    - style_tags (array of strings)
    - sort (string: relevance|price_asc|price_desc|newest)
    - limit (int)
    - offset (int)

  Response:
    {
      "results": [...],
      "total_count": 156,
      "facets": {
        "brands": {"Nike": 23, "Adidas": 18, ...},
        "colors": {"Black": 45, "White": 32, ...},
        "price_ranges": [...]
      }
    }
```

#### 8.2.4 Brand API
```
GET /api/v1/brands/:brand_id
  Response:
    {
      "id": "uuid",
      "name": "Nike",
      "logo_url": "...",
      "description": "...",
      "total_products": 234,
      "avg_price": 249.00,
      "style_tags": ["streetwear_edge", "urban_vibe"],
      "is_followed": true,
      "latest_products": [...]
    }

POST /api/v1/brands/:brand_id/follow
  Body: { "user_id": "uuid" }
  Response: { "success": true }
```

#### 8.2.5 Weekly Outfit API
```
GET /api/v1/weekly-outfits
  Query Params:
    - user_id (UUID)
    - week (date, default current week)

  Response:
    {
      "coordinated_outfits": [
        {
          "id": "uuid",
          "type": "casual",
          "items": {
            "top": {...},
            "bottom": {...},
            "shoes": {...}
          },
          "confidence": 0.85
        }
      ],
      "individual_items": [...]
    }
```

---

## 9. Phase Breakdown

### 9.1 Phase 1: MVP (Weeks 1-6)

#### Week 1-2: Foundation
- [ ] Supabase project setup
- [ ] Database schema implementation
- [ ] Flutter project structure
- [ ] Design system (colors, typography, components)
- [ ] Mock product data (200 items)
- [ ] Basic navigation structure

#### Week 3-4: Core Features
- [ ] Swipeable card component
- [ ] Gesture detection (right/left/up/down)
- [ ] Feed preloading logic
- [ ] Product detail view (left swipe)
- [ ] Swirls (liked items) screen
- [ ] Wishlist functionality
- [ ] Basic analytics tracking (Firebase)

#### Week 5-6: Personalization & Polish
- [ ] Onboarding quiz
- [ ] Style filters (multi-select)
- [ ] Rule-based feed ranking
- [ ] Brand following
- [ ] Search functionality
- [ ] Image caching & optimization
- [ ] Haptic feedback
- [ ] Animation polish

**Phase 1 Success Criteria:**
- Users can swipe through 100+ items
- Like rate > 20%
- Average session > 5 minutes
- Feed loads smoothly (no lag)
- Analytics tracking 10+ events

### 9.2 Phase 2: ML & Enhanced Features (Weeks 7-12)

#### Week 7-8: ML Infrastructure
- [ ] Swipe data export pipeline
- [ ] Product embedding generation (CLIP)
- [ ] User profile embeddings
- [ ] Content-based recommendation model
- [ ] ML inference API

#### Week 9-10: Weekly Outfits
- [ ] Outfit generation algorithm
- [ ] Outfit compatibility scoring
- [ ] Weekly push notifications
- [ ] Outfit detail view
- [ ] "Save Outfit" functionality

#### Week 11-12: Enhanced Discovery
- [ ] Advanced search filters
- [ ] Followed brands feed tab
- [ ] Price drop alerts
- [ ] Back in stock notifications
- [ ] Share functionality
- [ ] Performance optimization

**Phase 2 Success Criteria:**
- ML model improves like rate by 10%+
- Weekly outfit open rate > 40%
- User return rate (Day 7) > 60%
- Search usage > 30% of sessions

### 9.3 Phase 3: E-commerce & Social (Weeks 13-20)

#### Week 13-15: Shopping Cart & Checkout
- [ ] Shopping cart functionality
- [ ] Multi-item checkout
- [ ] Payment integration (Stripe, local gateways)
- [ ] Order history
- [ ] Order tracking (via store APIs)

#### Week 16-18: Social Features
- [ ] User profiles
- [ ] Follow users
- [ ] Outfit collections ("My Swirls")
- [ ] Comments on items
- [ ] User feed (see what followers liked)
- [ ] Influencer discovery

#### Week 19-20: Advanced ML
- [ ] Collaborative filtering
- [ ] Hybrid recommendation model
- [ ] A/B testing framework
- [ ] Contextual bandits
- [ ] Real-time personalization

**Phase 3 Success Criteria:**
- GMV (Gross Merchandise Value) > $50K/month
- Conversion rate > 5%
- Social engagement rate > 15%
- User retention (Day 30) > 40%

---

## 10. Success Metrics

### 10.1 Key Performance Indicators (KPIs)

#### 10.1.1 Engagement Metrics
**Daily Active Users (DAU):**
- Phase 1 Target: 1,000 DAU
- Phase 2 Target: 5,000 DAU
- Phase 3 Target: 20,000 DAU

**Session Metrics:**
- Average session duration: > 10 minutes (Phase 1), > 15 minutes (Phase 2)
- Sessions per day per user: > 3
- Swipes per session: > 50 (Phase 1), > 75 (Phase 2)

**Like Rate:**
- Phase 1: > 20%
- Phase 2: > 25% (with ML)
- Phase 3: > 30% (with advanced ML)

#### 10.1.2 Retention Metrics
**Day 1 Retention:** > 60%
**Day 7 Retention:** > 40% (Phase 1), > 60% (Phase 2)
**Day 30 Retention:** > 20% (Phase 1), > 40% (Phase 3)

#### 10.1.3 Conversion Metrics (Phase 3)
**Click-Through Rate (CTR):** > 15% (clicks on "Buy Now")
**Conversion Rate:** > 5% (purchases / swirls)
**Average Order Value (AOV):** > 300 AED
**Gross Merchandise Value (GMV):** > $50K/month

#### 10.1.4 Content Metrics
**Weekly Outfit Engagement:**
- Open rate: > 40%
- Like rate: > 30%
- Purchase rate: > 8%

**Search Usage:** > 30% of sessions include search
**Brand Following:** Average 3+ brands followed per user

### 10.2 Analytics Events to Track

#### 10.2.1 Core Events
- `app_open` - App launch
- `session_start` - Session begins
- `session_end` - Session ends (with duration)
- `swipe_right` - Like action
- `swipe_left` - Detail view
- `swipe_up` - Skip
- `swipe_down` - Quick wishlist
- `product_detail_view` - Full detail viewed
- `add_to_swirls` - Item saved to swirls
- `remove_from_swirls` - Item removed
- `add_to_wishlist` - Item wishlisted
- `brand_follow` - Brand followed
- `brand_unfollow` - Brand unfollowed
- `style_filter_toggle` - Filter activated/deactivated
- `search_query` - Search performed
- `search_filter_applied` - Filter used
- `buy_now_click` - External store click
- `weekly_outfit_view` - Outfit viewed
- `weekly_outfit_like` - Outfit liked
- `onboarding_completed` - Quiz finished
- `onboarding_skipped` - Quiz skipped
- `sign_up_completed` - User created account
- `share_item` - Item shared

#### 10.2.2 Technical Events (Silent)
- `feed_preload_success` - Preloading worked
- `feed_preload_failure` - Preloading failed
- `image_load_time` - Image performance
- `api_response_time` - Backend performance
- `app_crash` - App crash
- `low_memory_warning` - Memory pressure

### 10.3 A/B Testing Plan

#### 10.3.1 Initial Tests (Phase 1)
**Test 1: Onboarding Quiz**
- Variant A: Show quiz immediately
- Variant B: Allow skip, prompt after 3 swipes
- Metric: Day 7 retention

**Test 2: Card Stack Depth**
- Variant A: 2 cards visible
- Variant B: 3 cards visible
- Metric: Swipes per session

**Test 3: Haptic Feedback Intensity**
- Variant A: Light impact
- Variant B: Medium impact
- Variant C: No haptics
- Metric: User satisfaction survey

#### 10.3.2 ML Tests (Phase 2)
**Test 4: Recommendation Algorithm**
- Variant A: Rule-based
- Variant B: Content-based ML
- Variant C: Hybrid
- Metric: Like rate, session duration

**Test 5: Weekly Outfit Format**
- Variant A: 1 coordinated outfit + 5 items
- Variant B: 2 coordinated outfits + 3 items
- Metric: Outfit engagement rate

### 10.4 Success Definition

**MVP Success (Phase 1):**
- 1,000+ DAU
- 10 min avg session duration
- 20%+ like rate
- 40%+ Day 7 retention
- 50+ swipes per session

**Product-Market Fit (Phase 2):**
- 5,000+ DAU
- 15 min avg session duration
- 25%+ like rate
- 60%+ Day 7 retention
- Weekly outfit open rate > 40%

**Scale Readiness (Phase 3):**
- 20,000+ DAU
- 15 min avg session duration
- 30%+ like rate
- 40%+ Day 30 retention
- 5%+ conversion rate
- $50K+ monthly GMV

---

## 11. Design System Specifications

### 11.1 Color Palette

#### 11.1.1 Primary Colors
```
Primary Black: #1A1A1A
Primary White: #FFFFFF
Accent Coral (Like): #FF6B6B
Accent Blue (Detail): #4A90E2
Accent Green (Wishlist): #4CAF50
```

#### 11.1.2 Neutral Colors
```
Gray 50: #F9FAFB
Gray 100: #F3F4F6
Gray 200: #E5E7EB
Gray 300: #D1D5DB
Gray 400: #9CA3AF
Gray 500: #6B7280
Gray 600: #4B5563
Gray 700: #374151
Gray 800: #1F2937
Gray 900: #111827
```

#### 11.1.3 Semantic Colors
```
Success: #10B981
Warning: #F59E0B
Error: #EF4444
Info: #3B82F6
```

### 11.2 Typography

#### 11.2.1 Font Family
**Primary:** Inter (Variable)

#### 11.2.2 Type Scale
```dart
Heading 1: 32px, Bold, -0.5 letter spacing
Heading 2: 24px, SemiBold, -0.3 letter spacing
Heading 3: 20px, SemiBold, -0.2 letter spacing
Body Large: 18px, Regular, 0 letter spacing
Body: 16px, Regular, 0 letter spacing
Body Small: 14px, Regular, 0 letter spacing
Caption: 12px, Regular, 0 letter spacing

Card Title: 18px, SemiBold, -0.2 letter spacing
Brand Name: 14px, Regular, 0 letter spacing
Price: 20px, Bold, 0 letter spacing
Button: 16px, SemiBold, 0 letter spacing
```

### 11.3 Spacing System
```
Space 0: 0px
Space 1: 4px
Space 2: 8px
Space 3: 12px
Space 4: 16px
Space 5: 20px
Space 6: 24px
Space 7: 28px
Space 8: 32px
Space 10: 40px
Space 12: 48px
Space 16: 64px
Space 20: 80px
```

### 11.4 Border Radius
```
Rounded SM: 8px (chips, small buttons)
Rounded MD: 12px (input fields)
Rounded LG: 16px (buttons, cards)
Rounded XL: 24px (product cards)
Rounded 2XL: 32px (modals, bottom sheets)
Rounded Full: 9999px (circular elements)
```

### 11.5 Shadows
```dart
Shadow SM:
  offset: (0, 1)
  blur: 2px
  color: rgba(0,0,0,0.05)

Shadow MD:
  offset: (0, 4)
  blur: 6px
  color: rgba(0,0,0,0.07)

Shadow LG:
  offset: (0, 10)
  blur: 15px
  color: rgba(0,0,0,0.1)

Shadow XL:
  offset: (0, 20)
  blur: 25px
  color: rgba(0,0,0,0.15)
```

---

## 12. Risk Assessment & Mitigation

### 12.1 Technical Risks

**Risk: Image loading performance**
- **Mitigation:** CDN mirroring, aggressive preloading, thumbnail generation, progressive loading

**Risk: Feed lag with heavy usage**
- **Mitigation:** Implement pagination, virtual scrolling, dispose old cards, optimize state management

**Risk: ML model accuracy**
- **Mitigation:** Start with rule-based, gradual ML rollout, A/B testing, human-in-the-loop validation

### 12.2 Product Risks

**Risk: Low user engagement (not addictive enough)**
- **Mitigation:** Iterate on swipe mechanics, add surprise elements, gamification, push notifications

**Risk: Low like rate (poor recommendations)**
- **Mitigation:** Better onboarding, diverse seed content, frequent model retraining, user feedback loops

**Risk: User churn after novelty wears off**
- **Mitigation:** Weekly outfit drops, social features, new content regularly, personalization improvements

### 12.3 Business Risks

**Risk: Amazon API access issues**
- **Mitigation:** Mock data for development, explore alternative APIs (Noon, Namshi), scraping as fallback

**Risk: Low conversion rate (users don't buy)**
- **Mitigation:** Phase 1 focuses on discovery, not purchases; optimize buy flow in Phase 3

**Risk: Brand partnerships difficult**
- **Mitigation:** Prove value with analytics first, offer free exposure, build brand dashboard

---

## Appendix A: Glossary

**Swirl:** User action of liking/saving a product (right swipe or down swipe)

**Swirls Count:** Total number of items a user has liked

**Style Tags:** Classification labels (minimalist, urban_vibe, streetwear_edge, avant_garde)

**Soft Priority:** Increasing ranking score without hard filtering

**Dwell Time:** Time spent viewing a card before swiping

**Card Position:** Index of item in feed (0 = first card shown)

**Cold Start:** Challenge of providing recommendations for new users with no history

**Weekly Drop:** Personalized outfit recommendations delivered every Monday

**Coordinated Outfit:** Complete look with matching top, bottom, and shoes

**Session:** Single app usage period from open to close

---

## Appendix B: Future Considerations

### B.1 Potential Features (Post-Phase 3)
- AR virtual try-on
- Video product demos
- Live shopping events
- Stylist consultations
- Size recommendation AI
- Outfit remix tool
- Fashion challenges/contests
- Loyalty program
- Referral rewards

### B.2 Regional Expansion
- Adapt to local preferences (Saudi, Kuwait, Qatar)
- Currency localization
- Language support (Arabic UI)
- Local payment methods
- Regional brand partnerships

### B.3 Platform Expansion
- Web app (desktop discovery)
- Browser extension (shop any site)
- WhatsApp bot (outfit suggestions)
- Instagram/TikTok integration

---

**Document Status:** Ready for Implementation
**Next Step:** Architecture alignment and database schema creation
**Owner:** Development Team
**Reviewers:** Product, Engineering, Design
