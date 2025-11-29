#!/bin/bash

# SWIRL App - Deployment Verification Script
# This script verifies that all prerequisites are met before deployment

echo "=========================================="
echo "SWIRL App - Deployment Verification"
echo "=========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

# Function to check status
check_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $2"
        ((PASS++))
    else
        echo -e "${RED}✗ FAIL${NC}: $2"
        ((FAIL++))
    fi
}

echo "1. Checking Flutter installation..."
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    check_status 0 "Flutter installed: $FLUTTER_VERSION"
else
    check_status 1 "Flutter not found. Please install Flutter."
fi
echo ""

echo "2. Checking project structure..."
if [ -f "pubspec.yaml" ]; then
    check_status 0 "pubspec.yaml exists"
else
    check_status 1 "pubspec.yaml not found"
fi

if [ -f "lib/main.dart" ]; then
    check_status 0 "lib/main.dart exists"
else
    check_status 1 "lib/main.dart not found"
fi
echo ""

echo "3. Checking environment configuration..."
if [ -f ".env" ]; then
    check_status 0 ".env file exists"
    
    if grep -q "SUPABASE_URL" .env; then
        check_status 0 "SUPABASE_URL configured"
    else
        check_status 1 "SUPABASE_URL not found in .env"
    fi
    
    if grep -q "SUPABASE_ANON_KEY" .env; then
        check_status 0 "SUPABASE_ANON_KEY configured"
    else
        check_status 1 "SUPABASE_ANON_KEY not found in .env"
    fi
else
    check_status 1 ".env file not found"
fi
echo ""

echo "4. Checking critical files..."
CRITICAL_FILES=(
    "lib/data/models/wishlist_item.dart"
    "lib/data/models/cart_item.dart"
    "lib/data/models/brand.dart"
    "lib/features/wishlist/providers/wishlist_provider.dart"
    "lib/core/utils/error_handler.dart"
    "supabase_rpc_functions.sql"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        check_status 0 "$file exists"
    else
        check_status 1 "$file not found"
    fi
done
echo ""

echo "5. Checking documentation..."
DOCS=(
    "README.md"
    "DEPLOYMENT_READY_SUMMARY.md"
    "BUG_FIX_REPORT.md"
    "TESTING_CHECKLIST.md"
)

for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        check_status 0 "$doc exists"
    else
        check_status 1 "$doc not found"
    fi
done
echo ""

echo "6. Running Flutter doctor..."
flutter doctor > /dev/null 2>&1
if [ $? -eq 0 ]; then
    check_status 0 "Flutter doctor completed successfully"
else
    echo -e "${YELLOW}⚠ WARNING${NC}: Flutter doctor found issues. Run 'flutter doctor' for details."
fi
echo ""

echo "7. Checking dependencies..."
if flutter pub get > /dev/null 2>&1; then
    check_status 0 "Dependencies installed successfully"
else
    check_status 1 "Failed to install dependencies"
fi
echo ""

echo "8. Running static analysis..."
if flutter analyze > /dev/null 2>&1; then
    check_status 0 "No static analysis errors"
else
    echo -e "${YELLOW}⚠ WARNING${NC}: Static analysis found issues. Run 'flutter analyze' for details."
fi
echo ""

echo "=========================================="
echo "VERIFICATION SUMMARY"
echo "=========================================="
echo -e "Passed: ${GREEN}$PASS${NC}"
echo -e "Failed: ${RED}$FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ ALL CHECKS PASSED!${NC}"
    echo "Your app is ready for deployment."
    echo ""
    echo "Next steps:"
    echo "1. Follow TESTING_CHECKLIST.md for manual testing"
    echo "2. Review DEPLOYMENT_READY_SUMMARY.md for deployment steps"
    echo "3. Run: flutter run --release"
    echo ""
    exit 0
else
    echo -e "${RED}✗ SOME CHECKS FAILED${NC}"
    echo "Please fix the issues above before deploying."
    echo ""
    exit 1
fi