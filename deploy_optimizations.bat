@echo off
echo ========================================
echo  Swirl App - Deploy Optimizations
echo ========================================
echo.

echo Step 1: Backing up current configuration...
if exist analysis_options.yaml (
    copy /Y analysis_options.yaml analysis_options.yaml.backup >nul
    echo   [OK] Backed up analysis_options.yaml
) else (
    echo   [INFO] No existing analysis_options.yaml found
)

echo.
echo Step 2: Deploying optimized analysis options...
copy /Y analysis_options_optimized.yaml analysis_options.yaml >nul
if %errorlevel% equ 0 (
    echo   [OK] Deployed optimized analysis options
) else (
    echo   [ERROR] Failed to deploy analysis options
    exit /b 1
)

echo.
echo Step 3: Running Flutter analyze...
call flutter analyze
if %errorlevel% neq 0 (
    echo   [WARNING] Some analysis warnings detected - review and fix
)

echo.
echo Step 4: Cleaning build cache...
call flutter clean >nul
echo   [OK] Cleaned build cache

echo.
echo ========================================
echo  Deployment Complete!
echo ========================================
echo.
echo Next Steps:
echo   1. Review database_advanced_optimizations.sql
echo   2. Run SQL in Supabase SQL Editor
echo   3. Test optimized build: .\build_optimized.bat
echo   4. Replace image widgets with OptimizedImage
echo   5. Enable performance monitoring in main.dart
echo.
echo Documentation:
echo   - OPTIMIZATION_GUIDE.md
echo   - OPTIMIZATION_IMPLEMENTATION_SUMMARY.md
echo.
pause