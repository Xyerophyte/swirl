# Product Insertion Execution Guide

## Current Status
✅ **10 Brands Successfully Inserted** via Supabase MCP
🔄 **220 Products Ready for Insertion**

## Quick Execution Methods

### Method 1: Direct Supabase Dashboard (RECOMMENDED - Fastest)

1. **Open Supabase Dashboard**
   - Go to: https://supabase.com/dashboard/project/tklqhbszwfqjmlzjczoz
   - Navigate to: SQL Editor

2. **Execute Each File in Order:**

#### File 1: luxury_fashion_seed.sql
- Copy lines 116-473 (INSERT INTO products... through end of Hermès/LV products)
- Paste into SQL Editor
- Click "Run"
- Expected: 40 products inserted

#### File 2: luxury_fashion_seed_part2.sql  
- Copy entire INSERT statement
- Paste and Run
- Expected: 40 products inserted (Total: 80)

#### File 3: luxury_fashion_seed_part3.sql
- Copy entire INSERT statement  
- Paste and Run
- Expected: 40 products inserted (Total: 120)

#### File 4: luxury_fashion_final_120_products.sql
- Copy entire INSERT statement
- Paste and Run  
- Expected: 60 products inserted (Total: 180)

#### File 5: luxury_fashion_final_part4.sql
- Copy entire INSERT statement
- Paste and Run
- Expected: 40 products inserted (Total: 220)

3. **Verify After Each File:**
```sql
SELECT COUNT(*) FROM products;
```

### Method 2: Using psql CLI

If you have direct database access:

```bash
cd swirl

# Execute all files
psql "postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-us-east-1.pooler.supabase.com:6543/postgres" \
  -f luxury_fashion_seed.sql \
  -f luxury_fashion_seed_part2.sql \
  -f luxury_fashion_seed_part3.sql \
  -f luxury_fashion_final_120_products.sql \
  -f luxury_fashion_final_part4.sql

# Verify
psql $DATABASE_URL -c "SELECT COUNT(*) FROM products;"
```

### Method 3: Via Supabase MCP (Current Approach)

Due to query size limitations, products need to be inserted in smaller batches. 

**Option A: Manual Batch Execution**
Read each SQL file and execute INSERT statements in batches of 10-20 products via the `execute_sql` MCP tool.

**Option B: Use run_sql_transaction tool**
The Supabase MCP has a `run_sql_transaction` tool that can handle multiple statements. This might work better for larger inserts.

## Verification Queries

After complete insertion, run these to verify:

```sql
-- Total count (should be 220)
SELECT COUNT(*) as total_products FROM products;

-- By brand
SELECT 
  brand,
  COUNT(*) as count
FROM products  
GROUP BY brand
ORDER BY brand;

-- Expected Results:
-- Balenciaga: 20
-- Bottega Veneta: 20  
-- Burberry: 30
-- Chanel: 20
-- Dior: 20
-- Gucci: 20
-- Hermès: 20
-- Louis Vuitton: 20
-- Prada: 20
-- Saint Laurent: 30

-- Verify images
SELECT 
  COUNT(*) as products_with_images 
FROM products 
WHERE primary_image_url IS NOT NULL;
-- Should return: 220

-- Price range check
SELECT 
  MIN(price) as min_price,
  MAX(price) as max_price,
  AVG(price)::NUMERIC(10,2) as avg_price
FROM products;
-- Expected: min ~950, max ~45000, avg ~8000-10000

-- Category distribution  
SELECT 
  category,
  COUNT(*) as count
FROM products
GROUP BY category
ORDER BY count DESC;

-- Sample products
SELECT 
  brand,
  name,
  price,
  category
FROM products
ORDER BY brand, price DESC
LIMIT 20;
```

## What to Do If Errors Occur

### "Duplicate key value violates unique constraint"
- Some products may already exist
- Either skip that batch or delete existing: `DELETE FROM products WHERE id = 'specific-id';`

### "Foreign key violation"  
- Ensure brands were inserted first
- Verify brand names match exactly (case-sensitive)

### "Query too large"
- Split into smaller batches
- Use Supabase Dashboard instead of MCP

### Images not loading in app
- Verify Unsplash URLs are accessible
- Check network connectivity
- Implement error handling in Flutter app

## Post-Insertion Steps

1. **Update Brand Product Counts:**
```sql
UPDATE brands b
SET total_products = (
  SELECT COUNT(*) 
  FROM products p 
  WHERE p.brand = b.name
);
```

2. **Update Brand Average Prices:**
```sql
UPDATE brands b
SET avg_price = (
  SELECT AVG(price)::NUMERIC(10,2)
  FROM products p
  WHERE p.brand = b.name  
);
```

3. **Test in Flutter App:**
```dart
// Fetch products
final products = await supabase
    .from('products')
    .select()
    .limit(20);

print('Loaded ${products.length} products');
```

## Success Criteria

✅ 220 total products inserted
✅ All 10 brands have products
✅ All products have images
✅ Price range: 950-45,000 AED
✅ Multiple categories represented
✅ All products in stock

## Timeline Estimate

- **Supabase Dashboard**: 10-15 minutes (copy/paste 5 files)
- **psql CLI**: 2-3 minutes (if database URL available)
- **MCP Batches**: 30-45 minutes (manual batch execution)

**Recommended**: Use Supabase Dashboard for fastest execution!