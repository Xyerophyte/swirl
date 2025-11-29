#!/bin/bash

echo "========================================"
echo " Swirl App - Deploy Optimizations"
echo "========================================"
echo ""

echo "Step 1: Backing up current configuration..."
if [ -f "analysis_options.yaml" ]; then
    cp analysis_options.yaml analysis_options.yaml.backup
    echo "  [OK] Backed up analysis_options.yaml"
else
    echo "  [INFO] No existing analysis_options.yaml found"
fi

echo ""
echo "Step 2: Deploying optimized analysis options..."
cp analysis_options_optimized.yaml analysis_options.yaml
if [ $? -eq 0 ]; then
    echo "  [OK] Deployed optimized analysis options"
else
    echo "  [ERROR] Failed to deploy analysis options"
    exit 1
fi

echo ""
echo "Step 3: Running Flutter analyze..."
flutter analyze
if [ $? -ne 0 ]; then
    echo "  [WARNING] Some analysis warnings detected - review and fix"
fi

echo ""
echo "Step 4: Cleaning build cache..."
flutter clean > /dev/null 2>&1
echo "  [OK] Cleaned build cache"

echo ""
echo "========================================"
echo " Deployment Complete!"
echo "========================================"
echo ""
echo "Next Steps:"
echo "  1. Review database_advanced_optimizations.sql"
echo "  2. Run SQL in Supabase SQL Editor"
echo "  3. Test optimized build: ./build_optimized.sh"
echo "  4. Replace image widgets with OptimizedImage"
echo "  5. Enable performance monitoring in main.dart"
echo ""
echo "Documentation:"
echo "  - OPTIMIZATION_GUIDE.md"
echo "  - OPTIMIZATION_IMPLEMENTATION_SUMMARY.md"
echo ""