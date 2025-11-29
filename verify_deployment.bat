@echo off
REM SWIRL App - Deployment Verification Script (Windows)
REM This script verifies that all prerequisites are met before deployment

echo ==========================================
echo SWIRL App - Deployment Verification
echo ==========================================
echo.

set PASS=0
set FAIL=0

echo 1. Checking Flutter installation...
flutter --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] Flutter is installed
    set /a PASS+=1
) else (
    echo [FAIL] Flutter not found. Please install Flutter.
    set /a FAIL+=1
)
echo.

echo 2. Checking project structure...
if exist "pubspec.yaml" (
    echo [PASS] pubspec.yaml exists
    set /a PASS+=1
) else (
    echo [FAIL] pubspec.yaml not found
    set /a FAIL+=1
)

if exist "lib\main.dart" (
    echo [PASS] lib\main.dart exists
    set /a PASS+=1
) else (
    echo [FAIL] lib\main.dart not found
    set /a FAIL+=1
)
echo.

echo 3. Checking environment configuration...
if exist ".env" (
    echo [PASS] .env file exists
    set /a PASS+=1
    
    findstr /C:"SUPABASE_URL" .env >nul 2>&1
    if %errorlevel% equ 0 (
        echo [PASS] SUPABASE_URL configured
        set /a PASS+=1
    ) else (
        echo [FAIL] SUPABASE_URL not found in .env
        set /a FAIL+=1
    )
    
    findstr /C:"SUPABASE_ANON_KEY" .env >nul 2>&1
    if %errorlevel% equ 0 (
        echo [PASS] SUPABASE_ANON_KEY configured
        set /a PASS+=1
    ) else (
        echo [FAIL] SUPABASE_ANON_KEY not found in .env
        set /a FAIL+=1
    )
) else (
    echo [FAIL] .env file not found
    set /a FAIL+=1
)
echo.

echo 4. Checking critical files...
if exist "lib\data\models\wishlist_item.dart" (
    echo [PASS] wishlist_item.dart exists
    set /a PASS+=1
) else (
    echo [FAIL] wishlist_item.dart not found
    set /a FAIL+=1
)

if exist "lib\data\models\cart_item.dart" (
    echo [PASS] cart_item.dart exists
    set /a PASS+=1
) else (
    echo [FAIL] cart_item.dart not found
    set /a FAIL+=1
)

if exist "lib\data\models\brand.dart" (
    echo [PASS] brand.dart exists
    set /a PASS+=1
) else (
    echo [FAIL] brand.dart not found
    set /a FAIL+=1
)

if exist "lib\features\wishlist\providers\wishlist_provider.dart" (
    echo [PASS] wishlist_provider.dart exists
    set /a PASS+=1
) else (
    echo [FAIL] wishlist_provider.dart not found
    set /a FAIL+=1
)

if exist "lib\core\utils\error_handler.dart" (
    echo [PASS] error_handler.dart exists
    set /a PASS+=1
) else (
    echo [FAIL] error_handler.dart not found
    set /a FAIL+=1
)

if exist "supabase_rpc_functions.sql" (
    echo [PASS] supabase_rpc_functions.sql exists
    set /a PASS+=1
) else (
    echo [FAIL] supabase_rpc_functions.sql not found
    set /a FAIL+=1
)
echo.

echo 5. Checking documentation...
if exist "README.md" (
    echo [PASS] README.md exists
    set /a PASS+=1
) else (
    echo [FAIL] README.md not found
    set /a FAIL+=1
)

if exist "DEPLOYMENT_READY_SUMMARY.md" (
    echo [PASS] DEPLOYMENT_READY_SUMMARY.md exists
    set /a PASS+=1
) else (
    echo [FAIL] DEPLOYMENT_READY_SUMMARY.md not found
    set /a FAIL+=1
)

if exist "BUG_FIX_REPORT.md" (
    echo [PASS] BUG_FIX_REPORT.md exists
    set /a PASS+=1
) else (
    echo [FAIL] BUG_FIX_REPORT.md not found
    set /a FAIL+=1
)

if exist "TESTING_CHECKLIST.md" (
    echo [PASS] TESTING_CHECKLIST.md exists
    set /a PASS+=1
) else (
    echo [FAIL] TESTING_CHECKLIST.md not found
    set /a FAIL+=1
)
echo.

echo 6. Checking dependencies...
echo Installing dependencies...
flutter pub get >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] Dependencies installed successfully
    set /a PASS+=1
) else (
    echo [FAIL] Failed to install dependencies
    set /a FAIL+=1
)
echo.

echo ==========================================
echo VERIFICATION SUMMARY
echo ==========================================
echo Passed: %PASS%
echo Failed: %FAIL%
echo.

if %FAIL% equ 0 (
    echo [SUCCESS] ALL CHECKS PASSED!
    echo Your app is ready for deployment.
    echo.
    echo Next steps:
    echo 1. Follow TESTING_CHECKLIST.md for manual testing
    echo 2. Review DEPLOYMENT_READY_SUMMARY.md for deployment steps
    echo 3. Run: flutter run --release
    echo.
    exit /b 0
) else (
    echo [ERROR] SOME CHECKS FAILED
    echo Please fix the issues above before deploying.
    echo.
    exit /b 1
)