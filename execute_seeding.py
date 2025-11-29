#!/usr/bin/env python3
"""
Luxury Fashion Database Seeding Execution Script
Executes SQL files via Supabase to insert 220 luxury products
"""

import os
import re
from pathlib import Path

# SQL files to execute in order
SQL_FILES = [
    'luxury_fashion_seed.sql',
    'luxury_fashion_seed_part2.sql', 
    'luxury_fashion_seed_part3.sql',
    'luxury_fashion_final_120_products.sql',
    'luxury_fashion_final_part4.sql'
]

def extract_product_inserts(sql_file_path):
    """
    Extract only the product INSERT statements from SQL file.
    Skips brand setup and returns clean INSERT queries.
    """
    with open(sql_file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find the INSERT INTO products statement
    pattern = r'INSERT INTO products\s*\([^)]+\)\s*VALUES\s*(.*?);'
    match = re.search(pattern, content, re.DOTALL | re.IGNORECASE)
    
    if match:
        values_section = match.group(1)
        # Split by product entries (looking for UUIDs at start of line)
        products = re.split(r'\n\s*\(\'p[0-9a-f-]+\'', values_section)
        return products
    return []

def create_batch_insert(products_batch, start_idx=0):
    """Create a single INSERT statement for a batch of products"""
    if not products_batch:
        return None
    
    insert_header = """INSERT INTO products (
  id, external_id, source_store, source_url, name, brand, description,
  price, original_price, currency, discount_percentage, category, subcategory,
  style_tags, sizes, colors, materials, care_instructions,
  primary_image_url, rating, review_count, is_trending, is_new_arrival,
  is_flash_sale, is_in_stock, stock_count
)
VALUES\n"""
    
    # Add back the UUID prefix to each product (except first which already has it in original)
    formatted_products = []
    for i, product in enumerate(products_batch):
        if i == 0:
            formatted_products.append(product)
        else:
            # Re-add the UUID prefix that was used as delimiter
            formatted_products.append("('p" + product)
    
    values = ',\n'.join(formatted_products)
    return insert_header + values + ';'

def main():
    """Main execution function"""
    print("🚀 Luxury Fashion Database Seeding")
    print("=" * 50)
    
    script_dir = Path(__file__).parent
    total_products = 0
    
    for sql_file in SQL_FILES:
        file_path = script_dir / sql_file
        if not file_path.exists():
            print(f"⚠️  File not found: {sql_file}")
            continue
        
        print(f"\n📄 Processing: {sql_file}")
        products = extract_product_inserts(file_path)
        
        if products:
            print(f"   Found {len(products)} products")
            total_products += len(products)
            
            # Create batches of 10 products each for MCP execution
            batch_size = 10
            for i in range(0, len(products), batch_size):
                batch = products[i:i+batch_size]
                batch_num = (i // batch_size) + 1
                print(f"   - Batch {batch_num}: {len(batch)} products")
                
                # Here you would execute via MCP
                # For now, we'll save to separate files
                batch_file = script_dir / f"batch_{sql_file.replace('.sql', '')}_batch{batch_num}.sql"
                insert_sql = create_batch_insert(batch, i)
                if insert_sql:
                    with open(batch_file, 'w', encoding='utf-8') as f:
                        f.write("BEGIN;\n\n")
                        f.write(insert_sql)
                        f.write("\n\nCOMMIT;")
        else:
            print(f"   ⚠️  No products found")
    
    print(f"\n✅ Total products to insert: {total_products}")
    print("\n📋 Next steps:")
    print("1. Review generated batch files")
    print("2. Execute each batch via Supabase MCP execute_sql tool")
    print("3. Verify with: SELECT COUNT(*) FROM products;")
    
    return total_products

if __name__ == "__main__":
    try:
        count = main()
        print(f"\n🎉 Processing complete! Ready to insert {count} products.")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()