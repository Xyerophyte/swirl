# Database Setup Instructions

You have **TWO options** to populate your Supabase database with mock data:

## Option 1: SQL Script (Recommended - Fastest)

1. **Open Supabase Dashboard**
   - Go to https://supabase.com/dashboard
   - Select your project

2. **Navigate to SQL Editor**
   - Click "SQL Editor" in the left sidebar
   - Click "New query"

3. **Run the Schema (if not done yet)**
   - Copy contents of `supabase_schema.sql`
   - Paste into SQL Editor
   - Click "Run" (or Ctrl/Cmd + Enter)
   - Wait for "Success. No rows returned"

4. **Run the Mock Data Script**
   - Copy contents of `supabase_mock_data.sql`
   - Paste into SQL Editor
   - Click "Run" (or Ctrl/Cmd + Enter)
   - You should see: "Mock data inserted successfully!"

5. **Verify Data**
   - Go to "Table Editor" in left sidebar
   - Select "products" table
   - You should see 5 products

---

## Option 2: Dart Script (Programmatic)

This option runs the data population from Dart code.

1. **Ensure .env is configured**
   ```env
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

2. **Run the Dart script**
   ```bash
   cd swirl
   dart run lib/data/scripts/populate_mock_data.dart
   ```

3. **Expected output:**
   ```
   🚀 Starting SWIRL mock data population...
   ✅ Connected to Supabase
   📦 Inserting brands...
     ✓ Amazon Essentials
     ✓ Supreme Basics
     ✓ ZARA Couture
     ✓ Uniqlo
     ✓ Nike
   ✅ Brands inserted
   👕 Inserting products...
     ✓ Men's Slim Fit Oxford Shirt - Long Sleeve
     ✓ Oversized Graphic Hoodie - Streetwear
     ✓ Avant-Garde Asymmetric Blazer
     ✓ Minimalist Crew Neck T-Shirt - Pack of 3
     ✓ Retro High-Top Sneakers
   ✅ Products inserted
   🔍 Verifying data...
   ✅ Found 5 products in database
   🎉 Mock data population complete!
   ```

---

## Verification

After running either option, verify your setup:

1. **Check products count:**
   ```sql
   SELECT COUNT(*) FROM products;
   ```
   Expected: 5

2. **View all products:**
   ```sql
   SELECT name, brand, price, category FROM products;
   ```

3. **Check brands:**
   ```sql
   SELECT name FROM brands;
   ```
   Expected: 5 brands

---

## Mock Data Summary

Your database now contains:

**5 Products:**
1. Men's Slim Fit Oxford Shirt (Amazon Essentials) - 89 AED
2. Oversized Graphic Hoodie (Supreme Basics) - 245 AED
3. Avant-Garde Asymmetric Blazer (ZARA Couture) - 899 AED
4. Minimalist Crew Neck T-Shirt Pack (Uniqlo) - 119 AED
5. Retro High-Top Sneakers (Nike) - 349 AED

**5 Brands:**
- Amazon Essentials (minimalist, urban_vibe)
- Supreme Basics (streetwear_edge, urban_vibe)
- ZARA Couture (avant_garde)
- Uniqlo (minimalist)
- Nike (streetwear_edge, urban_vibe)

---

## Troubleshooting

### "Permission denied" or RLS errors
- Make sure you're using the **anon key**, not service_role key
- Check RLS policies in Supabase Dashboard > Authentication > Policies

### Products not showing in app
1. Verify products exist in Supabase Table Editor
2. Check .env file has correct credentials
3. Restart the app: `flutter run`

### Duplicate key errors
- Data already exists! This is normal on subsequent runs
- Script uses `ON CONFLICT DO NOTHING` to safely skip duplicates

---

## Next Steps

Once your database is populated:

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Test the features:**
   - Swipe right to like products
   - Swipe left to see product details
   - Swipe up to skip
   - Swipe down to add to wishlist

3. **Check data is being tracked:**
   - Go to Supabase Table Editor
   - Check "swipes" table for tracked swipes
   - Check "swirls" table for liked items

---

Ready to SWIRL! 🎨✨
