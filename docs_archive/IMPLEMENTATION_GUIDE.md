# SWIRL - Detailed Implementation Guide

## 🎯 Overview

This guide provides step-by-step implementation details for each feature of SWIRL, making it easy for the Code mode to execute each task independently.

---

## 📋 Phase 1: Project Foundation (Week 1)

### Task 1: Initialize Flutter Project

**Objective:** Set up a new Flutter project with proper configuration

**Steps:**
```bash
# Create new Flutter project
flutter create swirl --org com.swirl --platforms=ios,android

# Navigate to project
cd swirl

# Update pubspec.yaml with dependencies
# (See dependencies section below)

# Get packages
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs
```

**File Changes:**
- [`pubspec.yaml`](pubspec.yaml): Add all dependencies from PRD
- [`.gitignore`](.gitignore): Add Supabase credentials, Firebase config
- [`analysis_options.yaml`](analysis_options.yaml): Add linting rules

**Success Criteria:**
- ✅ Project builds without errors
- ✅ All dependencies resolve
- ✅ Code generation works

---

### Task 2: Set Up Supabase Backend

**Objective:** Create Supabase project and initialize database schema using MCP

**Using Supabase MCP Server:**

```dart
// Step 1: List existing projects (if any)
use_mcp_tool:
  server_name: supabase
  tool_name: list_projects

// Step 2: Create new project (if needed)
use_mcp_tool:
  server_name: supabase
  tool_name: create_project
  arguments: {
    "name": "swirl-fashion",
    "region": "us-east-1",
    "organization_id": "<from_list_projects>",
    "confirm_cost_id": "<from_confirm_cost>"
  }

// Step 3: Apply database schema
use_mcp_tool:
  server_name: supabase
  tool_name: apply_migration
  arguments: {
    "project_id": "<project_ref>",
    "name": "create_products_table",
    "query": "<SQL_from_ARCHITECTURE.md>"
  }
```

**Database Migrations:**

1. **Migration 1:** Create products table
```sql
-- See ARCHITECTURE.md section "Database Schema (Supabase)"
-- Copy the CREATE TABLE products statement
```

2. **Migration 2:** Create user_interactions table
```sql
-- See ARCHITECTURE.md
```

3. **Migration 3:** Create wishlist table
```sql
-- See ARCHITECTURE.md
```

4. **Migration 4:** Create cart table
```sql
-- See ARCHITECTURE.md
```

5. **Migration 5:** Insert mock data
```sql
-- Create file: assets/mock_data/insert_products.sql
INSERT INTO products (name, brand, description, price, original_price, category, image_url) VALUES
('Ziva Faux Leather Mini Skirt', 'BdlKited', 'Stylish faux leather mini skirt', 39.00, 64.00, 'Bottoms', 'https://picsum.photos/400/600?random=1'),
('Classic White Tee', 'Urban Basics', 'Essential white cotton tee', 24.99, 34.99, 'Tops', 'https://picsum.photos/400/600?random=2'),
-- Add 50+ more products
;
```

**Configuration File:**
```dart
// lib/core/config/supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}
```

**Success Criteria:**
- ✅ Supabase project created
- ✅ All tables created with indexes
- ✅ Mock data inserted (50+ products)
- ✅ Can query products via Supabase client

---

### Task 3: Configure Firebase Analytics

**Objective:** Set up Firebase for hidden analytics tracking

**Steps:**

```bash
# Install Firebase CLI (if not already)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init

# Select:
# - Analytics
# - Create new project or select existing
# - iOS and Android apps
```

**Flutter Setup:**

```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const SwirlApp());
}
```

**Analytics Service:**

```dart
// lib/data/services/firebase_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  // Session tracking
  static Future<void> logSessionStart() async {
    await _analytics.logEvent(
      name: 'session_start',
      parameters: {'timestamp': DateTime.now().toIso8601String()},
    );
  }

  // Swipe tracking
  static Future<void> logSwipe({
    required String direction, // 'right', 'left', 'up'
    required String productId,
    required String productName,
    required double price,
    required String category,
  }) async {
    await _analytics.logEvent(
      name: 'swipe_$direction',
      parameters: {
        'product_id': productId,
        'product_name': productName,
        'price': price,
        'category': category,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Other tracking methods...
}
```

**Success Criteria:**
- ✅ Firebase initialized in iOS and Android
- ✅ Analytics events logging successfully
- ✅ Events visible in Firebase Console

---

### Task 4: Download and Configure Inter Font

**Objective:** Add Inter font family to the project

**Steps:**

1. **Download Inter Font:**
   - Visit: https://fonts.google.com/specimen/Inter
   - Download font family (Regular, Medium, SemiBold, Bold)

2. **Add to Project:**
```
assets/
└── fonts/
    └── inter/
        ├── Inter-Regular.ttf
        ├── Inter-Medium.ttf
        ├── Inter-SemiBold.ttf
        └── Inter-Bold.ttf
```

3. **Update pubspec.yaml:**
```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/inter/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/inter/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/inter/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/inter/Inter-Bold.ttf
          weight: 700
```

4. **Create Typography Class:**
```dart
// lib/core/theme/swirl_typography.dart
import 'package:flutter/material.dart';

class SwirlTypography {
  static const String fontFamily = 'Inter';
  
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  
  static const TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  
  static const TextStyle priceOriginal = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    height: 1.2,
  );
  
  // Add more text styles as needed
}
```

**Success Criteria:**
- ✅ Fonts load correctly
- ✅ Typography class created
- ✅ Text renders with Inter font

---

### Task 5: Create Core Design System

**Objective:** Implement colors, typography, and theme

**Files to Create:**

1. **Colors:**
```dart
// lib/core/theme/swirl_colors.dart
import 'package:flutter/material.dart';

class SwirlColors {
  // Primary colors (soft, not aggressive)
  static const Color primary = Color(0xFF2C2C2C);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color secondary = Color(0xFF4A5568);
  
  // Backgrounds (warm, comfortable)
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFEFEFE);
  
  // Text (high contrast but soft)
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  // Borders & dividers (subtle)
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  
  // Success & error (muted)
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  
  // Overlays
  static const Color overlay = Color(0x99000000);
  static const Color overlayLight = Color(0x66000000);
}
```

2. **Theme:**
```dart
// lib/core/theme/swirl_theme.dart
import 'package:flutter/material.dart';
import 'swirl_colors.dart';
import 'swirl_typography.dart';

class SwirlTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: SwirlTypography.fontFamily,
      scaffoldBackgroundColor: SwirlColors.background,
      
      colorScheme: ColorScheme.light(
        primary: SwirlColors.primary,
        secondary: SwirlColors.accent,
        surface: SwirlColors.surface,
        background: SwirlColors.background,
        error: SwirlColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: SwirlColors.textPrimary,
        onBackground: SwirlColors.textPrimary,
        onError: Colors.white,
      ),
      
      textTheme: TextTheme(
        displayLarge: SwirlTypography.cardTitle,
        bodyLarge: SwirlTypography.cardSubtitle,
        headlineMedium: SwirlTypography.price,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SwirlColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
      
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: SwirlColors.surface,
      ),
    );
  }
}
```

3. **Constants:**
```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  // Border Radius
  static const double radiusCard = 24.0;
  static const double radiusBottomNav = 28.0;
  static const double radiusButtonLarge = 16.0;
  static const double radiusButtonSmall = 12.0;
  static const double radiusInput = 14.0;
  static const double radiusChip = 20.0;
  static const double radiusModal = 32.0;
  static const double radiusImage = 12.0;
  
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Swipe Configuration
  static const double swipeThreshold = 0.3;
  static const double swipeVelocityThreshold = 300.0;
  
  // Preloading
  static const int fullyLoadedDistance = 5;
  static const int queueDistance = 10;
  static const int fetchTrigger = 5;
  
  // Surprise Injection
  static const int surpriseMinSwipes = 15;
  static const int surpriseMaxSwipes = 20;
}
```

**Success Criteria:**
- ✅ All color constants defined
- ✅ Typography system complete
- ✅ Theme applied to app
- ✅ Constants accessible throughout app

---

## 📋 Phase 2: Data Layer (Week 1-2)

### Task 6: Implement Data Models

**Objective:** Create data models with serialization

**Models to Create:**

1. **Product Model:**
```dart
// lib/data/models/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String brand,
    required String description,
    required double price,
    double? originalPrice,
    required String category,
    String? subcategory,
    @Default(['S', 'M', 'L', 'XL']) List<String> sizes,
    @Default(['Black', 'White']) List<String> colors,
    String? materials,
    required String imageUrl,
    @Default([]) List<String> additionalImages,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(false) bool isTrending,
    @Default(false) bool isNewArrival,
    @Default(false) bool isFlashSale,
    @Default(0) int discountPercentage,
    @Default(100) int stockCount,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
```

2. **Cart Item Model:**
```dart
// lib/data/models/cart_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required Product product,
    required String size,
    String? color,
    @Default(1) int quantity,
    DateTime? createdAt,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
```

3. **User Interaction Model:**
```dart
// lib/data/models/user_interaction.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_interaction.freezed.dart';
part 'user_interaction.g.dart';

enum InteractionType {
  like,
  skip,
  view,
  cart,
  purchase,
}

@freezed
class UserInteraction with _$UserInteraction {
  const factory UserInteraction({
    required String id,
    required String userId,
    required String productId,
    required InteractionType interactionType,
    String? sessionId,
    DateTime? createdAt,
  }) = _UserInteraction;

  factory UserInteraction.fromJson(Map<String, dynamic> json) =>
      _$UserInteractionFromJson(json);
}
```

**Run Code Generation:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Success Criteria:**
- ✅ All models created with freezed
- ✅ JSON serialization works
- ✅ Code generation successful

---

### Task 7: Create Repository Layer

**Objective:** Implement repositories for data access

**Repositories to Create:**

1. **Product Repository:**
```dart
// lib/data/repositories/product_repository.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';
import '../services/supabase_service.dart';

part 'product_repository.g.dart';

@riverpod
class ProductRepository extends _$ProductRepository {
  @override
  FutureOr<void> build() {}

  Future<List<Product>> fetchProducts({
    int limit = 20,
    int offset = 0,
    String? category,
  }) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    var query = supabase.client
        .from('products')
        .select()
        .range(offset, offset + limit - 1);
    
    if (category != null) {
      query = query.eq('category', category);
    }
    
    final response = await query;
    
    return (response as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  Future<Product?> fetchProductById(String id) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    final response = await supabase.client
        .from('products')
        .select()
        .eq('id', id)
        .single();
    
    return Product.fromJson(response);
  }

  Future<List<Product>> searchProducts(String query) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    final response = await supabase.client
        .from('products')
        .select()
        .or('name.ilike.%$query%,brand.ilike.%$query%');
    
    return (response as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
}
```

2. **Analytics Repository:**
```dart
// lib/data/repositories/analytics_repository.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_interaction.dart';
import '../services/supabase_service.dart';
import '../services/firebase_service.dart';

part 'analytics_repository.g.dart';

@riverpod
class AnalyticsRepository extends _$AnalyticsRepository {
  @override
  FutureOr<void> build() {}

  Future<void> logInteraction({
    required String userId,
    required String productId,
    required InteractionType type,
    String? sessionId,
  }) async {
    // Log to Supabase
    final supabase = ref.read(supabaseServiceProvider);
    await supabase.client.from('user_interactions').insert({
      'user_id': userId,
      'product_id': productId,
      'interaction_type': type.name,
      'session_id': sessionId,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    // Log to Firebase Analytics (hidden from user)
    await FirebaseService.logSwipe(
      direction: type.name,
      productId: productId,
      productName: '', // Fetch if needed
      price: 0, // Fetch if needed
      category: '', // Fetch if needed
    );
  }

  Future<Map<String, dynamic>> getSessionStats(String sessionId) async {
    final supabase = ref.read(supabaseServiceProvider);
    
    final interactions = await supabase.client
        .from('user_interactions')
        .select()
        .eq('session_id', sessionId);
    
    return {
      'total_swipes': interactions.length,
      'likes': interactions.where((i) => i['interaction_type'] == 'like').length,
      'skips': interactions.where((i) => i['interaction_type'] == 'skip').length,
      'views': interactions.where((i) => i['interaction_type'] == 'view').length,
    };
  }
}
```

**Success Criteria:**
- ✅ Repositories implement CRUD operations
- ✅ Error handling in place
- ✅ Integration with Supabase working

---

## 📋 Phase 3: Core Features (Week 2-3)

### Task 8: Build Swipeable Card Widget

**Objective:** Create the core swipeable card with gesture detection

**Implementation:**

```dart
// lib/features/home/presentation/widgets/swipeable_card.dart
import 'package:flutter/material.dart';
import '../../../../data/models/product.dart';
import '../../../../core/constants/app_constants.dart';

class SwipeableCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onDoubleTap;

  const SwipeableCard({
    Key? key,
    required this.product,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onSwipeUp,
    this.onDoubleTap,
  }) : super(key: key);

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.animationNormal,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final swipeThreshold = screenWidth * AppConstants.swipeThreshold;
    final velocity = details.velocity.pixelsPerSecond;
    
    // Determine swipe direction
    if (_dragOffset.dx.abs() > swipeThreshold || 
        velocity.dx.abs() > AppConstants.swipeVelocityThreshold) {
      if (_dragOffset.dx > 0) {
        _swipeRight();
      } else {
        _swipeLeft();
      }
    } else if (_dragOffset.dy < -swipeThreshold ||
               velocity.dy < -AppConstants.swipeVelocityThreshold) {
      _swipeUp();
    } else {
      _resetPosition();
    }
  }

  void _swipeRight() {
    _controller.forward().then((_) {
      widget.onSwipeRight?.call();
      _controller.reset();
    });
  }

  void _swipeLeft() {
    _controller.forward().then((_) {
      widget.onSwipeLeft?.call();
      _controller.reset();
    });
  }

  void _swipeUp() {
    _controller.forward().then((_) {
      widget.onSwipeUp?.call();
      _controller.reset();
    });
  }

  void _resetPosition() {
    setState(() {
      _dragOffset = Offset.zero;
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onDoubleTap: widget.onDoubleTap,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: _dragOffset.dx * 0.0005,
          child: ProductCard(product: widget.product),
        ),
      ),
    );
  }
}
```

**Success Criteria:**
- ✅ Card responds to swipe gestures
- ✅ Smooth animations
- ✅ Correct direction detection
- ✅ Double tap works

---

### Task 9: Implement Infinite Feed with Preloading

**Implementation Details:**

See [`ARCHITECTURE.md`](ARCHITECTURE.md:131) for FeedPreloader class.

**Key Components:**
1. Feed State Provider
2. Preloader Logic
3. Surprise Injector
4. Card Stack Widget

**File:** [`lib/features/home/logic/feed_preloader.dart`](lib/features/home/logic/feed_preloader.dart)

**Success Criteria:**
- ✅ Next 5 cards fully loaded
- ✅ Images preloaded in background
- ✅ Smooth scrolling with no lag
- ✅ Surprise injection working

---

## 📋 Phase 4: Additional Features (Week 3-4)

_Continue with remaining tasks..._

---

## 🎯 Testing Checklist

### Unit Tests
- [ ] Product model serialization
- [ ] Cart calculations
- [ ] Recommendation algorithm
- [ ] State providers

### Widget Tests
- [ ] Product card rendering
- [ ] Swipe gestures
- [ ] Detail view navigation
- [ ] Bottom nav

### Integration Tests
- [ ] Complete swipe flow
- [ ] Add to cart flow
- [ ] Checkout process

---

## 🚀 Ready to Build!

This guide provides all the details needed to implement SWIRL. Each task is independent and can be executed step-by-step in Code mode.