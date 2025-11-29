#!/bin/bash
# Swirl - Optimized Production Build Script
# This script creates highly optimized builds with maximum performance

set -e

echo "🚀 Starting Optimized Build Process for Swirl..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Build configurations
BUILD_NAME="1.0.0"
BUILD_NUMBER="1"

echo -e "${BLUE}📊 Step 1: Analyzing current bundle size...${NC}"
flutter build apk --analyze-size --target-platform android-arm64 || true

echo ""
echo -e "${BLUE}🧹 Step 2: Cleaning previous builds...${NC}"
flutter clean
flutter pub get

echo ""
echo -e "${BLUE}📦 Step 3: Building optimized Android APK...${NC}"
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --tree-shake-icons \
  --target-platform android-arm64 \
  --build-name=$BUILD_NAME \
  --build-number=$BUILD_NUMBER \
  --dart-define=ENVIRONMENT=production

echo ""
echo -e "${BLUE}📦 Step 4: Building optimized Android App Bundle...${NC}"
flutter build appbundle \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols-bundle \
  --tree-shake-icons \
  --build-name=$BUILD_NAME \
  --build-number=$BUILD_NUMBER \
  --dart-define=ENVIRONMENT=production

echo ""
echo -e "${BLUE}📱 Step 5: Building iOS (if on macOS)...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
  flutter build ios \
    --release \
    --obfuscate \
    --split-debug-info=build/ios/symbols \
    --tree-shake-icons \
    --build-name=$BUILD_NAME \
    --build-number=$BUILD_NUMBER \
    --dart-define=ENVIRONMENT=production
  echo -e "${GREEN}✅ iOS build complete${NC}"
else
  echo -e "${YELLOW}⚠️  Skipping iOS build (not on macOS)${NC}"
fi

echo ""
echo -e "${BLUE}🌐 Step 6: Building optimized Web app...${NC}"
flutter build web \
  --release \
  --web-renderer canvaskit \
  --pwa-strategy offline-first \
  --base-href / \
  --dart-define=ENVIRONMENT=production

echo ""
echo -e "${GREEN}✅ All builds completed successfully!${NC}"
echo ""
echo "📊 Build Artifacts:"
echo "  • Android APK: build/app/outputs/flutter-apk/app-release.apk"
echo "  • Android Bundle: build/app/outputs/bundle/release/app-release.aab"
echo "  • iOS: build/ios/iphoneos/Runner.app"
echo "  • Web: build/web/"
echo ""
echo "🔍 Debug Symbols:"
echo "  • Android APK: build/app/outputs/symbols/"
echo "  • Android Bundle: build/app/outputs/symbols-bundle/"
echo "  • iOS: build/ios/symbols/"
echo ""
echo -e "${BLUE}💡 Next Steps:${NC}"
echo "  1. Test the release builds on physical devices"
echo "  2. Upload symbols to crash reporting service"
echo "  3. Run performance profiling on release build"
echo "  4. Submit to app stores"