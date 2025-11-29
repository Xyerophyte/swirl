# Comprehensive Testing Guide - Caching & Image Precaching

## Overview
This guide will help you test the newly implemented caching and image precaching features.

## Pre-Test Checklist

### 1. Environment Setup
- ✅ Flutter app running
- ✅ Supabase connection active
- ✅ Device/emulator with network access

### 2. Clear Previous Cache
Before testing, clear any previous cache:
```dart
// In main.dart or during app initialization
final cacheService = CacheService();
await cacheService.clearAll();
```

## Test Cases

### Test 1: Initial Load Performance
**Goal**: Verify 10-card preloading works

**Steps**:
1. Launch app (cold start)
2. Observe console output
3. Look for these logs:
   ```
   ✅ Loaded 30 products + discovery section
   🖼️ Precaching 10 product images (index 0-10)
   ✅ Precaching complete: X successful, Y failed
   ```

**Expected Results**:
- 30 products loaded initially
- Discovery section loaded (trending/new/flash)
- Images for first 10 cards precached
- No visible loading spinners after initial load

**Success Criteria**:
- ✅ Console shows "Loaded 30 products"
- ✅ Console shows "Precaching 10 product images"
- ✅ Images appear instantly when scrolling

---

### Test 2: Swipe Performance
**Goal**: Verify smooth swiping with preloaded images

**Steps**:
1. Swipe through first 10 cards
2. Observe image loading behavior
3. Check console for preload triggers

**Expected Results**:
- Images appear **instantly** (no loading)
- Smooth animations (60fps)
- At card 20: Console shows "🔄 Triggering preload"

**Success Criteria**:
- ✅ Zero visible image loading delays
- ✅ Smooth animations throughout
- ✅ Preload triggers at ~10 cards remaining

---

### Test 3: Cache Hit Rate
**Goal**: Verify cache is working on subsequent loads

**Steps**:
1. Swipe through 20+ cards
2. Close app completely
3. Reopen app (cold start)
4. Observe load speed

**Expected Results**:
- **First load**: ~800ms (network + cache)
- **Second load**: ~50ms (cache only)
- Console shows cache hits

**Success Criteria**:
- ✅ Second load significantly faster
- ✅ No network requests visible
- ✅ Products appear instantly

---

### Test 4: Offline Mode
**Goal**: Verify app works without network

**Steps**:
1. Load app with network
2. Swipe through 10-20 cards
3. Enable airplane mode
4. Swipe through more cards
5. Close and reopen app

**Expected Results**:
- App continues working
- Cached products visible
- Stale cache message in console
- No crashes or errors

**Success Criteria**:
- ✅ App functional offline
- ✅ Previously loaded cards visible
- ✅ Graceful degradation (no new cards)

---

### Test 5: Discovery Section
**Goal**: Verify discovery content loaded

**Steps**:
1. Check console for discovery data
2. Look for:
   ```
   ✅ Loaded X products + discovery section
   ```

**Expected Results**:
- Discovery section cached
- Contains: trending, new_arrivals, flash_sales
- Each section has up to 10 products

**Success Criteria**:
- ✅ Discovery data in console
- ✅ Three sections loaded
- ✅ Data cached for 6 hours

---

### Test 6: Memory Management
**Goal**: Verify no memory leaks

**Steps**:
1. Swipe through 100+ cards
2. Monitor device memory usage
3. Check for performance degradation

**Expected Results**:
- Memory usage stable (~50-100MB)
- No performance degradation
- Smooth animations maintained

**Success Criteria**:
- ✅ Memory usage stable
- ✅ No lag after extended use
- ✅ Cache cleanup working

---

### Test 7: Cache Statistics
**Goal**: Verify cache tracking

**Steps**:
1. Add this to home screen:
```dart
@override
void initState() {
  super.initState();
  
  // Print cache stats after 5 seconds
  Future.delayed(Duration(seconds: 5), () {
    final cacheService = CacheService();
    final stats = cacheService.getStats();
    print('📊 Cache Stats:');
    print('  Hits: ${stats['hits']}');
    print('  Misses: ${stats['misses']}');
    print('  Hit Rate: ${stats['hit_rate']}%');
    print('  Size: ${stats['size_mb']}MB');
    
    final imagePrecache = ImagePrecacheService();
    final imageStats = imagePrecache.getStats();
    print('📊 Image Precache Stats:');
    print('  Cached URLs: ${imageStats['cached_urls']}');
    print('  Currently Caching: ${imageStats['currently_caching']}');
    print('  Success Rate: ${imageStats['success_rate']}%');
  });
}
```

**Expected Results**:
- Cache stats appear in console
- Hit rate increases over time
- Image cache grows with swipes

**Success Criteria**:
- ✅ Stats printed correctly
- ✅ Hit rate > 80% after warmup
- ✅ Image success rate > 90%

---

## Console Log Reference

### Good Logs (Expected):
```
✅ Loaded 30 products + discovery section
🖼️ Precaching 10 product images (index 0-10)
✅ Precaching complete: 10 successful, 0 failed
👆 Swiped right. Cards remaining: 19
📥 Loading more products (10-card preload strategy)...
✅ Loaded 30 more products. Total: 60
🔄 Triggering preload (10 cards remaining)
```

### Warning Logs (Investigate):
```
❌ Failed to precache: https://...
❌ Feed load error: ...
❌ Failed to load more products: ...
```

## Performance Benchmarks

| Metric | Target | Good | Needs Work |
|--------|--------|------|------------|
| Initial Load | <1s | <2s | >2s |
| Cached Load | <100ms | <200ms | >200ms |
| Image Display | <50ms | <100ms | >100ms |
| Swipe FPS | 60fps | 50fps | <50fps |
| Cache Hit Rate | >85% | >70% | <70% |
| Image Success | >95% | >85% | <85% |

## Debugging Tips

### Issue: Images not precaching
**Check**:
1. Network connection stable?
2. Image URLs valid?
3. Console shows precaching logs?

**Solution**:
```dart
// Add more detailed logging in image_precache_service.dart
print('🖼️ Attempting to cache: $url');
```

### Issue: Cache not hitting
**Check**:
1. Cache keys consistent?
2. TTL not expired?
3. SharedPreferences working?

**Solution**:
```dart
// Check cache directly
final prefs = await SharedPreferences.getInstance();
final keys = prefs.getKeys();
print('Cache keys: $keys');
```

### Issue: Performance degradation
**Check**:
1. Memory leaks?
2. Too many cached items?
3. Cache cleanup running?

**Solution**:
```dart
// Force cache cleanup
await cacheService.cleanupExpired();
imagePrecache.clearTracking();
```

## Test Results Template

Copy this template to record your test results:

```
## Test Session: [Date/Time]

### Environment:
- Device: [Device name]
- OS: [Android/iOS version]
- Flutter: [Version]
- Network: [WiFi/4G/5G]

### Test 1: Initial Load
- ✅/❌ 30 products loaded
- ✅/❌ Discovery section loaded
- ✅/❌ Images precached
- Load time: [X]ms

### Test 2: Swipe Performance
- ✅/❌ Instant image display
- ✅/❌ Smooth animations
- ✅/❌ Preload triggered
- FPS: [X]fps

### Test 3: Cache Hit Rate
- ✅/❌ Second load faster
- ✅/❌ Cache working
- First load: [X]ms
- Second load: [X]ms
- Hit rate: [X]%

### Test 4: Offline Mode
- ✅/❌ App functional offline
- ✅/❌ Cached cards visible
- ✅/❌ No crashes

### Test 5: Discovery Section
- ✅/❌ Discovery loaded
- ✅/❌ Three sections present
- ✅/❌ Data cached

### Test 6: Memory Management
- ✅/❌ Memory stable
- ✅/❌ No degradation
- Memory usage: [X]MB

### Test 7: Cache Statistics
- ✅/❌ Stats accurate
- ✅/❌ Hit rate good
- ✅/❌ Image success good

### Overall Assessment:
- Performance: [Excellent/Good/Needs Work]
- Stability: [Stable/Some Issues/Unstable]
- User Experience: [Smooth/Acceptable/Poor]
- Production Ready: [Yes/No]

### Notes:
[Any additional observations]
```

## Next Steps After Testing

### If All Tests Pass:
1. ✅ Mark implementation as complete
2. 📝 Document findings
3. 🚀 Proceed with discovery UI
4. 📊 Add cache analytics dashboard

### If Issues Found:
1. 📋 Document specific failures
2. 🐛 Debug using tips above
3. 🔧 Fix identified issues
4. 🔄 Retest affected areas

## Quick Test Commands

### Restart App Fresh:
```bash
# Kill existing process
flutter clean
flutter pub get

# Restart with logs
flutter run --verbose
```

### Monitor Logs:
```bash
# Filter for cache logs
flutter logs | grep -E "✅|❌|📥|🖼️|👆|🔄"
```

### Check App Size:
```bash
flutter build apk --release
# Check APK size in build/app/outputs/flutter-apk/
```

---

**Ready to Test!** 🚀

Start the app and follow the test cases above. Record your results and report any issues found.