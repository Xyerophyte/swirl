# SWIRL - Supabase Setup Guide

Complete guide to set up your Supabase backend for the SWIRL app.

**Estimated Time:** 20-30 minutes

---

## Prerequisites

- Supabase account (free tier is fine for development)
- SWIRL Flutter app repository
- Basic SQL knowledge (optional, but helpful)

---

## Step 1: Create Supabase Project (5 minutes)

### 1.1 Sign up for Supabase

1. Go to [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Sign up or log in with GitHub/Google
3. Accept the terms and complete onboarding

### 1.2 Create New Project

1. Click **"New Project"**
2. Fill in project details:
   - **Name:** `swirl-dev` (or your preferred name)
   - **Database Password:** Create a strong password (save it somewhere safe!)
   - **Region:** Choose closest to UAE (e.g., `ap-southeast-1` Singapore)
   - **Pricing Plan:** Free (sufficient for development)
3. Click **"Create new project"**
4. Wait 2-3 minutes for provisioning

---

## Step 2: Get Your API Credentials (2 minutes)

### 2.1 Find Project Settings

1. Once your project is ready, click on **"Settings"** (gear icon in left sidebar)
2. Navigate to **"API"** section

### 2.2 Copy Required Values

You'll need two values:

**Project URL:**
```
https://xxxxxxxxxx.supabase.co
```

**Anon/Public Key (anon key):**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**IMPORTANT:** Copy the `anon` key, NOT the `service_role` key!

### 2.3 Update .env File

1. Open `swirl/.env` in your project
2. Update with your credentials:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

3. Save the file

---

## Step 3: Run Database Schema (10 minutes)

### 3.1 Open SQL Editor

1. In Supabase Dashboard, go to **"SQL Editor"** (left sidebar)
2. Click **"New query"**

### 3.2 Copy Schema SQL

1. Open `supabase_schema.sql` in your SWIRL project root
2. Copy the entire contents (600+ lines)

### 3.3 Execute Schema

1. Paste the SQL into the SQL Editor
2. Click **"Run"** (or press `Ctrl+Enter` / `Cmd+Enter`)
3. Wait for execution (10-15 seconds)

You should see:
```
Success. No rows returned
```

### 3.4 Verify Tables Created

1. Go to **"Table Editor"** (left sidebar)
2. You should see 10 tables:
   - `users`
   - `products`
   - `swipes`
   - `brands`
   - `brand_follows`
   - `swirls`
   - `wishlist_items`
   - `carts`
   - `cart_items`
   - `weekly_outfits`

---

## Step 4: Load Mock Data (10 minutes)

### Option A: Manual Insert (Quick for Testing)

#### 4.1 Insert Test User

1. Go to **Table Editor** → `users` table
2. Click **"Insert row"**
3. Fill in:
   ```
   id: [auto-generated UUID]
   anonymous_id: test-user-001
   is_anonymous: true
   gender_preference: both
   style_preferences: ["minimalist", "urban_vibe"]
   created_at: [auto-generated]
   ```
4. Click **"Save"**

#### 4.2 Insert Test Products

1. Go to **Table Editor** → `products` table
2. For each product in `assets/mock_data/products.json`:
   - Click **"Insert row"**
   - Copy values from JSON
   - Important fields:
     - `external_id`: Product ASIN
     - `source_store`: "amazon"
     - `name`, `brand`, `price`, `currency`
     - `style_tags`: Array like `["minimalist", "urban_vibe"]`
     - `image_url`: Full image URL
     - `is_in_stock`: true
3. Repeat for all 5 products

### Option B: SQL Insert Script (Recommended)

Create a file `load_mock_data.sql`:

```sql
-- Insert test user
INSERT INTO users (
  anonymous_id,
  is_anonymous,
  gender_preference,
  style_preferences,
  price_tier
) VALUES (
  'test-user-001',
  true,
  'both',
  ARRAY['minimalist', 'urban_vibe'],
  'mid_range'
);

-- Insert products
INSERT INTO products (
  external_id,
  source_store,
  source_url,
  name,
  brand,
  description,
  price,
  original_price,
  currency,
  category,
  subcategory,
  style_tags,
  image_url,
  sizes,
  colors,
  rating,
  review_count,
  is_in_stock,
  is_new_arrival
) VALUES
(
  'B07XYZ1001',
  'amazon',
  'https://amazon.ae/dp/B07XYZ1001',
  'Men''s Slim Fit Oxford Shirt',
  'Amazon Essentials',
  'Classic oxford shirt in premium cotton blend. Perfect for both casual and semi-formal occasions.',
  89.00,
  129.00,
  'AED',
  'men',
  'shirts',
  ARRAY['minimalist', 'urban_vibe'],
  'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800',
  ARRAY['S', 'M', 'L', 'XL', 'XXL'],
  ARRAY['White', 'Blue', 'Navy', 'Black'],
  4.5,
  234,
  true,
  true
),
(
  'B08ABC2002',
  'amazon',
  'https://amazon.ae/dp/B08ABC2002',
  'Women''s High-Waisted Wide Leg Trousers',
  'Mango',
  'Elegant wide-leg trousers with high waist. Features side pockets and belt loops.',
  159.00,
  229.00,
  'AED',
  'women',
  'bottoms',
  ARRAY['minimalist', 'avant_garde'],
  'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=800',
  ARRAY['XS', 'S', 'M', 'L', 'XL'],
  ARRAY['Black', 'Beige', 'Navy', 'Olive'],
  4.7,
  456,
  true,
  false
);
-- Add remaining 3 products from products.json
```

Then run this in SQL Editor.

---

## Step 5: Test Connection (5 minutes)

### 5.1 Install Dependencies

```bash
cd swirl
flutter pub get
```

### 5.2 Run the App

```bash
flutter run
```

### 5.3 Verify Connection

You should see:
1. App launches successfully
2. Product cards appear in the feed
3. No error messages in console
4. Images load correctly

If you see errors:
- Check `.env` file has correct URL and key
- Verify tables exist in Supabase Dashboard
- Check console for specific error messages

---

## Step 6: Verify Swipe Tracking (Optional)

### 6.1 Swipe Some Cards

1. Swipe right on a product (Like)
2. Swipe left on a product (Details)
3. Swipe up (Skip)
4. Swipe down (Wishlist)

### 6.2 Check Database

1. Go to Supabase Dashboard → **Table Editor**
2. Check `swipes` table
3. You should see new rows with:
   - `user_id`
   - `product_id`
   - `direction` ('right', 'left', 'up', 'down')
   - `swipe_action` ('like', 'details_view', 'skip', 'wishlist')
   - `dwell_ms` (time spent viewing)
   - `card_position`
   - Timestamp

### 6.3 Check Swirls

1. Check `swirls` table
2. Should have entries for products you liked (swiped right/down)

---

## Troubleshooting

### Error: "Failed to load feed"

**Cause:** Connection issue or empty products table

**Fix:**
1. Verify `.env` credentials are correct
2. Check Supabase Dashboard is accessible
3. Verify products table has data
4. Check console for detailed error message

### Error: "Invalid API key"

**Cause:** Wrong anon key in `.env`

**Fix:**
1. Go to Supabase Dashboard → Settings → API
2. Copy the `anon` key (NOT `service_role`)
3. Update `.env` file
4. Restart app

### Images Not Loading

**Cause:** Invalid image URLs or CORS issues

**Fix:**
1. Verify image URLs in products table are valid
2. Check image URLs work in browser
3. Supabase Storage (future): Upload images to Supabase Storage for better reliability

### No Swipes Recorded

**Cause:** User ID mismatch or repository issue

**Fix:**
1. Check `currentUserIdProvider` in `feed_provider.dart` generates valid UUID
2. Verify user exists in `users` table
3. Check console for swipe tracking errors

---

## Database Schema Overview

### Core Tables

**users**
- Tracks both anonymous and registered users
- Stores preferences, stats, engagement metrics

**products**
- Product catalog from Amazon/other sources
- Includes style tags for personalization

**swipes**
- Comprehensive 13-field tracking
- All swipe data for ML personalization

**swirls**
- "Liked" items (SWIRL's unique metric)
- Tracks source of like (swipe right, wishlist, etc.)

**brands**
- Brand catalog
- Used for brand following feature

**brand_follows**
- User-brand relationships
- Auto-follow after 5 likes

**wishlist_items**
- Saved items with notes
- Price alerts (future)

### Indexes

The schema includes optimized indexes for:
- Fast feed queries (user + style filters)
- Swipe analytics
- User engagement scoring

### Triggers

Auto-increment counters:
- `total_swirls` when swirl added
- `total_swipes` when swipe recorded
- `follower_count` when brand followed

---

## Next Steps

### 1. Expand Mock Data

Add 100-200 more products to `products` table for realistic testing

### 2. Test All Features

- Swipe in all 4 directions
- Open detail view (left swipe)
- Verify tracking in database
- Test preloading (swipe through multiple cards)

### 3. Add More Screens

- Swirls screen (view liked items)
- Wishlist screen
- Search screen
- Profile screen

### 4. Configure Analytics (Optional)

Set up Firebase Analytics for tracking:
- User engagement
- Swipe patterns
- Session duration

---

## Production Considerations

When ready for production:

### Security

1. **Enable Row Level Security (RLS)**
   ```sql
   -- Users can only access their own data
   ALTER TABLE swipes ENABLE ROW LEVEL SECURITY;

   CREATE POLICY "Users can view own swipes"
   ON swipes FOR SELECT
   USING (auth.uid() = user_id);
   ```

2. **Use service role key for server-side operations only**
   - Never expose in client app
   - Only use in secure backend/cron jobs

3. **Set up proper authentication**
   - Supabase Auth with Google/Apple Sign In
   - Anonymous user migration flow

### Performance

1. **Enable CDN for images**
   - Move to Supabase Storage
   - Enable CDN caching

2. **Add database connection pooling**
   - Configure in Supabase settings
   - Optimize for high traffic

3. **Monitor query performance**
   - Use Supabase Dashboard → Database → Query Performance
   - Add indexes as needed

### Backup

1. **Enable automatic backups**
   - Supabase Dashboard → Settings → Database → Backups
   - Set up daily backups

2. **Export data periodically**
   - SQL dumps for critical data
   - Store in secure location

---

## Support

**Supabase Issues:**
- [Supabase Discord](https://discord.supabase.com)
- [Supabase GitHub](https://github.com/supabase/supabase)

**SWIRL Issues:**
- Check `IMPLEMENTATION_COMPLETE.md` for architecture details
- Review `PRD.md` for feature specifications
- See `ARCHITECTURE.md` for technical details

---

## Summary Checklist

- [ ] Created Supabase account and project
- [ ] Copied project URL and anon key
- [ ] Updated `.env` file with credentials
- [ ] Ran `supabase_schema.sql` in SQL Editor
- [ ] Verified all 10 tables created
- [ ] Loaded mock data (5+ products)
- [ ] Created test user
- [ ] Ran `flutter pub get`
- [ ] Launched app successfully
- [ ] Verified products display in feed
- [ ] Tested swipe gestures
- [ ] Verified swipes recorded in database
- [ ] Checked swirls table for liked items

**You're ready to SWIRL! 🎉**

Next session: Add more screens (Swirls, Wishlist, Search) or expand mock data to 200+ products.
