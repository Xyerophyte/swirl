# Profile Page Database Error Fix

## Issue Identified
**Error:** `Exception: Failed to get user: Cannot coerce the result to a single JSON object`

## Root Cause
The error occurred because multiple repository methods were using `.single()` which expects exactly one row to be returned. When the query returns zero rows or multiple rows, this causes a runtime exception with the message "Cannot coerce the result to a single JSON object".

## Solution Applied
Replaced all problematic `.single()` calls with `.maybeSingle()` across all repository files. The `.maybeSingle()` method:
- Returns `null` if no rows match (instead of throwing an error)
- Returns the single row if exactly one matches
- Throws an error only if multiple rows match

## Files Modified

### 1. `lib/data/repositories/user_repository.dart`
Fixed 6 occurrences of `.single()`:
- `getUser()` - Line 18 → Now returns `null` gracefully if user doesn't exist
- `upsertUser()` - Line 59 → Proper null check after upsert
- `updateUser()` - Line 84 → Throws clear error if user not found
- `updateStylePreferences()` - Line 106 → Throws clear error if user not found
- `updateOnboardingData()` - Line 133 → Throws clear error if user not found
- `updateUserPreferences()` - Line 233 → Throws clear error if user not found

### 2. `lib/data/repositories/product_repository.dart`
Fixed 1 occurrence:
- `getProductById()` - Line 97 → Returns `null` if product doesn't exist

### 3. `lib/data/repositories/swirl_repository.dart`
Fixed 2 occurrences:
- `addSwirl()` - Line 43 → Proper null check after insert
- `addSwirl()` duplicate handler - Line 55 → Returns existing swirl or throws error

### 4. `lib/data/repositories/wishlist_repository.dart`
Fixed 1 occurrence:
- `addToWishlist()` - Line 25 → Proper null check after insert

## Total Changes
- **4 files modified**
- **10 `.single()` calls replaced with `.maybeSingle()`**
- **All methods now have proper null handling**

## Expected Outcome
The profile page should now load successfully without throwing "Cannot coerce the result to a single JSON object" errors. The app will handle cases where:
- User doesn't exist in database
- Query returns unexpected number of rows
- Database operations complete successfully

## Testing Recommendations
1. Open the profile page - should load without errors
2. Try updating profile information
3. Test with new users (no existing data)
4. Test with existing users (with data)
5. Verify all swipe/swirl functionality still works

## Additional Benefits
This fix also prevents similar errors in:
- Product detail views
- Swirl/wishlist operations
- User profile updates
- Any database query expecting single results

## Technical Details
**Before:**
```dart
final response = await _client
    .from('users')
    .select()
    .eq('id', userId)
    .single(); // Throws error if 0 or >1 rows
```

**After:**
```dart
final response = await _client
    .from('users')
    .select()
    .eq('id', userId)
    .maybeSingle(); // Returns null if 0 rows, throws only if >1 rows

if (response == null) {
  return null; // or throw meaningful error
}
```

This pattern provides better error handling and more predictable behavior across the entire application.