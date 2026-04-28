# 🧪 Journal Optimization — Testing Guide

## Quick Start Test

### Test 1: Initial Load Performance
```
1. Force close the app completely
2. Open Journal screen
3. Expected: 
   - Skeleton cards appear immediately (<500ms)
   - Shimmer animation plays
   - Real entries appear when Firestore responds
   - Zero blank screen time
```

### Test 2: Optimistic Save
```
1. Tap "New Entry" button
2. Fill title + content
3. Tap "Save"
4. Expected:
   - Navigation back to list is instant
   - Entry appears in list immediately
   - No spinner/loading indicator
   - Entry persisted to Hive + Firestore (check backend)
```

### Test 3: Offline Mode
```
1. Create an entry while online (normal flow)
2. Enable Airplane Mode
3. Create another entry
4. Expected:
   - Entry saved to Hive successfully
   - Shows in the list locally
   - No error message (graceful offline)
5. Disable Airplane Mode
6. Expected:
   - Entry syncs to Firestore in background
   - No UI disruption
```

### Test 4: Delete Offline
```
1. With Airplane Mode ON
2. Delete an entry from the list
3. Expected:
   - Entry removed from UI instantly
   - No spinner
   - No error notification
   - Entry marked for deletion in Hive
4. Disable Airplane Mode
5. Expected:
   - Deletion syncs to Firestore
```

### Test 5: Slow Network (3G Throttle)
```
1. Enable Android Studio / XCode Network throttle (3G)
2. Swipe down to refresh Journal list
3. Expected:
   - Cached entries show immediately
   - Skeleton cards animate gently
   - No frozen UI
   - Network icon shows activity
```

### Test 6: Skeleton Animation
```
1. Fast kill + restart app multiple times
2. Observe Journal screen load
3. Expected:
   - Shimmer skeleton visible every time
   - Animation smooth (60fps)
   - Layout matches real cards exactly
   - No flickering or jumps
```

---

## Performance Verification

### Using DevTools

1. **Open DevTools**: Right-click app → Select from device
2. **Tab: Performance**:
   - Navigate to Journal
   - Record timeline
   - Expected: No frame drops during load

3. **Tab: Memory**:
   - Check Hive box size
   - Should be reasonable (varies by entry count)

4. **Tab: Network** (for web):
   - Monitor Firestore requests
   - Verify they run in background
   - UI remains responsive

---

## Debugging

### Check Hive Cache
```dart
// Add temporary debug button in JournalScreen
FloatingActionButton(
  onPressed: () async {
    final box = await Hive.openBox('journal_entries');
    debugPrint('Hive entries: ${box.length}');
    debugPrint('Keys: ${box.keys.toList()}');
  },
)
```

### Console Logs
Look for these messages:
```
[JournalFirestoreRepository] loaded X entries from cache
[JournalFirestoreRepository] fetched X entries from Firestore
[JournalFirestoreRepository] synced X entries to Hive cache
[JournalFirestoreRepository] saved to Hive cache: id=XXX
```

### Error Scenarios
If you see:
```
Journal save failed: [error message]
Journal delete failed: [error message]
Journal clearAll failed: [error message]
```

This is **expected** — failures are logged but don't crash the app (graceful degradation).

---

## Expected Behavior After Optimization

### ✅ Works Now
- App launches without blank screen
- Entries appear within 500ms
- Saving feels instant to user
- Deleting feels instant
- Offline mode works with cache
- Refresh doesn't block UI
- Skeleton loading animation

### ⚠️ Known Limitations
- Network sync failures show in console only (TODO: add toast)
- No visual "syncing..." indicator yet
- Conflict resolution not implemented for simultaneous edits
- Large datasets (1000+ entries) may need pagination

---

## Troubleshooting

### Problem: No skeleton animation visible
**Solution**: 
- Check Firestore response time (may be too fast)
- Artificially throttle network in DevTools
- Verify `shimmer` package is installed: `flutter pub get`

### Problem: Entries not persisting offline
**Solution**:
- Verify Hive box is initialized: check console logs
- Check app has storage permissions (Android)
- Delete app data to reset Hive: uninstall + reinstall

### Problem: Old entries still showing after delete
**Solution**:
- Hive might have stale cache
- Pull to refresh to sync with Firestore
- If persists, delete app data

---

## Performance Targets

| Metric | Target | Acceptable |
|--------|--------|------------|
| Skeleton visible | <100ms | <300ms |
| Initial render | <500ms | <1000ms |
| TTI (Time to Interactive) | <200ms | <500ms |
| Save response | <50ms | <200ms |
| Delete response | <50ms | <200ms |
| Memory (Hive box) | <5MB | <20MB |

---

## Feedback & Monitoring

### Collect User Feedback
- Ask users: "Does the app feel faster?"
- Monitor: Journal screen load times in analytics
- Track: Save/delete latency metrics

### Monitor Firestore
- Check quota usage (should decrease with optimistic UI)
- Monitor failed write attempts
- Verify Hive sync is reducing reads

---

**Last Updated**: 2026-04-28
**Status**: Ready for Testing
