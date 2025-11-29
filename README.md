# 🌀 SWIRL - Fashion Discovery App

<div align="center">

![SWIRL Logo](assets/images/logo.png)

**Tinder for Fashion - Swipe Your Style Into Existence**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A next-generation fashion discovery platform that uses AI-powered personalization and swipe-based interactions to help users discover clothing from UAE/Middle East stores.

[Features](#-features) • [Demo](#-demo) • [Installation](#-installation) • [Architecture](#-architecture) • [Documentation](#-documentation)

</div>

---

## 🎯 What is SWIRL?

SWIRL revolutionizes online fashion discovery by combining:
- **Swipe-based Interface**: Tinder-like mechanics for effortless browsing
- **AI Personalization**: Machine learning that learns your style preferences
- **Weekly Outfit Drops**: Curated outfit recommendations every Monday
- **Multi-Store Discovery**: Products from Amazon, Noon, Namshi, and more
- **Zero Friction**: Browse anonymously, no login required

### 🌟 Key Highlights

- 🎨 **Beautiful UI**: Smooth 60 FPS animations with haptic feedback
- 🤖 **Smart Recommendations**: ML-powered personalization engine
- 🛍️ **Seamless Shopping**: Direct purchase links to product pages
- 📱 **Cross-Platform**: Native iOS & Android with single Flutter codebase
- ⚡ **Blazing Fast**: Optimized feed preloading and image caching

---

## ✨ Features

### Core Features
- **Swipe Gestures**
  - 👉 Swipe Right → Like (add to Swirls)
  - 👈 Swipe Left → View Details
  - 👆 Swipe Up → Skip
  - 👇 Swipe Down → Add to Wishlist

- **Personalized Feed**
  - Style filters (Minimalist, Urban Vibe, Streetwear, Avant-Garde)
  - Brand following with priority in feed
  - ML-based recommendations (coming soon)

- **Weekly Outfits**
  - 2 coordinated outfits delivered every Monday
  - 5 individual high-confidence items
  - Push notifications for new drops

- **Search & Browse**
  - Advanced filters (price, brand, color, size, category)
  - Real-time search suggestions
  - Grid and swipe view modes

- **Shopping Features**
  - Swirls collection (liked items)
  - Wishlist with price alerts
  - Direct "Buy Now" links to stores
  - Shopping cart (Phase 2)

---

## 📱 Demo

### Screenshots

<div align="center">
  <img src="docs/screenshots/home.png" width="200" alt="Home Feed" />
  <img src="docs/screenshots/detail.png" width="200" alt="Product Detail" />
  <img src="docs/screenshots/search.png" width="200" alt="Search" />
  <img src="docs/screenshots/swirls.png" width="200" alt="Swirls" />
</div>

### Video Demo
[Coming Soon]

---

## 🚀 Installation

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.0+
- Android Studio / Xcode
- Supabase account (free tier)

### Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/swirl.git
cd swirl

# 2. Navigate to the app directory
cd swirl

# 3. Install dependencies
flutter pub get

# 4. Set up environment variables
# Copy .env.example to .env and fill in your credentials
cp .env.example .env

# 5. Run the app
flutter run
```

### Environment Setup

Create a `.env` file in the `swirl/` directory:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

See [`SUPABASE_SETUP.md`](SUPABASE_SETUP.md) for detailed backend setup instructions.

---

## 🏗️ Architecture

### Tech Stack

**Frontend**
- **Framework**: Flutter 3.9.2+ (Dart)
- **State Management**: Riverpod 2.4+
- **UI/Animations**: flutter_animate, shimmer
- **Image Caching**: cached_network_image

**Backend**
- **Database**: Supabase (PostgreSQL)
- **Storage**: Supabase Storage (CDN-backed)
- **Auth**: Supabase Auth (anonymous + social login)
- **Analytics**: Firebase Analytics

**Machine Learning** (Phase 2)
- Content-based filtering with CLIP embeddings
- Collaborative filtering
- Hybrid recommendation model

### Project Structure

```
swirl/
├── lib/
│   ├── core/                      # Core utilities
│   │   ├── theme/                 # Design system
│   │   ├── constants/             # App constants
│   │   └── providers/             # Global providers
│   │
│   ├── features/                  # Feature modules
│   │   ├── home/                  # Main swipe feed
│   │   ├── detail/                # Product details
│   │   ├── search/                # Search & filters
│   │   ├── swirls/                # Liked items
│   │   ├── profile/               # User profile
│   │   └── onboarding/            # First-time experience
│   │
│   ├── data/                      # Data layer
│   │   ├── models/                # Data models
│   │   ├── repositories/          # Repository pattern
│   │   └── services/              # API services
│   │
│   └── shared/                    # Shared widgets
│
├── assets/                        # Assets
│   ├── fonts/                     # Inter font family
│   ├── images/                    # App images
│   └── mock_data/                 # Mock JSON data
│
├── docs/                          # Documentation
├── android/                       # Android config
└── ios/                          # iOS config
```

### Database Schema

10 core tables:
- `users` - User profiles and preferences
- `products` - Product catalog
- `swipes` - Comprehensive swipe tracking (13 fields)
- `swirls` - Liked items
- `brands` - Brand catalog
- `brand_follows` - User-brand relationships
- `wishlist_items` - Saved items
- `carts` / `cart_items` - Shopping cart
- `weekly_outfits` - ML-generated recommendations

See [`supabase_schema.sql`](supabase_schema.sql) for full schema.

---

## 📖 Documentation

Comprehensive documentation is available:

### Getting Started
- 📘 [**Quick Start Guide**](QUICK_START.md) - Get up and running in 5 minutes
- 🏃 [**Run App Guide**](RUN_APP.md) - Detailed running instructions
- 🗄️ [**Supabase Setup**](SUPABASE_SETUP.md) - Backend configuration

### Project Documentation
- 📋 [**Product Requirements Document**](PRD.md) - Complete feature specifications
- 🏛️ [**Architecture Overview**](docs_archive/ARCHITECTURE.md) - System design
- ✅ [**Implementation Status**](COMPREHENSIVE_AUDIT_COMPLETE.md) - Current progress
- 🚀 [**Optimization Guide**](OPTIMIZATION_GUIDE.md) - Performance tips

### Development Guides
- 🎨 [**Design System**](PRD.md#11-design-system-specifications) - Colors, typography, spacing
- 🔧 [**Testing Checklist**](docs_archive/TESTING_CHECKLIST.md) - QA guidelines
- 🐛 [**Bug Fix Reports**](docs_archive/BUG_FIX_REPORT.md) - Known issues

---

## 🎨 Design System

### Color Palette
```dart
Primary Black: #1A1A1A
Primary White: #FFFFFF
Accent Coral:  #FF6B6B    // Like action
Accent Blue:   #4A90E2    // Details
Accent Green:  #4CAF50    // Wishlist
```

### Typography
- **Font Family**: Inter (Variable)
- **Scales**: 12px to 32px
- **Weights**: Regular, SemiBold, Bold

### Animations
- Card transitions: 300ms ease-out
- Detail modal: 400ms ease-in-out
- Shimmer loading: Continuous
- 60 FPS guaranteed

---

## 🧪 Testing

### Run Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/features/
```

### Testing Checklist
- [x] Swipe gestures work smoothly
- [x] Feed preloading (20 cards ahead)
- [x] Image caching operational
- [x] Analytics tracking verified
- [x] Detail view animations smooth
- [x] Search filters functional
- [ ] ML recommendations (Phase 2)
- [ ] Social features (Phase 3)

---

## 🚢 Deployment

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Environment Configuration

Different configs for dev/staging/production:
- Development: Mock data, debug logging
- Staging: Real database, analytics enabled
- Production: Optimized build, error tracking

---

## 📊 Performance Metrics

### Current Performance
- **Initial Load**: < 2 seconds
- **Card Transitions**: < 300ms (60 FPS)
- **Image Load**: < 1 second (cached after first view)
- **Search Response**: < 500ms
- **Memory Usage**: < 150 MB average

### Optimization Features
- Progressive image loading with BlurHash
- Aggressive feed preloading (20 cards)
- Image caching (100 MB limit)
- Lazy loading for off-screen content
- Virtual scrolling for large lists

---

## 🗺️ Roadmap

### Phase 1: MVP (Weeks 1-6) ✅
- [x] Core swipe functionality
- [x] Product detail view
- [x] Swirls (liked items)
- [x] Basic search & filters
- [x] Anonymous browsing
- [x] Analytics tracking

### Phase 2: ML & Enhanced Features (Weeks 7-12) 🚧
- [ ] ML-powered personalization
- [ ] Weekly outfit recommendations
- [ ] Advanced search filters
- [ ] Price drop alerts
- [ ] Social sharing

### Phase 3: E-commerce & Social (Weeks 13-20) 📋
- [ ] Shopping cart & checkout
- [ ] Payment integration (Stripe)
- [ ] User profiles & following
- [ ] Outfit collections
- [ ] Comments & likes

### Future Enhancements 🔮
- AR virtual try-on
- Video product demos
- Live shopping events
- Stylist consultations
- Regional expansion (GCC)

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Fork the repository
git clone https://github.com/yourusername/swirl.git

# Create a feature branch
git checkout -b feature/amazing-feature

# Make your changes and commit
git commit -m "Add amazing feature"

# Push to your fork
git push origin feature/amazing-feature

# Open a Pull Request
```

### Code Style
- Follow [Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
- Use Riverpod for state management
- Write tests for new features
- Document public APIs

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Supabase** - Backend infrastructure
- **Flutter Team** - Amazing framework
- **Unsplash** - Product images
- **Inter Font** - Typography
- **Open Source Community** - Inspiration and support

---

## 📞 Contact & Support

- **Email**: support@swirlapp.com
- **Twitter**: [@SwirlApp](https://twitter.com/SwirlApp)
- **Discord**: [Join our community](https://discord.gg/swirl)
- **Issues**: [GitHub Issues](https://github.com/yourusername/swirl/issues)

---

## 🌟 Star History

If you like SWIRL, please give us a ⭐ on GitHub!

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/swirl&type=Date)](https://star-history.com/#yourusername/swirl&Date)

---

<div align="center">

**Made with ❤️ by the SWIRL Team**

[Website](https://swirlapp.com) • [Documentation](docs/) • [Blog](https://blog.swirlapp.com)

</div>
