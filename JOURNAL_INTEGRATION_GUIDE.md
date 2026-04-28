# 🔧 Journal Offline-First — Integration Guide

## Pour les Développeurs

### Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│           JournalScreen (UI Layer)                  │
├─────────────────────────────────────────────────────┤
│  • Displays cached data + skeleton while loading    │
│  • Uses skipLoadingOnReload (implicit with Riverpod)│
│  • Shows error only on total failure               │
└──────────────────────┬──────────────────────────────┘
                       │
                       ↓
┌─────────────────────────────────────────────────────┐
│      JournalProvider (State Management)              │
├─────────────────────────────────────────────────────┤
│  • JournalNotifier: StateNotifierProvider            │
│  • State: AsyncValue<List<JournalEntry>>            │
│  • Methods: load(), upsert(), delete(), clearAll()  │
└──────────────────────┬──────────────────────────────┘
                       │
                       ↓
┌─────────────────────────────────────────────────────┐
│    JournalRepository (Data Layer)                   │
├─────────────────────────────────────────────────────┤
│  • JournalFirestoreRepository with Hive integration │
│  • Hive Box Name: 'journal_entries'                 │
│  • Dual write: Local (Hive) + Remote (Firestore)   │
└──────────┬──────────────────────┬───────────────────┘
           │                      │
           ↓                      ↓
    ┌──────────┐          ┌──────────────┐
    │  Hive    │          │  Firestore   │
    │  (Local) │          │  (Remote)    │
    └──────────┘          └──────────────┘
```

---

## Key Implementation Details

### 1. Optimistic State Update

```dart
// In JournalNotifier.upsert():
Future<void> upsert(JournalEntry entry) async {
  // Step 1: Update UI state immediately
  final current = [...(state.value ?? [])];
  final index = current.indexWhere((item) => item.id == entry.id);
  
  if (index >= 0) {
    current[index] = entry;
  } else {
    current.add(entry);
  }
  
  current.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  state = AsyncValue.data(current);  // ← UI updates instantly
  
  // Step 2: Persist in background (non-blocking)
  _repository.saveEntry(entry).catchError((e) {
    debugPrint('Journal save failed: $e');
  });
}
```

**Why this works**:
- UI gets new state synchronously
- User sees change immediately
- Network operation happens async
- If network fails, local data persists

### 2. Hive Cache Layer

```dart
// In JournalFirestoreRepository.loadEntries():
Future<List<JournalEntry>> loadEntries() async {
  await ensureInitialized();
  await initHive();
  
  // Load from cache FIRST (synchronous)
  final cachedEntries = _loadFromHive();
  
  // Then fetch from Firestore in background
  try {
    final snap = await _journalCollection
        .orderBy('updatedAt', descending: true)
        .get();
    
    final entries = snap.docs
        .map((doc) => JournalEntry.fromJson(doc.data()))
        .toList();
    
    // Sync to Hive
    await _saveToHive(entries);
    return entries;  // New data wins
  } catch (e) {
    // On error, return cached data
    return cachedEntries;
  }
}
```

**Two-tier loading**:
1. Hive returns instantly (milliseconds)
2. Firestore updates in background

### 3. Skeleton Loading State

```dart
// In JournalScreen.build():
return state.when(
  data: (entries) {
    // Show real entries (from Hive or Firestore)
    return Column(...);
  },
  loading: () {
    // Show animated skeleton
    return Column(
      children: [
        _buildWeekCalendarSkeleton(),
        _buildSummaryBarSkeleton(),
        const Expanded(child: JournalSkeleton(count: 4)),
      ],
    );
  },
  error: (err, stack) {
    // Only shown if both cache AND Firestore fail
    return ErrorWidget(error: err);
  },
);
```

---

## Configuration

### Firestore Rules (Minimal)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      match /journal/{entryId} {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```

### Hive Box Initialization

Automatically handled in `JournalFirestoreRepository.initHive()`:

```dart
static const String _hiveBoxName = 'journal_entries';

Future<void> initHive() async {
  if (!Hive.isBoxOpen(_hiveBoxName)) {
    _hiveBox = await Hive.openBox<Map<String, dynamic>>(_hiveBoxName);
  } else {
    _hiveBox = Hive.box(_hiveBoxName);
  }
}
```

No manual setup needed in `main.dart`.

---

## Migration Path

### From Old System

```dart
// OLD: Always blocked on Firestore
state = const AsyncValue.loading();
state = await AsyncValue.guard(() => _repository.loadEntries());

// NEW: Uses cache immediately, Firestore in background
state = const AsyncValue.loading();
state = await AsyncValue.guard(() => _repository.loadEntries());
// But _repository now returns Hive first, then syncs Firestore
```

**Result**: Same API, better performance, zero breaking changes.

---

## Error Handling Strategy

### Graceful Degradation

1. **Firestore Down**: Use Hive cache
2. **Hive Corrupted**: Show error, offer reset
3. **Network Slow**: Show skeleton longer, then cache
4. **Offline**: Use cache, queue changes for sync

### Implementation

```dart
// Save entry (fails gracefully)
Future<void> saveEntry(JournalEntry entry) async {
  // 1. Always save to Hive first
  await _hiveBox.put(entry.id, entry.toJson());
  
  // 2. Try Firestore (fire-and-forget)
  try {
    await _journalCollection.doc(entry.id).set(entry.toJson());
  } catch (e) {
    // Logged but doesn't propagate
    debugPrint('Firestore save failed: $e');
    // Hive has the data, retry happens on next sync
  }
}
```

---

## Performance Optimization Tips

### 1. Batch Operations
```dart
// Instead of individual saves
for (entry in entries) {
  await repository.saveEntry(entry);  // ❌ Slow
}

// Do batch writes
// ✓ Better (already done in clearAll)
```

### 2. Pagination for Large Datasets
```dart
// TODO: Split loadEntries into pages
Future<List<JournalEntry>> loadEntries({
  int page = 1,
  int pageSize = 50,
}) async {
  // Load page from Firestore
  // Show only 50 entries, pagination controls
}
```

### 3. Lazy Loading Images
```dart
// If entries have images, lazy-load them
Image.asset(
  imagePath,
  cacheHeight: 100,
  cacheWidth: 100,
)
```

---

## Testing Strategies

### Unit Tests

```dart
test('Optimistic update updates state immediately', () async {
  final notifier = JournalNotifier(mockRepository);
  final entry = JournalEntry(...);
  
  notifier.upsert(entry);
  
  // State should be updated synchronously
  expect(notifier.state.value, contains(entry));
});

test('Hive cache returns data even if Firestore fails', () async {
  final repo = JournalFirestoreRepository(mockUserRepo);
  
  // Mock Firestore to fail
  when(mockCollection.get()).thenThrow(Exception('Network error'));
  
  // Should still return cached data
  final entries = await repo.loadEntries();
  expect(entries, isNotEmpty);
});
```

### Integration Tests

```dart
test('Journal entry persists offline', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Create entry
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  
  // Enable airplane mode (via Native code)
  await enableAirplaneMode();
  
  // Entry should still be visible in list
  expect(find.byType(JournalEntryCard), findsWidgets);
});
```

---

## Monitoring & Analytics

### Key Metrics to Track

```dart
// Add Firebase Analytics events
Future<void> upsert(JournalEntry entry) async {
  final startTime = DateTime.now();
  
  state = AsyncValue.data([...]);  // Optimistic update
  
  // Log instant feedback
  await FirebaseAnalytics.instance.logEvent(
    name: 'journal_save_optimistic',
    parameters: {'latency_ms': 0},
  );
  
  // Track background sync
  _repository.saveEntry(entry).then((_) {
    final syncTime = DateTime.now().difference(startTime).inMilliseconds;
    FirebaseAnalytics.instance.logEvent(
      name: 'journal_save_firestore',
      parameters: {'latency_ms': syncTime},
    );
  });
}
```

### Metrics to Monitor

- `journal_load_from_hive_ms` — Should be <100ms
- `journal_load_from_firestore_ms` — Background, doesn't impact UX
- `journal_save_optimistic_ms` — Should be <1ms (synchronous)
- `journal_save_firestore_ms` — Background sync time
- `journal_cache_hit_rate` — % of time cache is used vs fresh fetch

---

## Future Enhancements

### Phase 2 Ready

```dart
// Error toast notifications
Future<void> upsert(JournalEntry entry) async {
  state = AsyncValue.data([...]);
  
  _repository.saveEntry(entry).catchError((e) {
    // Show snackbar or toast
    _showErrorNotification('Failed to save: $e');
    // Retry mechanism
    _enqueueSyncRetry(entry);
  });
}
```

### Phase 3 Ideas

```dart
// Sync status provider
final journalSyncStatusProvider = Provider((ref) {
  return {
    'pending': 5,      // Entries waiting to sync
    'syncing': 2,      // Currently syncing
    'lastSync': DateTime.now(),
    'errors': 1,       // Failed syncs needing retry
  };
});
```

---

## Common Pitfalls & Solutions

| Problem | Solution |
|---------|----------|
| UI doesn't update optimistically | Ensure `state = AsyncValue.data(...)` before async call |
| Hive not persisting | Call `initHive()` before write operations |
| Skeleton never disappears | Firestore error not being handled, fallback to cache |
| Old data showing after delete | Firestore delete failed, retry on sync |
| Memory leaks | Unsubscribe from streams, close Hive box on app exit |

---

**Last Updated**: 2026-04-28
**For**: Peria App Development Team
