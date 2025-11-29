@echo off
REM Swirl - Optimized Production Build Script (Windows)
REM This script creates highly optimized builds with maximum performance

setlocal enabledelayedexpansion

echo.
echo ==============================================
echo    SWIRL - Optimized Production Build
echo ==============================================
echo.

REM Build configurations
set BUILD_NAME=1.0.0
set BUILD_NUMBER=1

echo [Step 1] Analyzing current bundle size...
flutter build apk --analyze-size --target-platform android-arm64

echo.
echo [Step 2] Cleaning previous builds...
flutter clean
flutter pub get

echo.
echo [Step 3] Building optimized Android APK...
flutter build apk ^
  --release ^
  --obfuscate ^
  --split-debug-info=build/app/outputs/symbols ^
  --tree-shake-icons ^
  --target-platform android-arm64 ^
  --build-name=%BUILD_NAME% ^
  --build-number=%BUILD_NUMBER% ^
  --dart-define=ENVIRONMENT=production

if errorlevel 1 (
    echo ERROR: Android APK build failed!
    exit /b 1
)

echo.
echo [Step 4] Building optimized Android App Bundle...
flutter build appbundle ^
  --release ^
  --obfuscate ^
  --split-debug-info=build/app/outputs/symbols-bundle ^
  --tree-shake-icons ^
  --build-name=%BUILD_NAME% ^
  --build-number=%BUILD_NUMBER% ^
  --dart-define=ENVIRONMENT=production

if errorlevel 1 (
    echo ERROR: Android App Bundle build failed!
    exit /b 1
)

echo.
echo [Step 5] Building optimized Web app...
flutter build web ^
  --release ^
  --web-renderer canvaskit ^
  --pwa-strategy offline-first ^
  --base-href / ^
  --dart-define=ENVIRONMENT=production

if errorlevel 1 (
    echo ERROR: Web build failed!
    exit /b 1
)

echo.
echo ==============================================
echo    BUILD COMPLETED SUCCESSFULLY!
echo ==============================================
echo.
echo Build Artifacts:
echo   • Android APK: build\app\outputs\flutter-apk\app-release.apk
echo   • Android Bundle: build\app\outputs\bundle\release\app-release.aab
echo   • Web: build\web\
echo.
echo Debug Symbols:
echo   • Android APK: build\app\outputs\symbols\
echo   • Android Bundle: build\app\outputs\symbols-bundle\
echo.
echo Next Steps:
echo   1. Test the release builds on physical devices
echo   2. Upload symbols to crash reporting service
echo   3. Run performance profiling on release build
echo   4. Submit to app stores
echo.

pause