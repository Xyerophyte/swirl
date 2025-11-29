# Font Assets Setup Guide - SWIRL App

**Status**: Required for brand consistency  
**Priority**: Medium (app works with fallback)  
**Estimated Time**: 5 minutes

---

## 📋 OVERVIEW

The SWIRL app is configured to use the **Inter** font family for consistent typography across all screens. Currently, the font files are missing, causing the app to fall back to Google Fonts CDN or system fonts.

**Current Behavior**:
- ✅ App runs without errors
- ✅ Falls back to google_fonts package
- ⚠️ Brand consistency not optimal
- ⚠️ First load may be slower (downloads from CDN)

**After Setup**:
- ✅ Local font files used (faster)
- ✅ Perfect brand consistency
- ✅ No external font downloads needed
- ✅ Offline font support

---

## 🎯 CONFIGURATION

### Current pubspec.yaml Configuration:

```yaml
# pubspec.yaml (lines 75-78)
fonts:
  - family: Inter
    fonts:
      - asset: assets/fonts/inter/Inter-Variable.ttf
```

### Theme Configuration:

The app uses Inter font throughout via `SwirlTypography` in:
- `lib/core/theme/swirl_typography.dart`
- Applied globally in `lib/main.dart`

---

## 📥 SETUP INSTRUCTIONS

### Step 1: Download Inter Font

**Option A: Direct Download (Recommended)**
1. Visit: https://fonts.google.com/specimen/Inter
2. Click "Download family" button
3. Extract the ZIP file

**Option B: Using Google Fonts Helper**
1. Visit: https://gwfh.mranftl.com/fonts/inter
2. Select "Latin" character set
3. Select "Regular 400" weight (or Variable)
4. Download the font files

---

### Step 2: Locate the Font File

After extraction, find the Variable font file:
- Look for: `Inter-VariableFont_*.ttf` or `Inter-Variable.ttf`
- Location: Usually in `static/` or root of extracted folder
- File size: ~500KB

**Note**: We use the Variable font for maximum flexibility. It contains all font weights (100-900) in a single file.

---

### Step 3: Create Directory Structure

In your project root (`swirl/`), create the fonts directory:

```bash
# From swirl directory
mkdir -p assets/fonts/inter
```

Or create manually:
```
swirl/
  assets/
    fonts/
      inter/
        (Inter font file goes here)
```

---

### Step 4: Copy Font File

Copy the Inter Variable font to the correct location:

```bash
# Example command (adjust path as needed)
cp ~/Downloads/Inter/Inter-VariableFont_slnt,wght.ttf assets/fonts/inter/Inter-Variable.ttf
```

**Important**: Rename the file to exactly `Inter-Variable.ttf` to match pubspec.yaml configuration.

---

### Step 5: Verify Installation

1. **Check file exists**:
   ```bash
   ls -lh assets/fonts/inter/Inter-Variable.ttf
   ```
   Should show ~500KB file

2. **Clean and rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Visual verification**:
   - Text should appear slightly different (more consistent)
   - Check Profile screen text
   - Check Product card typography

---

## ✅ VERIFICATION CHECKLIST

After setup, verify:

- [ ] File exists at `assets/fonts/inter/Inter-Variable.ttf`
- [ ] File size is approximately 500KB
- [ ] No font-related errors in console
- [ ] App builds successfully
- [ ] Text renders correctly on all screens
- [ ] No "Font not found" warnings

---

## 🔧 TROUBLESHOOTING

### Issue: "Font not found" error

**Solution**:
1. Check file path matches pubspec.yaml exactly
2. File must be named `Inter-Variable.ttf` (case-sensitive)
3. Run `flutter clean && flutter pub get`

---

### Issue: Font looks the same as before

**Possible Causes**:
- Google Fonts fallback is still active
- Font file is corrupted
- Wrong font file used

**Solution**:
1. Verify file integrity (should be ~500KB)
2. Download fresh copy from Google Fonts
3. Restart IDE and rebuild app

---

### Issue: Build fails after adding font

**Solution**:
1. Check pubspec.yaml indentation (must use 2 spaces)
2. Verify assets section is properly formatted
3. Run `flutter pub get` again

---

## 🎨 FONT WEIGHTS AVAILABLE

Inter Variable font includes all weights:
- **100**: Thin
- **200**: Extra Light
- **300**: Light
- **400**: Regular (Normal)
- **500**: Medium
- **600**: Semi Bold
- **700**: Bold
- **800**: Extra Bold
- **900**: Black

All weights are usable with `FontWeight` enum:

```dart
Text(
  'Sample Text',
  style: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600, // Semi Bold
  ),
)
```

---

## 📊 CURRENT USAGE

Inter font is used in:
- **SwirlTypography** - All text styles
- **Headings** - Weight 600-700
- **Body Text** - Weight 400-500
- **Captions** - Weight 400
- **Buttons** - Weight 600

**Files using SwirlTypography**:
- All screen files in `lib/features/*/presentation/`
- All widget files in `lib/features/*/widgets/`
- Theme configuration in `lib/core/theme/`

---

## 🚀 ALTERNATIVE: Keep Google Fonts Fallback

If you prefer to keep using Google Fonts CDN:

### Option 1: No changes needed
- App already configured with google_fonts package
- Fonts download automatically on first use
- Cached for subsequent uses

### Option 2: Update theme to explicitly use Google Fonts

```dart
// lib/core/theme/swirl_typography.dart
import 'package:google_fonts/google_fonts.dart';

class SwirlTypography {
  static TextStyle get headingLarge => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );
  
  // ... etc
}
```

**Pros**:
- No manual font file management
- Always latest font version
- Smaller app bundle size

**Cons**:
- Requires internet on first load
- Slightly slower initial render
- External dependency

---

## 📁 RECOMMENDED FILE STRUCTURE

```
swirl/
├── assets/
│   ├── fonts/
│   │   └── inter/
│   │       └── Inter-Variable.ttf  ← Add this file
│   ├── images/
│   │   └── (app images)
│   └── mock_data/
│       └── (mock data files)
├── lib/
│   └── (app code)
└── pubspec.yaml
```

---

## 🔗 HELPFUL RESOURCES

- **Inter Font Homepage**: https://rsms.me/inter/
- **Google Fonts**: https://fonts.google.com/specimen/Inter
- **Flutter Font Documentation**: https://docs.flutter.dev/cookbook/design/fonts
- **Variable Fonts Guide**: https://web.dev/variable-fonts/

---

## 📝 NOTES FOR DEVELOPERS

1. **Version Control**: 
   - Font files are typically gitignored due to size
   - Document setup process for team members
   - Consider hosting on CDN for team sharing

2. **License**: 
   - Inter is open source (SIL Open Font License)
   - Free for commercial use
   - No attribution required

3. **Performance**:
   - Variable fonts reduce bundle size vs multiple font files
   - Single 500KB file vs multiple 200KB files (net savings)
   - Faster font loading and switching

4. **Updates**:
   - Check for Inter font updates periodically
   - Newer versions may have improved hinting
   - Maintain consistency across team

---

## ✨ SUMMARY

**Without Font Files** (Current State):
- App works perfectly
- Uses Google Fonts fallback
- Slightly slower first load
- External dependency

**With Font Files** (Recommended):
- Identical functionality
- Faster font rendering
- No external dependencies
- Better offline support
- Professional production setup

**Recommendation**: Add font files for production deployment, but don't block development if fonts aren't immediately available.

---

**Document Created**: 2025-11-13  
**Last Updated**: 2025-11-13  
**Status**: ⚠️ Font files not yet added (app works with fallback)  
**Action Required**: Follow steps above to add Inter Variable font