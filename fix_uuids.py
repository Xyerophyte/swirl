#!/usr/bin/env python3
"""
UUID Fix Script for Luxury Fashion SQL Files
Replaces invalid UUID strings with gen_random_uuid() function calls
"""

import re
from pathlib import Path

def fix_sql_file(file_path):
    """Fix UUID format in a SQL file"""
    print(f"\nProcessing: {file_path.name}")
    
    try:
        # Read file
        content = file_path.read_text(encoding='utf-8')
        original_size = len(content)
        
        # Pattern to match UUID strings in the format: 'p0000001-0001-0001-0001-000000000001'
        # Note: First part is p + 7 digits (total 8 chars), not p + 8 digits
        uuid_pattern = r"'p[0-9]{7}-[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{12}'"
        
        # Count matches
        matches = re.findall(uuid_pattern, content)
        match_count = len(matches)
        
        if match_count > 0:
            print(f"  Sample match: {matches[0]}")
        
        if match_count == 0:
            print(f"  No UUIDs found to fix")
            return False
        
        print(f"  Found {match_count} UUIDs to replace")
        
        # Replace with gen_random_uuid()
        fixed_content = re.sub(uuid_pattern, 'gen_random_uuid()', content)
        
        # Save to new file with _fixed suffix
        output_path = file_path.parent / file_path.name.replace('.sql', '_fixed.sql')
        output_path.write_text(fixed_content, encoding='utf-8')
        
        new_size = len(fixed_content)
        print(f"  Replaced {match_count} UUIDs with gen_random_uuid()")
        print(f"  Saved to: {output_path.name}")
        print(f"  Size: {original_size:,} -> {new_size:,} bytes")
        
        return True
        
    except Exception as e:
        print(f"  Error: {e}")
        return False

def main():
    """Main execution function"""
    print("=" * 60)
    print("UUID Fix Script for Luxury Fashion Database Seeding")
    print("=" * 60)
    
    # SQL files to process
    sql_files = [
        'luxury_fashion_seed.sql',
        'luxury_fashion_seed_part2.sql',
        'luxury_fashion_seed_part3.sql',
        'luxury_fashion_final_120_products.sql',
        'luxury_fashion_final_part4.sql'
    ]
    
    script_dir = Path(__file__).parent
    fixed_count = 0
    
    for filename in sql_files:
        file_path = script_dir / filename
        
        if not file_path.exists():
            print(f"\nSkipping: {filename} (not found)")
            continue
        
        if fix_sql_file(file_path):
            fixed_count += 1
    
    print("\n" + "=" * 60)
    print(f"Summary: Fixed {fixed_count} out of {len(sql_files)} files")
    print("=" * 60)
    
    if fixed_count > 0:
        print("\nNext Steps:")
        print("1. Review the generated *_fixed.sql files")
        print("2. Execute them via Supabase Dashboard SQL Editor:")
        print("   https://supabase.com/dashboard/project/tklqhbszwfqjmlzjczoz/sql")
        print("3. Or continue using Supabase MCP execute_sql tool")
        print("\nVerify after execution:")
        print("   SELECT COUNT(*) FROM products; -- Should be 220")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nOperation cancelled by user")
    except Exception as e:
        print(f"\nFatal error: {e}")
        import traceback
        traceback.print_exc()