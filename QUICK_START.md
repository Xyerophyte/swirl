# SWIRL - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Prerequisites Checklist
- ✅ Flutter SDK (latest stable)
- ✅ Firebase CLI installed
- ✅ Supabase MCP server configured
- ✅ Stripe MCP server configured
- ✅ Git initialized
- ✅ VS Code with Flutter extension

---

## 📦 Initial Setup Commands

```bash
# 1. Create Flutter project
flutter create swirl --org com.swirl --platforms=ios,android
cd swirl

# 2. Initialize Git (if not already)
git init
git add .
git commit -m "Initial commit"

# 3. Get Inter font
# Download from: https://fonts.google.com/specimen/Inter
# Place in: assets/fonts/inter/

# 4. Initialize Firebase
firebase login
firebase init
# Select: Analytics, iOS, Android

# 5. Install dependencies
flutter pub get

# 6. Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# 7. Run the app
flutter run
```

---

## 🗂️ Project Structure at a Glance

```
swirl/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app.dart                     # App widget
│   │
│   ├── core/                        # Core utilities
│   │   ├── theme/                   # Colors, typography, theme
│   │   ├── constants/               # App constants
│   │   └── utils/                   # Helper functions
│   │
│   ├── features/                    # Feature modules
│   │   ├── home/                    # Swipe feed
│   │   ├── detail/                  # Product details
│   │   ├── wishlist/                # Saved items
│   │   ├── cart/                    # Shopping cart
│   │   └── search/                  # Search
│   │
│   ├── data/                        # Data layer
│   │   ├── models/                  # Data models
│   │   ├── repositories/            # Data repositories
│   │   └── services/                # API services
│   │
│   └── shared/                      # Shared widgets
│
├── assets/                          # Assets
│   ├── fonts/
│   ├── images/
│   └── mock_data/
│
├── test/                           # Tests
├── ARCHITECTURE.md                 # System architecture
├── IMPLEMENTATION_GUIDE.md         # Detailed guide
└── pubspec.yaml                    # Dependencies
```

---

## 🎯 Key Files to Create First

### 1. Theme Files
- `lib/core/theme/swirl_colors.dart`
- `lib/core/theme/swirl_typography.dart`
- `lib/core/theme/swirl_theme.dart`

### 2. Constants
- `lib/core/constants/app_constants.dart`

### 3. Data Models
- `lib/data/models/product.dart`
- `lib/data/models/cart_item.dart`
- `lib/data/models/user_interaction.dart`

### 4. Services
- `lib/data/services/supabase_service.dart`
- `lib/data/services/firebase_service.dart`

### 5. Core Widgets
- `lib/features/home/presentation/widgets/product_card.dart`
- `lib/features/home/presentation/widgets/swipeable_card.dart`

---

## 🎨 Design System Quick Reference

### Colors
```dart
Primary: #2C2C2C      // Soft black
Accent: #FF6B6B       // Coral
Background: #FAFAFA   // Off-white
Surface: #FFFFFF      // White
```

### Border Radius
```dart
Cards: 24px
Bottom Nav: 28px
Buttons: 16px
Chips: 20px
```

### Typography
```dart
Card Title: 18px, SemiBold
Brand: 14px, Regular
Price: 20px, Bold
```

---

## 🔧 MCP Server Usage

### Supabase MCP
```dart
// List projects
use_mcp_tool: supabase -> list_projects

// Create project
use_mcp_tool: supabase -> create_project

// Apply migration
use_mcp_tool: supabase -> apply_migration

// Execute SQL
use_mcp_tool: supabase -> execute_sql
```

### Stripe MCP
```dart
// Create customer
use_mcp_tool: stripe -> create_customer

// Create payment
use_mcp_tool: stripe -> create_payment_intent

// List products
use_mcp_tool: stripe -> list_products
```

---

## 🎬 Development Workflow

### Day 1-2: Foundation
1. Initialize project
2. Set up Supabase
3. Configure Firebase
4. Add fonts
5. Create design system

### Day 3-5: Core Features
1. Build swipeable cards
2. Implement feed
3. Add preloading
4. Create detail view

### Day 6-8: Additional Features
1. Wishlist
2. Shopping cart
3. Bottom navigation
4. Analytics

### Day 9-10: Polish
1. Animations
2. Haptics
3. Performance
4. Testing

---

## 🐛 Common Issues & Solutions

### Issue: Images not loading
**Solution:** Check Supabase storage permissions and CORS settings

### Issue: Swipe gestures not working
**Solution:** Ensure GestureDetector is wrapping the card correctly

### Issue: Build errors after adding dependencies
**Solution:** Run `flutter pub get` and `flutter clean`

### Issue: Code generation fails
**Solution:** Delete generated files and run `build_runner` with `--delete-conflicting-outputs`

---

## 📊 Testing Your Implementation

### Quick Tests
```dart
// 1. Swipe right - Should like and show next card
// 2. Swipe left - Should open detail view
// 3. Swipe up - Should skip to next
// 4. Double tap - Should add to wishlist
// 5. Scroll through 20+ items - Should be smooth
```

---

## 🎯 Success Criteria Checklist

- [ ] App builds without errors
- [ ] Swipe gestures work smoothly
- [ ] Images load without delay
- [ ] Detail view slides in correctly
- [ ] Bottom nav stays visible
- [ ] Animations are smooth (60 FPS)
- [ ] No lag when scrolling
- [ ] Analytics tracking works
- [ ] Cart functionality complete
- [ ] Checkout flow works

---

## 📚 Reference Documentation

- **Architecture:** See [`ARCHITECTURE.md`](ARCHITECTURE.md)
- **Implementation:** See [`IMPLEMENTATION_GUIDE.md`](IMPLEMENTATION_GUIDE.md)
- **PRD:** See original Product Requirements Document
- **Flutter Docs:** https://docs.flutter.dev
- **Supabase Docs:** https://supabase.com/docs
- **Riverpod Docs:** https://riverpod.dev

---

## 🚀 Ready to Build!

Use this as your quick reference while implementing. For detailed step-by-step instructions, refer to [`IMPLEMENTATION_GUIDE.md`](IMPLEMENTATION_GUIDE.md).

**Next Step:** Switch to Code mode and start with Task 1: Initialize Flutter Project