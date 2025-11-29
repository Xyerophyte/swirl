# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**SWIRL** is a Tinder-style fashion discovery platform for the UAE/Middle East market. Users swipe through clothing items from major retailers (Amazon, Noon, Namshi), with AI-powered personalization learning their style preferences through swipe behavior.

**Tech Stack:**
- **Frontend:** Flutter (iOS/Android)
- **State Management:** Riverpod
- **Backend:** Supabase (PostgreSQL + Auth + Storage)
- **Analytics:** Firebase Analytics (hidden from users)
- **Payments:** Stripe (via MCP)

## Key Development Commands

### Running the App
```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run in release mode
flutter run --release

# Check for connected devices
flutter devices
```

### Code Generation
```bash
# Generate code for Riverpod, Freezed, JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Database Operations
The project uses Supabase. Database schema and migrations are in:
- `supabase_schema.sql` - Complete schema
- `supabase_mock_data.sql` - Test data
- `supabase_rpc_functions.sql` - Stored procedures

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/home/feed_provider_test.dart

# Run with coverage
flutter test --coverage
```

### Build & Release
```bash
# Build APK (Android)
flutter build apk --release

# Build iOS
flutter build ios --release

# Clean build artifacts
flutter clean
```

## Architecture Overview

### Directory Structure
```
lib/
├── core/               # Cross-cutting concerns
│   ├── theme/         # Design system (colors, typography, theme)
│   ├── constants/     # App-wide constants
│   ├── services/      # Core services (haptics, caching, lifecycle)
│   ├── providers/     # Global Riverpod providers
│   └── utils/         # Helper utilities
│
├── features/          # Feature modules (presentation + providers)
│   ├── home/         # Swipeable feed (main screen)
│   ├── detail/       # Product detail view
│   ├── search/       # Search & filters
│   ├── swirls/       # Liked items screen
│   ├── wishlist/     # Saved items
│   ├── profile/      # User profile & settings
│   ├── onboarding/   # First-time user experience
│   ├── weekly_outfits/ # AI-curated outfit recommendations
│   └── navigation/   # Bottom navigation bar
│
└── data/             # Data layer
    ├── models/       # Data models (Product, User, Swipe, etc.)
    ├── repositories/ # Data access layer
    └── services/     # External services (Supabase, Firebase)
```

### Key Architectural Patterns

**State Management Flow:**
```
UI Widget → Riverpod Provider → Repository → Service (Supabase/Firebase) → Backend
```

**Feature Structure:**
Each feature follows a consistent pattern:
- `presentation/` or `screens/` - UI widgets
- `widgets/` - Feature-specific reusable widgets
- `providers/` - Riverpod state management

**Data Models:**
All models use:
- `freezed` for immutability and code generation
- `json_serializable` for JSON serialization
- Located in `lib/data/models/`

## Critical Implementation Details

### Swipe Gesture System
The core UX is built around 4-directional swipes (DO NOT modify without updating PRD):
- **Swipe Right** → Like/Save to Swirls (primary positive action)
- **Swipe Left** → Open detail view
- **Swipe Up** → Skip to next card
- **Swipe Down** → Quick save to wishlist
- **Double Tap** → Also saves to wishlist

Implementation: [lib/features/home/widgets/swipeable_card.dart](lib/features/home/widgets/swipeable_card.dart)

### Design System
Located in `lib/core/theme/`:
- **Colors:** Soft black (#2C2C2C), coral accent (#FF6B6B), warm backgrounds
- **Typography:** Inter font family (Regular, Medium, SemiBold, Bold)
- **Border Radius:** Cards (24px), Bottom nav (28px), Buttons (16px), Chips (20px)

All UI must match the design system defined in [swirl_theme.dart](lib/core/theme/swirl_theme.dart).

### Feed Preloading Strategy
For smooth infinite scrolling:
- Preload next 5 items completely
- Queue next 5 items (start loading)
- Fetch next 10 in background when user reaches the last 5 items

Implementation: [lib/features/home/providers/feed_provider.dart](lib/features/home/providers/feed_provider.dart)

### Supabase Integration
User ID is persisted locally via SharedPreferences. All data operations use:
```dart
final supabase = Supabase.instance.client;
```

Anonymous users are supported - they can browse and swipe without signing up. Data migrates when they create an account.

### Analytics Tracking
Firebase Analytics is integrated but **completely hidden from users**. Track:
- Swipe events (direction, dwell time, product details)
- Session metrics (duration, swipes per session)
- Product views and interactions
- Purchase events

Never expose analytics to users or mention metrics in UI.

### Style Filters
4 primary style tags (multi-select):
- `minimalist` - Clean, neutral, simple
- `urban_vibe` - Contemporary streetwear
- `streetwear_edge` - Athletic, oversized, brand-heavy
- `avant_garde` - Experimental, high-fashion

Filters use **soft bias ranking** (increases score, doesn't exclude). Implementation in [lib/features/home/widgets/style_filter_chips.dart](lib/features/home/widgets/style_filter_chips.dart).

## Common Development Tasks

### Adding a New Feature
1. Create feature directory under `lib/features/[feature_name]/`
2. Add presentation/screens layer
3. Create Riverpod providers for state management
4. Add models in `lib/data/models/` if needed
5. Create repository in `lib/data/repositories/` if accessing backend
6. Update navigation in `lib/features/navigation/presentation/bottom_navigation.dart`

### Modifying Supabase Schema
1. Update SQL schema in `supabase_schema.sql`
2. Apply migration via Supabase dashboard or MCP
3. Update Dart models in `lib/data/models/`
4. Regenerate code: `flutter pub run build_runner build --delete-conflicting-outputs`
5. Update repositories to handle new fields

### Adding New Product Data
Mock data structure is defined in `supabase_mock_data.sql`. Products must include:
- External ID (Amazon ASIN or equivalent)
- Price, brand, category, style tags
- Primary image URL (and optional additional images)
- Sizes, colors, materials

### Debugging Swipe Issues
Common issues:
1. **Swipes not detected:** Check GestureDetector wraps the entire card
2. **Wrong direction triggered:** Verify swipe thresholds in [app_constants.dart](lib/core/constants/app_constants.dart)
3. **Laggy animations:** Check if images are preloaded properly
4. **Cards not updating:** Verify Riverpod provider notifies listeners

### Performance Optimization
Critical areas:
- Image preloading and caching ([image_precache_service.dart](lib/core/services/image_precache_service.dart))
- Memory management (dispose old cards after 10 positions)
- Animation performance (use hardware acceleration)
- Minimize rebuilds (use `select` in Riverpod consumers)

## Important Documentation Files

- [ARCHITECTURE.md](ARCHITECTURE.md) - Detailed system architecture, data flow, database schema
- [PRD.md](PRD.md) - Complete product requirements and feature specifications
- [QUICK_START.md](QUICK_START.md) - Setup guide and getting started
- [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) - Current implementation status

**Always reference these files** when implementing features to ensure alignment with the product vision.

## Environment Setup

### Required Files
Create `.env` in project root:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```

### Assets Required
- Inter font family: `assets/fonts/inter/Inter-Variable.ttf`
- Logo: `assets/images/LOGO.png`
- Mock data: `assets/mock_data/products.json`

## Code Style Guidelines

### Widget Construction
- Use `const` constructors wherever possible
- Extract complex widgets into separate files
- Keep widget build methods under 100 lines
- Use meaningful variable names (no single letters except loop iterators)

### State Management
- Use Riverpod providers for all shared state
- Keep providers focused on single responsibility
- Use `StateNotifier` for complex state logic
- Avoid business logic in widgets

### Data Models
- All models must be immutable (use `freezed`)
- Include `fromJson` and `toJson` factories
- Add helpful getters for computed properties
- Document complex fields with comments

### Error Handling
- Always handle Supabase errors gracefully
- Show user-friendly error messages (never raw exceptions)
- Log errors to Firebase Analytics for monitoring
- Implement retry logic for network failures

## Testing Strategy

### What to Test
- **Unit Tests:** Data models, repositories, business logic
- **Widget Tests:** Individual UI components
- **Integration Tests:** Complete user flows (swipe → like → view swirls)

### Mock Data
Use the test user ID `99999999-9999-9999-9999-999999999999` for integration tests. Mock data is already populated in Supabase.

## Deployment Considerations

### Pre-Release Checklist
- [ ] All tests passing
- [ ] No console errors or warnings
- [ ] Images load smoothly without flicker
- [ ] Swipe gestures respond correctly
- [ ] Analytics events firing
- [ ] Performance: 60 FPS on target devices
- [ ] Memory usage stable over long sessions

### Platform-Specific
- **iOS:** Requires valid provisioning profile and certificates
- **Android:** Update version code in `pubspec.yaml` before each release

## Notes for Claude Code

- The gesture system is the core UX - be extremely careful when modifying swipe behavior
- Always maintain the design system consistency (use theme values, not hardcoded colors)
- This is a highly visual app - animations and smooth transitions are critical
- The app uses anonymous-first auth - never force users to sign up to browse
- Weekly outfits feature is ML-driven but currently uses rule-based recommendations
- Supabase handles all backend operations - no custom REST APIs
- All analytics must remain invisible to end users
