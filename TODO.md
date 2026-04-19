# Router Fixes TODO

## Steps:
- [x] 1. Fix syntax errors in router.dart (missing parens in routes)
- [x] 2. Declare `hasCompletedOnboarding` bool and add FirebaseAuth import
- [x] 3. Create new synchronous `routerRedirect` function without WidgetRef
- [x] 4. Update GoRouter `redirect` to use `routerRedirect`
- [x] 5. Cleanup/rename `authRedirect` in auth_guard.dart
- [x] 6. Run `flutter analyze` to verify fixes
- [ ] 7. Test navigation

Current progress: Starting step 1.

